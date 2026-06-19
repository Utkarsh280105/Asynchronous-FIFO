`timescale 1ns / 1ps
// WRITE POINTER AND FULL LOGIC
module wptr_full #(
    parameter ADDRSIZE = 4
    )(
    input  wire                wclk,
    input  wire                wrst_n,
    input  wire                wen,
    input  wire [ADDRSIZE:0]   rptr_gray_sync, // Synced Read Pointer (Gray)
    
    output reg                 wfull,
    output wire [ADDRSIZE-1:0] waddr,
    output wire [ADDRSIZE:0]   wptr_gray
     );

reg [ADDRSIZE:0] wptr_bin;
wire [ADDRSIZE:0] wptr_bin_next;
wire [ADDRSIZE:0] wptr_gray_next;

assign wptr_bin_next  = wptr_bin + (wen && !wfull);
assign wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;


always @(posedge wclk or negedge wrst_n) begin
if (!wrst_n) 
wptr_bin <= 0;
else   
wptr_bin <= wptr_bin_next;
end

always @(posedge wclk or negedge wrst_n) begin
if (!wrst_n)
wfull <= 1'b0;
else
wfull <= (wptr_gray_next =={~rptr_gray_sync[ADDRSIZE:ADDRSIZE-1],
                           rptr_gray_sync[ADDRSIZE-2:0]});
end


assign wptr_gray = wptr_gray_next;
assign waddr     = wptr_bin[ADDRSIZE-1:0];

endmodule