module reset_sync (
  input wire    clk,
  input wire    locked,
  input wire    reset,
  input wire    clk_100m,
  input wire    clk_200m,
  input wire    clk_33m,
  output wire   reset_100mo,
  output wire   reset_200mo,
  output wire   reset_33mo
);

typedef enum logic[1:0] {
  INIT      = 2'b00,
  LOCK_WAIT = 2'b01,
  REL_DELAY = 2'b10,
  ACTIVE    = 2'b11
} reset_fsm_t;

reset_fsm_t r_fsm;
reg [9:0]   r_cnt;
wire        ireset = (r_fsm != ACTIVE);

always_ff @(posedge clk) begin
  if ( reset ) begin
    r_cnt <= 10'h3ff;
    r_fsm <= INIT;
  end else begin
    case (r_fsm)
      INIT      : begin
        r_fsm <= LOCK_WAIT;
      end

      LOCK_WAIT : begin
        r_fsm <= locked ? REL_DELAY : LOCK_WAIT;
      end

      REL_DELAY : begin
        r_fsm <= (r_cnt == 10'h000) ? ACTIVE : REL_DELAY;
        r_cnt <= r_cnt - 10'h1;
      end

      ACTIVE : begin
        r_fsm <= ACTIVE;
      end
    endcase
  end
end

cdc_sync reset_sync_100m (
  .iclk   ( clk ),
  .isig   ( ireset ),
  .oclk   ( clk_100m ),
  .osigo  ( reset_100mo )
);

cdc_sync reset_sync_200m (
  .iclk   ( clk ),
  .isig   ( ireset ),
  .oclk   ( clk_200m ),
  .osigo  ( reset_200mo )
);

cdc_sync reset_sync_33m (
  .iclk   ( clk ),
  .isig   ( ireset ),
  .oclk   ( clk_33m ),
  .osigo  ( reset_33mo )
);

endmodule
