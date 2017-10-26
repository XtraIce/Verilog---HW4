`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Riker Quintana
// 
// Create Date:    13:17:38 11/15/2016 
// Design Name: 
// Module Name:    write_control_logic 
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
module write_control_logic #(DEPTH=7,WL=5)(input write_rq, [WL-1:0]data_in, output reg full, almost_full, write_en, [DEPTH_BITS-1:0]write_addr, [WL-1:0]write_data);

integer addrPtr=0;

always @(write_rq) begin 							// only sensitive if write request changes
	if(write_rq) begin
		write_en = 1;
		write_addr = addrPtr;						// write address => current address pointer value	
		addrPtr = addrPtr+1; 						//increment address pointer
	end
	
	if(addrPtr == (2**(DEPTH-1)-1)) 				// is address pointer equal to the last address block location in memory?
		full = 1; 										//the memory is full, no more writing
	else if (addrPtr == (2**(DEPTH-1)-2))		// is address pointer equal to the one before the last address block location in memory?
		almost_full =1;								//the memory is almost full. One more writable entry.
	
	write_rq = 0;										// disable write request
end

always @(full) begin								//sensitive to if ifull changes
	if(full)											
		write_en = 0;
	else
		write_en = 1;
end
