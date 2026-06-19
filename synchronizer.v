`timescale 1ns / 1ps
module synchronizer # (
parameter WIDTH = 4
)(
input   clk,
input   rst_n,
input  [WIDTH-1:0]  din,  //gray pointer input
output reg  [WIDTH-1:0]  dout    //gray pointer synchronizer output
   );
   reg  [WIDTH-1:0]  q;
 always@ (posedge clk or negedge rst_n)
 if (!rst_n)
 begin 
 q <= 0;
 dout <= 0;
 end 
 else
 begin
 q<=din;
 dout<=q;
 end
endmodule
