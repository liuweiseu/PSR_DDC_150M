`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:37:21 11/26/2017 
// Design Name: 
// Module Name:    PRECISION_ADJ 
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
module PRECISION_ADJ
#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,					//同步信号输入
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [15:0] para_in_I,
	input [15:0] para_in_Q,
	input [15:0] para_in_U,
	input [15:0] para_in_V,
	
	input [15:0] para_adj_I,
	input [15:0] para_adj_Q,
	input [15:0] para_adj_U,
	input [15:0] para_adj_V,
	
	output reg en_sync_out,					//同步信号输出
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	
	output [15:0] para_out_I,
	output [15:0] para_out_Q,
	output [15:0] para_out_U,
	output [15:0] para_out_V
    );

DATA_ADJ ADJ_I (
  .clk(clk), // input clk
  .a(para_in_I), // input [7 : 0] a
  .b(para_adj_I), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(para_out_I) // output [7 : 0] p
);

DATA_ADJ ADJ_Q (
  .clk(clk), // input clk
  .a(para_in_Q), // input [7 : 0] a
  .b(para_adj_Q), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(para_out_Q) // output [7 : 0] p
);

DATA_ADJ_N ADJ_U (
  .clk(clk), // input clk
  .a(para_in_U), // input [7 : 0] a
  .b(para_adj_U), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(para_out_U) // output [7 : 0] p
);

DATA_ADJ_N ADJ_V (
  .clk(clk), // input clk
  .a(para_in_V), // input [7 : 0] a
  .b(para_adj_V), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(para_out_V) // output [7 : 0] p
);

reg en_sync_reg1,en_sync_reg2;
reg [(BITWIDTH+1):0]cnt_sync_reg1,cnt_sync_reg2;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_reg1 <= 0;
				en_sync_reg2 <= 0;
				en_sync_out <= 0;
				cnt_sync_reg1 <= 0;
				cnt_sync_reg2 <= 0;
				cnt_sync_out <= 0;
			end
		else
			begin
				en_sync_reg1<=en_sync_in;
				en_sync_reg2<=en_sync_reg1;
				en_sync_out<=en_sync_reg2;
				cnt_sync_reg1<=cnt_sync_in;
				cnt_sync_reg2<=cnt_sync_reg1;
				cnt_sync_out<=cnt_sync_reg2;
			end
	end
endmodule
