module top_test;

//***** input port connection
logic clk;
logic reset;
logic uart_rx;
reg r_PS_SRSTB;
reg r_PS_CLK;
reg r_PS_PORB;
tri PS_SRSTB;
tri PS_CLK;
tri PS_PORB;
assign PS_SRSTB = r_PS_SRSTB;
assign PS_CLK   = r_PS_CLK;
assign PS_PORB  = r_PS_PORB;

//***** output port connection
wire ledo;
wire uart_txo;

//***** inout port connection

//***** DUT instanciation
top top0 (
  .clk ( clk ),
  .reset ( reset ),
  .uart_rx ( uart_rx ),
  .ledo ( ledo ),
  .uart_txo ( uart_txo ),

  .PS_SRSTB ( PS_SRSTB ),
  .PS_CLK   ( PS_CLK ),
  .PS_PORB  ( PS_PORB )
);

always #(4) begin
  clk <= ~clk;
end

always #(15) begin
  r_PS_CLK = ~r_PS_CLK;
end

//***** Input initialize
initial begin
  clk = 0;
  reset = 1;
  uart_rx = 0;
  
  repeat(5) @(posedge clk);
  reset = 0;
  repeat(100) @(posedge clk);
  
  uart_rx <= 1'b0;
  repeat(1085) @(posedge clk);
  uart_rx <= 1'b0;
  repeat(1085) @(posedge clk);
  uart_rx <= 1'b1;
  repeat(1085) @(posedge clk);
  uart_rx <= 1'b0;
  repeat(1085) @(posedge clk);
  uart_rx <= 1'b1;
  
  repeat(10000) @(posedge clk);
  $finish;
end

initial begin
  r_PS_CLK   = `LOW;
  r_PS_SRSTB = `ENABLE_;
  r_PS_PORB  = `ENABLE_;
  repeat(10) @(posedge PS_CLK);
  r_PS_SRSTB = `DISABLE_;
  r_PS_PORB  = `DISABLE_;
end

endmodule
