`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:08 05/02/2017 
// Design Name: 
// Module Name:    Data_out_Sel 
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
module Data_out_Sel#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	input [1:0]sel,
	
	input en_sync_in_Power,
	input [(BITWIDTH+1):0]cnt_sync_in_Power,
	input [15:0]data_in_Power,
	
	input en_sync_in_RL,
	input [(BITWIDTH+2):0]cnt_sync_in_RL,
	input [15:0]data_in_RL,
	
	input en_sync_in_IQUV,
	input [(BITWIDTH+3):0]cnt_sync_in_IQUV,
	input [15:0]data_in_IQUV,
	
	output reg en_sync_out,
	output reg [(BITWIDTH+3):0]cnt_sync_out,
	output reg [15:0]data_out
    );
	 
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_out<=0;
				cnt_sync_out<=0;
				data_out<=0;
			end
		else if(sel==0)
			begin
				en_sync_out<=en_sync_in_Power;
				cnt_sync_out<={2'b0,cnt_sync_in_Power};
				data_out<=data_in_Power;
			end
		else if(sel==1)
			begin
				en_sync_out<=en_sync_in_RL;
				cnt_sync_out<={1'b0,cnt_sync_in_RL};
				data_out<=data_in_RL;
			end
		else if(sel==2)
			begin
				en_sync_out<=en_sync_in_IQUV;
				cnt_sync_out<=cnt_sync_in_IQUV;
				data_out<=data_in_IQUV;
			end
		else if(sel==3)
			begin
				en_sync_out<=en_sync_in_RL;
				cnt_sync_out<={1'b0,cnt_sync_in_RL};
				data_out<=cnt_sync_in_RL[(BITWIDTH+2):0]; //for test
			end
	end
endmodule
