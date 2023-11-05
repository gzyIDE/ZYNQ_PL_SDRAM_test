module cdc_sync (
  input wire    iclk,
  input wire    isig,
  input wire    oclk,
  output wire   osigo
);

localparam SyncStage = 3;

reg                 r_isync;
reg [SyncStage-1:0] r_osync;

assign osigo = r_osync[SyncStage-1];

always_ff @(posedge iclk) begin
  r_isync <= isig;
end

always_ff @(posedge oclk) begin
  r_osync <= {r_osync[SyncStage-2:0], r_isync};
end

endmodule
