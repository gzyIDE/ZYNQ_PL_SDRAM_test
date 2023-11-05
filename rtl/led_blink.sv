module led_blink (
  input wire    clk,
  input wire    reset,
  output wire   ledo
);

localparam CNT = 27;
reg [CNT-1:0] cnt;

assign ledo = cnt[CNT-1];

always_ff @(posedge clk) begin
    if ( reset ) begin
        cnt <= {CNT{1'b0}};
    end else begin
        cnt <= cnt + {{CNT-1{1'b0}}, 1'b1};
    end
end

endmodule
