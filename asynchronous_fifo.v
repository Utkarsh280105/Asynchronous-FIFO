`timescale 1ns / 1ps 

module asynchronous_fifo  #(
    parameter DSIZE = 8, 
    parameter ASIZE = 4 
)(
    input  wclk, wrst_n, wen,
    input  [DSIZE-1:0] wdata,
    output wfull,
    input  rclk, rrst_n, ren,
    output [DSIZE-1:0] rdata,
    output rempty
);

wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr_gray, rptr_gray;
wire [ASIZE:0] rptr_gray_sync; 
wire [ASIZE:0] wptr_gray_sync; 

fifo_memory #(.DATASIZE(DSIZE), .ADDRSIZE(ASIZE)) fifomem (
    .wclk(wclk), .wen(wen), .wfull(wfull), 
    .waddr(waddr), .wdata(wdata),
    .raddr(raddr), .rclk(rclk), .ren(ren), 
    .rempty(rempty), .rdata(rdata)
);
    
synchronizer #(.WIDTH(ASIZE+1)) sync_r2w (
    .clk(wclk), 
    .rst_n(wrst_n),
    .din(rptr_gray),  
    .dout(rptr_gray_sync)  
);   

synchronizer #(.WIDTH(ASIZE+1)) sync_w2r (
    .clk(rclk), 
    .rst_n(rrst_n),
    .din(wptr_gray),  
    .dout(wptr_gray_sync)  
); 

rptr_empty #(.ADDRSIZE(ASIZE)) rptr_empty_inst (
    .rclk(rclk),
    .rrst_n(rrst_n),
    .ren(ren),
    .rempty(rempty),
    .raddr(raddr),
    .rptr_gray(rptr_gray),
    .wptr_gray_sync(wptr_gray_sync) 
);        

wptr_full #(.ADDRSIZE(ASIZE)) wptr_full_inst (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wen(wen),
    .wfull(wfull),
    .waddr(waddr),
    .wptr_gray(wptr_gray),
    .rptr_gray_sync(rptr_gray_sync)
);    

endmodule 