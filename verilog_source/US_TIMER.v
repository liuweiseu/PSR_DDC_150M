`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:02 09/12/2015 
// Design Name: 
// Module Name:    US_TIMER 
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
module US_TIMER#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	output reg[39:0]user_data
    );

reg [(BITWIDTH+1):0]cnt;

always @(posedge clk)
	begin
		if(rst)cnt<=8'b0;
		else if(cnt==(FFT_POINT-1))cnt<=8'b0;
				else cnt<=cnt+1;
	end

always @(posedge clk)
	begin
		if(rst)user_data<=40'b0;
		else if(cnt==(FFT_POINT-1))user_data<=user_data+1;
	end
endmodule
