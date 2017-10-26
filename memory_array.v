`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Riker Quintana
// 
// Create Date:    13:17:59 11/15/2016 
// Design Name: 
// Module Name:    memory_array 
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
module FIFO_Mem #(DEPTH=5,WL =5)(input [WL-1:0]data_in, [0:0]CLK, n_rst, write_en,  write_rq, read_rq, read_en, 
												  output reg [WL-1:0]data_out ,output reg full, almost_full, empty, almost_empty);
	//DEPTH : 0-31 address locations, Wordlength is 5bits: 0-31;
	reg [WL-1:0]FIFO_mem[0:DEPTH-1];
	reg [DEPTH:0]current_top;
	reg [DEPTH-1:0]write_ptr;
	reg [DEPTH-1:0]read_ptr;
	reg write_en_mem, read_en_mem;

	//-------------------------------------------
	always @(posedge CLK) begin: CHECK_TOP
	if(current_top == 0)begin// the stack is empty, no reading
		empty =1'b1;
		almost_empty=1'b0;
		end
	else if(current_top == 1)begin// the stack is near empty for reads
		almost_empty=1'b1;
		empty =1'b0;
		end
	else if(current_top == (1<<DEPTH)-2)begin// the stack is near full for writes
		almost_full=1'b1;
		full=1'b0;
		end
	else if(current_top == (1<<DEPTH)-1)begin// the stack is full, no writing
		full=1'b1;
		almost_full=1'b0;
		end
	else begin // else, disable all flags
		empty=1'b0;
		almost_empty=1'b0;
		almost_full=1'b0;
		full=1'b0;
		end
	end

	always @(posedge CLK) begin: CHANGE_TOP //adjust where the current top of the stack is
	if(!n_rst) //reset top of stack ptr
		current_top = 0;
	else if(((read_rq && read_en) &&  !(write_rq && write_en))&& (current_top  != 0))
		current_top = current_top-1; // decrement top of stack ptr
	else if((write_rq && write_en) &&  ! (read_rq && read_en)&& (current_top  != DEPTH))
		current_top = current_top+1; // increment top of stack ptr
	end
	

	
	always@(negedge CLK, negedge n_rst) begin: WRITE_RQ_PROCESSED
		if (!n_rst) begin// if Reset low or memory full, then write is not enabled in memory
			write_ptr <=0;
			write_en_mem <=0;
			end
		else if(full)// do not write if memory is full
			write_en_mem <= 0;
		else if(write_rq && write_en)// enable write to memory
			write_en_mem <=1;
		else
			write_en_mem <=0;
	end
	
	always@(negedge CLK, negedge n_rst) begin: READ_RQ_PROCESSED
		if (!n_rst) begin// if Reset low or memory empty, then read is not enabled in memory
			read_ptr = 0;
			read_en_mem <=0;
			end
		else if(empty)// don't read if memory is empty
			read_en_mem =0;
		else if(read_rq && read_en)// enable read memory
			read_en_mem =1;
		else
			read_en_mem =0;
	end
	
		always@(posedge CLK) begin: PROCESS_DATA
		if(!n_rst)
			data_out <= 0;
	else if(write_en_mem && read_en_mem)begin // if both enabled, read first then write
			data_out <= FIFO_mem[read_ptr];
			read_ptr <= read_ptr+1;
			FIFO_mem[write_ptr] <= data_in;
			write_ptr <= write_ptr+1;
			
			end
	else if (write_en_mem)begin // if writing enabled in memory, write to FIFO from data_in
			FIFO_mem[write_ptr] <= data_in;
			write_ptr <= write_ptr+1;

			end
	else if (read_en_mem)begin // if reading enabled in memory, read from FIFO to data_out
			data_out <= FIFO_mem[read_ptr];
			read_ptr <= read_ptr+1;
			end		
	end
endmodule
