`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 10:43:30 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
  input wire    clk,
  input wire    reset,
  output wire   ledo,
      
  input wire    uart_rx,
  output wire   uart_txo,

  inout wire    PS_SRSTB,
  inout wire    PS_CLK,
  inout wire    PS_PORB
);

wire  clk_100m;
wire  clk_200m;
wire  clk_33m;
wire  reset_100m;
wire  reset_200m;
wire  reset_33m;
wire  pll_lock;

wire          ddr_req;
wire [63:0]   ddr_wdata;
wire [7:0]    ddr_wstrb;
wire [31:0]   ddr_addr;
wire [63:0]   ddr_rdata;
wire          ddr_ready;
wire          ddr_busy;

clk_wiz0 clk_wiz_inst (
  .reset      ( reset ),
  .clk_in1    ( clk ),

  .clk_out1   ( clk_200m ),
  .clk_out2   ( clk_100m ),
  .clk_out3   ( clk_33m ),
  .locked     ( pll_lock )
);

reset_sync reset_sync0 (
  .clk          ( clk ),
  .locked       ( pll_lock ),
  .reset        ( reset ),
  .clk_100m     ( clk_100m ),
  .clk_200m     ( clk_200m ),
  .clk_33m      ( clk_33m ),
  .reset_100mo  ( reset_100m ),
  .reset_200mo  ( reset_200m ),
  .reset_33mo   ( reset_33m )
);

led_blink led_blink0 (
  .clk          ( clk_100m ),
  .reset        ( reset_100m ),
  .ledo         ( ledo )
);

uart_buffering uart_buffering0 (
  .clk          ( clk_200m ),
  .reset        ( reset_200m ),

  .ddr_req      ( ddr_req ),
  .ddr_wdata    ( ddr_wdata ),
  .ddr_wstrb    ( ddr_wstrb ),
  .ddr_addr     ( ddr_addr ),
  .ddr_rdata    ( ddr_rdata ),
  .ddr_ready    ( ddr_ready ),
  .ddr_busy     ( ddr_busy ),

  .uart_rx      ( uart_rx ),
  .uart_txo     ( uart_txo )
);

wire        S_AXI_HP0_ARREADY;
wire        S_AXI_HP0_AWREADY;
wire        S_AXI_HP0_BVALID;
wire        S_AXI_HP0_RLAST;
wire        S_AXI_HP0_RVALID;
wire        S_AXI_HP0_WREADY;
wire [1:0]  S_AXI_HP0_BRESP;
wire [1:0]  S_AXI_HP0_RRESP;
wire [5:0]  S_AXI_HP0_BID;
wire [5:0]  S_AXI_HP0_RID;
wire [63:0] S_AXI_HP0_RDATA;
wire [7:0]  S_AXI_HP0_RCOUNT;
wire [7:0]  S_AXI_HP0_WCOUNT;
wire [2:0]  S_AXI_HP0_RACOUNT;
wire [5:0]  S_AXI_HP0_WACOUNT;
wire        S_AXI_HP0_ARVALID;
wire        S_AXI_HP0_AWVALID;
wire        S_AXI_HP0_BREADY;
wire        S_AXI_HP0_RDISSUECAP1_EN = 0;
wire        S_AXI_HP0_RREADY;
wire        S_AXI_HP0_WLAST;
wire        S_AXI_HP0_WRISSUECAP1_EN;
wire        S_AXI_HP0_WVALID;
wire [1:0]  S_AXI_HP0_ARBURST;
wire [1:0]  S_AXI_HP0_ARLOCK  = 2'b00;
wire [2:0]  S_AXI_HP0_ARSIZE;
wire [1:0]  S_AXI_HP0_AWBURST;
wire [1:0]  S_AXI_HP0_AWLOCK  = 2'b00;
wire [2:0]  S_AXI_HP0_AWSIZE;
wire [2:0]  S_AXI_HP0_ARPROT  = 3'b000;
wire [2:0]  S_AXI_HP0_AWPROT  = 3'b000;
wire [31:0] S_AXI_HP0_ARADDR;
wire [31:0] S_AXI_HP0_AWADDR;
wire [3:0]  S_AXI_HP0_ARCACHE = 4'b0000;
wire [3:0]  S_AXI_HP0_ARLEN;
wire [3:0]  S_AXI_HP0_ARQOS   = 4'b0000;
wire [3:0]  S_AXI_HP0_AWCACHE = 4'b0000;
wire [3:0]  S_AXI_HP0_AWLEN;
wire [3:0]  S_AXI_HP0_AWQOS   = 4'b0000;
wire [5:0]  S_AXI_HP0_ARID;
wire [5:0]  S_AXI_HP0_AWID;
wire [5:0]  S_AXI_HP0_WID = 6'h0;
wire [63:0] S_AXI_HP0_WDATA;
wire [7:0]  S_AXI_HP0_WSTRB;

axi2lbus_bridge #(
  .AddrW  ( 32 ),
  .DataW  ( 64 ),
  .AxiIdW ( 6 )
) axi2lbus_bridge (
  .clk          ( clk_200m ),
  .reset        ( reset_200m ),

  .bus_req      ( ddr_req ),
  .bus_id       ( 0 ),
  .bus_strb     ( ddr_wstrb ),
  .bus_addr     ( ddr_addr ),
  .bus_wdata    ( ddr_wdata ),
  .bus_readyo   ( ddr_ready ),
  .bus_ido      (),
  .bus_rdatao   ( ddr_rdata ),
  .bus_busyo    ( ddr_busy ),

  .axi_wready   ( S_AXI_HP0_WREADY ),
  .axi_awready  ( S_AXI_HP0_AWREADY ),
  .axi_awido    ( S_AXI_HP0_AWID ),
  .axi_awaddro  ( S_AXI_HP0_AWADDR ),
  .axi_awleno   ( S_AXI_HP0_AWLEN ),
  .axi_awsizeo  ( S_AXI_HP0_AWSIZE ),
  .axi_awbursto ( S_AXI_HP0_AWBURST ),
  .axi_awvalido ( S_AXI_HP0_AWVALID ),
  .axi_wdatao   ( S_AXI_HP0_WDATA ),
  .axi_wstrbo   ( S_AXI_HP0_WSTRB ),
  .axi_wlasto   ( S_AXI_HP0_WLAST ),
  .axi_wvalido  ( S_AXI_HP0_WVALID ),

  .axi_bvalid   ( S_AXI_HP0_BVALID ),
  .axi_breadyo  ( S_AXI_HP0_BREADY ),

  .axi_arready  ( S_AXI_HP0_ARREADY ),
  .axi_arido    ( S_AXI_HP0_ARID ),
  .axi_araddro  ( S_AXI_HP0_ARADDR ),
  .axi_arleno   ( S_AXI_HP0_ARLEN ),
  .axi_arsizeo  ( S_AXI_HP0_ARSIZE ),
  .axi_arvalido ( S_AXI_HP0_ARVALID ),
  .axi_arbursto ( S_AXI_HP0_ARBURST ),

  .axi_rdata    ( S_AXI_HP0_RDATA ),
  .axi_rvalid   ( S_AXI_HP0_RVALID ),
  .axi_rreadyo  ( S_AXI_HP0_RREADY )
);

processing_system7A zynq0 (
  .S_AXI_HP0_ARREADY  (S_AXI_HP0_ARREADY),                // output wire S_AXI_HP0_ARREADY
  .S_AXI_HP0_AWREADY  (S_AXI_HP0_AWREADY),                // output wire S_AXI_HP0_AWREADY
  .S_AXI_HP0_BVALID   (S_AXI_HP0_BVALID),                  // output wire S_AXI_HP0_BVALID
  .S_AXI_HP0_RLAST    (S_AXI_HP0_RLAST),                    // output wire S_AXI_HP0_RLAST
  .S_AXI_HP0_RVALID   (S_AXI_HP0_RVALID),                  // output wire S_AXI_HP0_RVALID
  .S_AXI_HP0_WREADY   (S_AXI_HP0_WREADY),                  // output wire S_AXI_HP0_WREADY
  .S_AXI_HP0_BRESP    (S_AXI_HP0_BRESP),                    // output wire [1 : 0] S_AXI_HP0_BRESP
  .S_AXI_HP0_RRESP    (S_AXI_HP0_RRESP),                    // output wire [1 : 0] S_AXI_HP0_RRESP
  .S_AXI_HP0_BID      (S_AXI_HP0_BID),                        // output wire [5 : 0] S_AXI_HP0_BID
  .S_AXI_HP0_RID      (S_AXI_HP0_RID),                        // output wire [5 : 0] S_AXI_HP0_RID
  .S_AXI_HP0_RDATA    (S_AXI_HP0_RDATA),                    // output wire [63 : 0] S_AXI_HP0_RDATA
  .S_AXI_HP0_RCOUNT   (S_AXI_HP0_RCOUNT),                  // output wire [7 : 0] S_AXI_HP0_RCOUNT
  .S_AXI_HP0_WCOUNT   (S_AXI_HP0_WCOUNT),                  // output wire [7 : 0] S_AXI_HP0_WCOUNT
  .S_AXI_HP0_RACOUNT  (S_AXI_HP0_RACOUNT),                // output wire [2 : 0] S_AXI_HP0_RACOUNT
  .S_AXI_HP0_WACOUNT  (S_AXI_HP0_WACOUNT),                // output wire [5 : 0] S_AXI_HP0_WACOUNT

  .S_AXI_HP0_ACLK     ( clk_200m ),                      // input wire S_AXI_HP0_ACLK
  .S_AXI_HP0_ARVALID  (S_AXI_HP0_ARVALID),                // input wire S_AXI_HP0_ARVALID
  .S_AXI_HP0_AWVALID  (S_AXI_HP0_AWVALID),                // input wire S_AXI_HP0_AWVALID
  .S_AXI_HP0_BREADY   (S_AXI_HP0_BREADY),                  // input wire S_AXI_HP0_BREADY
  .S_AXI_HP0_RDISSUECAP1_EN(S_AXI_HP0_RDISSUECAP1_EN),  // input wire S_AXI_HP0_RDISSUECAP1_EN
  .S_AXI_HP0_RREADY   (S_AXI_HP0_RREADY),                  // input wire S_AXI_HP0_RREADY
  .S_AXI_HP0_WLAST    (S_AXI_HP0_WLAST),                    // input wire S_AXI_HP0_WLAST
  .S_AXI_HP0_WRISSUECAP1_EN(S_AXI_HP0_WRISSUECAP1_EN),  // input wire S_AXI_HP0_WRISSUECAP1_EN
  .S_AXI_HP0_WVALID   (S_AXI_HP0_WVALID),                  // input wire S_AXI_HP0_WVALID
  .S_AXI_HP0_ARBURST  (S_AXI_HP0_ARBURST),                // input wire [1 : 0] S_AXI_HP0_ARBURST
  .S_AXI_HP0_ARLOCK   (S_AXI_HP0_ARLOCK),                  // input wire [1 : 0] S_AXI_HP0_ARLOCK
  .S_AXI_HP0_ARSIZE   (S_AXI_HP0_ARSIZE),                  // input wire [2 : 0] S_AXI_HP0_ARSIZE
  .S_AXI_HP0_AWBURST  (S_AXI_HP0_AWBURST),                // input wire [1 : 0] S_AXI_HP0_AWBURST
  .S_AXI_HP0_AWLOCK   (S_AXI_HP0_AWLOCK),                  // input wire [1 : 0] S_AXI_HP0_AWLOCK
  .S_AXI_HP0_AWSIZE   (S_AXI_HP0_AWSIZE),                  // input wire [2 : 0] S_AXI_HP0_AWSIZE
  .S_AXI_HP0_ARPROT   (S_AXI_HP0_ARPROT),                  // input wire [2 : 0] S_AXI_HP0_ARPROT
  .S_AXI_HP0_AWPROT   (S_AXI_HP0_AWPROT),                  // input wire [2 : 0] S_AXI_HP0_AWPROT
  .S_AXI_HP0_ARADDR   (S_AXI_HP0_ARADDR),                  // input wire [31 : 0] S_AXI_HP0_ARADDR
  .S_AXI_HP0_AWADDR   (S_AXI_HP0_AWADDR),                  // input wire [31 : 0] S_AXI_HP0_AWADDR
  .S_AXI_HP0_ARCACHE  (S_AXI_HP0_ARCACHE),                // input wire [3 : 0] S_AXI_HP0_ARCACHE
  .S_AXI_HP0_ARLEN    (S_AXI_HP0_ARLEN),                    // input wire [3 : 0] S_AXI_HP0_ARLEN
  .S_AXI_HP0_ARQOS    (S_AXI_HP0_ARQOS),                    // input wire [3 : 0] S_AXI_HP0_ARQOS
  .S_AXI_HP0_AWCACHE  (S_AXI_HP0_AWCACHE),                // input wire [3 : 0] S_AXI_HP0_AWCACHE
  .S_AXI_HP0_AWLEN    (S_AXI_HP0_AWLEN),                    // input wire [3 : 0] S_AXI_HP0_AWLEN
  .S_AXI_HP0_AWQOS    (S_AXI_HP0_AWQOS),                    // input wire [3 : 0] S_AXI_HP0_AWQOS
  .S_AXI_HP0_ARID     (S_AXI_HP0_ARID),                      // input wire [5 : 0] S_AXI_HP0_ARID
  .S_AXI_HP0_AWID     (S_AXI_HP0_AWID),                      // input wire [5 : 0] S_AXI_HP0_AWID
  .S_AXI_HP0_WID      (S_AXI_HP0_WID),                        // input wire [5 : 0] S_AXI_HP0_WID
  .S_AXI_HP0_WDATA    (S_AXI_HP0_WDATA),                    // input wire [63 : 0] S_AXI_HP0_WDATA
  .S_AXI_HP0_WSTRB    (S_AXI_HP0_WSTRB),                    // input wire [7 : 0] S_AXI_HP0_WSTRB
  .PS_SRSTB           ( PS_SRSTB ),
  .PS_CLK             ( PS_CLK ),
  .PS_PORB            ( PS_PORB )
);

endmodule
