`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:28:38 10/22/2018 
// Design Name: 
// Module Name:    DELAY_MODULE 
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
module DELAY_MODULE
#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	//input rst,
	
	input en_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	input [15:0] din0,
	input [15:0] din1,
	input [15:0] din2,
	input [15:0] din3,
	
	output reg en_sync_out,
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	output reg [15:0] dout0,
	output reg [15:0] dout1,
	output reg [15:0] dout2,
	output reg [15:0] dout3
    );
	 
always @(posedge clk)
	begin
		//if(rst)
		//	begin
		//		en_sync_out<=0;
		//		cnt_sync_out<=0;
		//		dout0<=0;
		//		dout1<=0;
		//		dout2<=0;
		//		dout3<=0;
		//	end
		//else
			begin
				en_sync_out<=en_sync_in;
				cnt_sync_out<=cnt_sync_in;
				dout0<=din0;
				dout1<=din1;
				dout2<=din2;
				dout3<=din3;
			end
	end


endmodule
