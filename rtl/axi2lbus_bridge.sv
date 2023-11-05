/*
* <axi2lbus_bridge.sv>
* Local lbus to/from AXI3 bridge
* 
* Copyright (c) 2023 Yosuke Ide <gizaneko@outlook.jp>
* 
* This software is released under the MIT License.
* http://opensource.org/licenses/mit-license.php
*/

`include "stddef.vh"
`include "axi.svh"

`default_nettype none

module axi2lbus_bridge #(
  //parameter BufD      = 1,
  parameter AddrW     = 8,
  parameter DataW     = 32,
  parameter IdW       = 2,
  parameter AxiIdW    = 4,
  // Constant
  parameter StrbW     = DataW / `BYTE,
  parameter AxiBlenW  = `AXI3_LEN_W
)( 
  input wire                  clk,
  input wire                  reset,

  // internal bus request
  input wire                  bus_req,
  input wire [IdW-1:0]        bus_id,
  input wire [StrbW-1:0]      bus_strb,
  input wire [AddrW-1:0]      bus_addr,
  input wire [DataW-1:0]      bus_wdata,
  output wire                 bus_readyo,
  output wire [IdW-1:0]       bus_ido,
  output wire [DataW-1:0]     bus_rdatao,
  output wire                 bus_busyo,

  // AXI write request
  input wire                  axi_wready,
  input wire                  axi_awready,
  output wire [AxiIdW-1:0]    axi_awido,
  output wire [AddrW-1:0]     axi_awaddro,
  output wire [AxiBlenW-1:0]  axi_awleno,
  output wire axi3_size_t     axi_awsizeo,
  output wire axi3_bst_t      axi_awbursto,
  output wire                 axi_awvalido,
  output wire [DataW-1:0]     axi_wdatao,
  output wire [StrbW-1:0]     axi_wstrbo,
  output wire                 axi_wlasto,
  output wire                 axi_wvalido,

  // AXI write response
  //input wire [AxiIdW-1:0]     axi_bid,
  //input wire axi3_resp_t      axi_bresp,
  input wire                  axi_bvalid,
  output wire                 axi_breadyo,

  // AXI read request
  input wire                  axi_arready,
  output wire [AxiIdW-1:0]    axi_arido,
  output wire [AddrW-1:0]     axi_araddro,
  output wire [AxiBlenW-1:0]  axi_arleno,
  output wire axi3_size_t     axi_arsizeo,
  output wire                 axi_arvalido,
  output wire axi3_bst_t      axi_arbursto,

  // AXI read response
  //input wire [AxiIdW-1:0]     axi_rid,
  input wire [DataW-1:0]      axi_rdata,
  //input wire axi3_resp_t      axi_rresp,
  //input wire                  axi_rlast,
  input wire                  axi_rvalid,
  output wire                 axi_rreadyo
);

//***** local parameters
typedef enum logic[2:0] {
  ST_IDLE       = 3'b000,
  ST_READ_AD    = 3'b001,
  ST_READ       = 3'b010,
  ST_READ_READY = 3'b011,
  ST_WRITE_AD   = 3'b100,
  ST_WRITE      = 3'b101,
  ST_WRITE_RESP = 3'b110
} req_fsm_t;

typedef struct packed {
  logic [IdW-1:0]   id;
  logic [StrbW-1:0] strb;
  logic [AddrW-1:0] addr;
  logic [DataW-1:0] data;
} req_entry_t;


//***** internal wires
wire req_entry_t new_entry = '{id: bus_id,
                               strb: bus_strb,
                               addr: bus_addr,
                               data: bus_wdata};

//***** sequential logics
reg           r_valid;
req_fsm_t     r_state;
req_entry_t   r_entry;


//***** combinatinal logics
logic         c_wreq;
logic         c_rreq;
logic         c_bus_ready;
logic         c_arvalid;
logic         c_rready;
logic         c_awvalid;
logic         c_wvalid;
logic         c_bready;
axi3_size_t   c_size_dec;
always_comb begin
  c_rreq = bus_req && !(|bus_strb);
  c_wreq = bus_req &&  (|bus_strb);

  c_bus_ready = (r_state == ST_READ_READY) || ((r_state == ST_IDLE) && c_wreq);

  c_arvalid = (r_state == ST_READ_AD);
  c_rready  = (r_state == ST_READ);
  c_awvalid = (r_state == ST_WRITE_AD);
  c_wvalid  = (r_state == ST_WRITE);
  c_bready  = (r_state == ST_WRITE_RESP);

  case ( DataW/`BYTE )
    1:        c_size_dec = SIZE_1B;
    2:        c_size_dec = SIZE_2B;
    4:        c_size_dec = SIZE_4B;
    8:        c_size_dec = SIZE_8B;
    16:       c_size_dec = SIZE_16B;
    32:       c_size_dec = SIZE_32B;
    64:       c_size_dec = SIZE_64B;
    128:      c_size_dec = SIZE_128B;
    default:  c_size_dec = SIZE_1B;
  endcase
end


//***** output
//*** bus
assign bus_rdatao   = r_entry.data;
assign bus_readyo   = c_bus_ready;
assign bus_ido      = r_entry.id;
assign bus_busyo    = r_valid;
//*** write request
assign axi_awido    = `ZERO(AxiIdW);
assign axi_awaddro  = r_entry.addr;
assign axi_wdatao   = r_entry.data;
assign axi_wstrbo   = r_entry.strb;
assign axi_awleno   = `ZERO(AxiBlenW); // burst = 1
assign axi_wlasto   = `ENABLE;
assign axi_awbursto = BST_INCR;
assign axi_awsizeo  = c_size_dec;
assign axi_awvalido = c_awvalid;
assign axi_wvalido  = c_wvalid;
//*** write response
assign axi_breadyo  = c_bready;
//*** read request
assign axi_arido    = `ZERO(AxiIdW);
assign axi_araddro  = r_entry.addr;
assign axi_arleno   = `ZERO(AxiBlenW); // burst = 1
assign axi_arbursto = BST_INCR;
assign axi_arsizeo  = c_size_dec;
assign axi_arvalido = c_arvalid;
//*** read response
assign axi_rreadyo  = c_rready;


always_ff @(posedge clk) begin
  if ( reset ) begin
    r_valid <= `DISABLE;
    r_state <= ST_IDLE;
    r_entry <= `ZERO($bits(req_entry_t));
  end else begin

    case ( r_state )
      ST_IDLE : begin
        if ( bus_req ) begin
          r_valid <= `ENABLE;
          r_entry <= new_entry;
          r_state <= c_rreq ? ST_READ_AD : ST_WRITE_AD;
        end
      end

      ST_READ_AD : begin
        if ( axi_arready ) begin
          r_state <= ST_READ;
        end
      end

      ST_READ : begin
        if ( axi_rvalid ) begin
          r_state      <= ST_READ_READY;
          r_entry.data <= axi_rdata;
        end
      end

      ST_READ_READY : begin
        r_state <= ST_IDLE;
        r_valid <= `DISABLE;
      end

      ST_WRITE_AD : begin
        if ( axi_awready ) begin
          r_state <= ST_WRITE;
        end
      end

      ST_WRITE : begin
        if ( axi_wready ) begin
          r_state <= ST_WRITE_RESP;
        end
      end

      ST_WRITE_RESP : begin
        if ( axi_bvalid ) begin
          r_state <= ST_IDLE;
          r_valid <= `DISABLE;
        end
      end

      default : begin
        r_state <= ST_IDLE;
        r_valid <= `DISABLE;
      end
    endcase
  end
end

endmodule

`default_nettype wire
