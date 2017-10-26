`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Riker Quintana
// 
// Create Date:    13:16:28 11/15/2016 
// Design Name: 
// Module Name:    read_control_logic 
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
module read_control_logic #(DEPTH=7,WL=5)(input read_rq, output reg empty, almost_empty, read_en, [DEPTH_BITS-1:0]read_addr);

integer 	addrPtr=0;

			
always @(read_rq) begin 							// only sensitive if write request changes
	if(read_rq) begin

		read_addr = addrPtr;						// write address => current address pointer value	
		addrPtr = addrPtr+1; 						//increment address pointer
	end
	
	if(addrPtr == (2**(DEPTH-1)-1)) 				// is address pointer equal to the last address block location in memory?
		empty = 1; 										//the memory is empty, no more writing
	else if (addrPtr == (2**(DEPTH-1)-2))		// is address pointer equal to the one before the last address block location in memory?
		almost_empty =1;								//the memory is almost empty. One more readable entry.

	read_en = 0;
	read_rq = 0;										// disable read request
end

always @(empty) 							//sensitive to if empty changes
	if(empty)											
		read_en = 0;
	else
		read_en = 1;
endmodule
