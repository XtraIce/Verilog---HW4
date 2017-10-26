`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Riker Quintana
// 
// Create Date:    01:37:51 11/21/2016 
// Design Name: 
// Module Name:    FIFO_Mem_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIFO_Mem_tb();
parameter DEPTH=5, WL =5;
reg [WL-1:0]data_in;
reg clk,n_rst,write_req,read_req;
wire [WL-1:0]data_out;
wire full, almost_full, empty, almost_empty;

FIFO_Mem DUT00(.data_in(data_in),.CLK(clk),.n_rst(n_rst), .write_en(1'b1), .write_rq(write_req), .read_rq(read_req), .read_en(1'b1), 
					.data_out(data_out) ,.full(full), .almost_full(almost_full), .empty(empty), .almost_empty(almost_empty));

parameter PERIOD = 10;

initial begin: CLOCK_CYCLE
clk=1;
forever
#PERIOD clk = ~clk; 
end

initial begin
n_rst = 1'b0; read_req = 1'b0; write_req = 1'b1;
@(posedge clk)
@(posedge clk)data_in = 0;n_rst = 1'b1;
@(posedge clk)data_in = 1;
@(posedge clk)data_in = 2;
@(posedge clk)write_req = 1'b0;read_req = 1'b1;
@(posedge clk)data_in = 3;read_req = 1'b1; write_req = 1'b1;
@(posedge clk)write_req = 1'b0;read_req = 1'b1;
@(posedge clk)
@(posedge clk)data_in =25;read_req = 1'b0; write_req = 1'b1;
@(posedge clk)write_req = 1'b0;read_req = 1'b1;
@(posedge clk)
@(posedge clk) read_req = 1'b0; write_req = 1'b0;
@(posedge clk) $finish;
end

endmodule
