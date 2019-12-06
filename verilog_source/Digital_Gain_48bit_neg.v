`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:07 10/14/2016 
// Design Name: 
// Module Name:    Digital_Gain 
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
module Digital_Gain_48bit_neg#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	input ms_in,
	
	input en_sync_in,
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [47:0]para_in0,
//	input [47:0]para_in1,
//	input [47:0]para_in2,
//	input [47:0]para_in3,
	
	input [15:0]scaled_coeff,//其实这里只需要6bit就够了，为了与之前的设计兼容，所以这里采用的是16bit
	
	output [15:0]para_out0,
//	output [15:0]para_out1,
//	output [15:0]para_out2,
//	output [15:0]para_out3,
	
	output reg en_sync_out,
//	output reg [(BITWIDTH-1):0]cnt_sync_out,
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	output [47:0]max
    );
//找出最大值并输出
Get_Max_48bit_neg Get_Max_Para(
    .clk(clk), 
    .rst(rst), 
    .ms_in(ms_in), 
    .data0(para_in0), 
//    .data1(para_in1), 
//    .data2(para_in2), 
//    .data3(para_in3), 
    .max(max)
    );
//做移位操作，选出合适的16bit
adjust_48bit adjust0(
    .clk(clk), 
    .rst(rst), 
    .scaled_coeff(scaled_coeff), 
    .para_in(para_in0), 
    .para_out(para_out0)
    );
	 
//adjust_48bit adjust1(
//    .clk(clk), 
//    .rst(rst), 
//    .scaled_coeff(scaled_coeff), 
//    .para_in(para_in1), 
//    .para_out(para_out1)
//    );
//	 
//adjust_48bit adjust2(
//    .clk(clk), 
//    .rst(rst), 
//    .scaled_coeff(scaled_coeff), 
//    .para_in(para_in2), 
//    .para_out(para_out2)
//    );
//	 
//adjust_48bit adjust3(
//    .clk(clk), 
//    .rst(rst), 
//    .scaled_coeff(scaled_coeff), 
//    .para_in(para_in3), 
//    .para_out(para_out3)
//    );
//同步信号输出
reg en_sync_in0;
//reg [(BITWIDTH-1):0]cnt_sync_in0;
reg [(BITWIDTH+1):0]cnt_sync_in0;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_in0<=0;
				en_sync_out<=0;
				
				cnt_sync_in0<=0;
				cnt_sync_out<=0;
			end
		else
			begin
				en_sync_in0<=en_sync_in;
				en_sync_out<=en_sync_in0;
				
				cnt_sync_in0<=cnt_sync_in;
				cnt_sync_out<=cnt_sync_in0;
			end
	end
endmodule
