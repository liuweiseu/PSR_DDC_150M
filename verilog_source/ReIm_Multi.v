`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:45:46 05/23/2017 
// Design Name: 
// Module Name:    ReIm_Multi 
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
module ReIm_Multi#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [22:0]re_in0,	//输入系数
//	input [22:0]re_in1,
//	input [22:0]re_in2,
//	input [22:0]re_in3,
	input [22:0]im_in0,
//	input [22:0]im_in1,
//	input [22:0]im_in2,
//	input [22:0]im_in3,
	
	input [15:0]para0,	//均衡系数
//	input [15:0]para1,
//	input [15:0]para2,
//	input [15:0]para3,
	
	output reg en_sync_out,
//	output reg [(BITWIDTH-1):0]cnt_sync_out,
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	
	output [22:0]re_out0,
//	output [22:0]re_out1,
//	output [22:0]re_out2,
//	output [22:0]re_out3,
	output [22:0]im_out0
//	output [22:0]im_out1,
//	output [22:0]im_out2,
//	output [22:0]im_out3
    );

FreqEqua_Multi Multi_Re0(
  .clk(clk), // input clk
  .a(re_in0), // input [22 : 0] a
  .b(para0), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(re_out0) // output [22 : 0] p
);

FreqEqua_Multi Multi_Im0(
  .clk(clk), // input clk
  .a(im_in0), // input [22 : 0] a
  .b(para0), // input [15 : 0] b
  .sclr(rst), // input sclr
  .p(im_out0) // output [22 : 0] p
);

//FreqEqua_Multi Multi_Re1(
//  .clk(clk), // input clk
//  .a(re_in1), // input [22 : 0] a
//  .b(para1), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(re_out1) // output [22 : 0] p
//);
//
//FreqEqua_Multi Multi_Im1(
//  .clk(clk), // input clk
//  .a(im_in1), // input [22 : 0] a
//  .b(para1), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(im_out1) // output [22 : 0] p
//);
//
//FreqEqua_Multi Multi_Re2(
//  .clk(clk), // input clk
//  .a(re_in2), // input [22 : 0] a
//  .b(para2), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(re_out2) // output [22 : 0] p
//);
//
//FreqEqua_Multi Multi_Im2(
//  .clk(clk), // input clk
//  .a(im_in2), // input [22 : 0] a
//  .b(para2), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(im_out2) // output [22 : 0] p
//);
//
//FreqEqua_Multi Multi_Re3(
//  .clk(clk), // input clk
//  .a(re_in3), // input [22 : 0] a
//  .b(para3), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(re_out3) // output [22 : 0] p
//);
//
//FreqEqua_Multi Multi_Im3(
//  .clk(clk), // input clk
//  .a(im_in3), // input [22 : 0] a
//  .b(para3), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(im_out3) // output [22 : 0] p
//);

//同步信号输出
reg en_sync_reg1,en_sync_reg2,en_sync_reg3;
//reg [(BITWIDTH-1):0]cnt_sync_reg1,cnt_sync_reg2,cnt_sync_reg3;
reg [(BITWIDTH+1):0]cnt_sync_reg1,cnt_sync_reg2,cnt_sync_reg3;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_reg1<=0;
				en_sync_reg2<=0;

				cnt_sync_reg1<=0;
				cnt_sync_reg2<=0;

				en_sync_out<=0;
				cnt_sync_out<=0;
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
