`timescale 1ns / 1ps 
//READ POINTER AND EMPTY LOGIC 
module rptr_empty #(
parameter ADDRSIZE = 4
  )(
input rclk,
input rrst_n,
input ren,
input [ADDRSIZE:0] wptr_gray_sync,   //Write pointer (Gray) synchronized into read clock domain
output reg rempty,
output [ADDRSIZE-1:0] raddr,
output [ADDRSIZE:0]   rptr_gray   //The extra MSB is used for wrap detection and empty/full logic, not for addressing
    );
    
reg [ADDRSIZE:0] rptr_bin;   //The extra MSB is used for wrap detection and empty/full logic, not for addressing
wire [ADDRSIZE:0] rptr_bin_next;
wire [ADDRSIZE:0] rptr_gray_next;

assign rptr_bin_next  = rptr_bin + (ren && !rempty);
assign rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    
always @(posedge rclk or negedge rrst_n) begin
if (!rrst_n) 
rptr_bin <= 0;
else if (ren && !rempty)
rptr_bin <= rptr_bin_next;
end
    
always @(posedge rclk or negedge rrst_n) begin
if (!rrst_n)
rempty <= 1'b1;
 else
rempty <= (rptr_gray_next == wptr_gray_sync);
end
   
assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
assign raddr = rptr_bin[ADDRSIZE-1:0];     
 
endmodule
