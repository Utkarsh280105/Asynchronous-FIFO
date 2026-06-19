`timescale 1ns / 1ps

module fifo_tb;

 parameter DSIZE = 8;
 parameter ASIZE = 4;
 localparam DEPTH = 1 << ASIZE;

 reg  wclk, wrst_n, wen;
 reg  [DSIZE-1:0] wdata;

 reg  rclk, rrst_n, ren;
 wire [DSIZE-1:0] rdata;
 wire wfull, rempty;

 integer i;

 // DUT
 asynchronous_fifo #(
     .DSIZE(DSIZE),
     .ASIZE(ASIZE)
 ) dut (
     .wclk(wclk),
     .wrst_n(wrst_n),
     .wen(wen),
     .wdata(wdata),
     .wfull(wfull),
     .rclk(rclk),
     .rrst_n(rrst_n),
     .ren(ren),
     .rdata(rdata),
     .rempty(rempty)
 );


initial wclk = 0;
always #5 wclk = ~wclk;


initial rclk = 0;
always #12.5 rclk = ~rclk;

initial begin
wen = 0;
ren = 0;
wdata = 0;
wrst_n = 0;
rrst_n = 0;

repeat (5) @(posedge wclk);
wrst_n = 1;
repeat (5) @(posedge rclk);
rrst_n = 1;

 $display("Writing FIFO");

 for (i = 0; i < DEPTH; i = i + 1) begin
     @(posedge wclk);
     if (!wfull) begin
         wen   = 1;
         wdata = i;
     end
 end

 @(posedge wclk);
 wen = 0;

 repeat (4) @(posedge wclk);

 if (wfull)
     $display("FIFO is FULL");
 else
     $display("FIFO should be FULL");



$display("Reading FIFO");

for (i = 0; i < DEPTH; i = i + 1) begin
    @(posedge rclk);
    if (!rempty) begin
        ren = 1;
    end

    @(posedge rclk);
    $display("Read Data = %0d, Expected = %0d", rdata, i);
end

@(posedge rclk);
ren = 0;

repeat (4) @(posedge rclk);

if (rempty)
    $display("FIFO is EMPTY");
else
    $display("FIFO should be EMPTY");

$finish;
    end

endmodule
