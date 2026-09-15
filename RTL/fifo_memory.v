`timescale 1ns / 1ps 
module fifo_memory #(
parameter DATASIZE = 8, 
parameter ADDRSIZE = 4
)(
input wclk,
input wen,
input wfull,
input [ADDRSIZE-1:0] waddr,
input [DATASIZE-1:0] wdata,

input rclk,
input ren,
input rempty,
input [ADDRSIZE-1:0] raddr,
output reg [DATASIZE-1:0] rdata
    );
    
reg [DATASIZE-1:0] mem [0:(1<<ADDRSIZE)-1];  //(1 << ADDRSIZE) = 2^ADDRSIZE

always@(posedge wclk)
begin
if (wen && (!wfull))
mem[waddr] <= wdata;
end

always@(posedge rclk)
begin
if (ren && (!rempty))
rdata <= mem[raddr];
end
endmodule
