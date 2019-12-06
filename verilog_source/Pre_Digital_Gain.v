`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:37 10/14/2016 
// Design Name: 
// Module Name:    Pre_Digital_Gain 
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
module Pre_Digital_Gain#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	input ms_in,
	
	input [15:0]scaled_coeff_I,	//系数输入
	input [15:0]scaled_coeff_Q,
	input [15:0]scaled_coeff_U,
	input [15:0]scaled_coeff_V,
	
	input en_sync_in,					//同步信号输入
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [47:0]para_in_I0,			//数据输入
//	input [47:0]para_in_I1,
//	input [47:0]para_in_I2,
//	input [47:0]para_in_I3,
	
	input [47:0]para_in_Q0,
//	input [47:0]para_in_Q1,
//	input [47:0]para_in_Q2,
//	input [47:0]para_in_Q3,
	
	input [47:0]para_in_U0,
//	input [47:0]para_in_U1,
//	input [47:0]para_in_U2,
//	input [47:0]para_in_U3,
	
	input [47:0]para_in_V0,
//	input [47:0]para_in_V1,
//	input [47:0]para_in_V2,
//	input [47:0]para_in_V3,
	
	output en_sync_out,
//	output [(BITWIDTH-1):0]cnt_sync_out,
	output [(BITWIDTH+1):0]cnt_sync_out,
	
	output [15:0]para_out_I0,
//	output [15:0]para_out_I1,
//	output [15:0]para_out_I2,
//	output [15:0]para_out_I3,
	
	output [15:0]para_out_Q0,
//	output [15:0]para_out_Q1,
//	output [15:0]para_out_Q2,
//	output [15:0]para_out_Q3,

	output [15:0]para_out_U0,
//	output [15:0]para_out_U1,
//	output [15:0]para_out_U2,
//	output [15:0]para_out_U3,
	
	output [15:0]para_out_V0,
//	output [15:0]para_out_V1,
//	output [15:0]para_out_V2,
//	output [15:0]para_out_V3,
	
	output [47:0]max_I,
	output [47:0]max_Q,
	output [47:0]max_U,
	output [47:0]max_V
    );
//I参数增益控制，从那个48bit里选出16bit
Digital_Gain_48bit #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_I (
    .clk(clk), 
    .rst(rst), 
    .ms_in(ms_in), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .para_in0(para_in_I0), 
//    .para_in1(para_in_I1), 
//    .para_in2(para_in_I2), 
//    .para_in3(para_in_I3), 
    .scaled_coeff(scaled_coeff_I), 
    .para_out0(para_out_I0), 
//    .para_out1(para_out_I1), 
//    .para_out2(para_out_I2), 
//    .para_out3(para_out_I3), 
    .en_sync_out(en_sync_out), 
    .cnt_sync_out(cnt_sync_out), 
    .max(max_I)
    );
//Q参数增益控制，从那个48bit里选出16bit
Digital_Gain_48bit #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_Q (
    .clk(clk), 
    .rst(rst), 
    .ms_in(ms_in), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .para_in0(para_in_Q0), 
//    .para_in1(para_in_Q1), 
//    .para_in2(para_in_Q2), 
//    .para_in3(para_in_Q3), 
    .scaled_coeff(scaled_coeff_Q), 
    .para_out0(para_out_Q0), 
//    .para_out1(para_out_Q1), 
//    .para_out2(para_out_Q2), 
//    .para_out3(para_out_Q3), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .max(max_Q)
    );
//U参数增益控制，从那个48bit里选出16bit
Digital_Gain_48bit_neg #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_U (
    .clk(clk), 
    .rst(rst), 
    .ms_in(ms_in), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .para_in0(para_in_U0), 
//    .para_in1(para_in_U1), 
//    .para_in2(para_in_U2), 
//    .para_in3(para_in_U3), 
    .scaled_coeff(scaled_coeff_U), 
    .para_out0(para_out_U0), 
//    .para_out1(para_out_U1), 
//    .para_out2(para_out_U2), 
//    .para_out3(para_out_U3), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .max(max_U)
    );
//V参数增益控制，从那个48bit里选出16bit
Digital_Gain_48bit_neg #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_V (
    .clk(clk), 
    .rst(rst), 
    .ms_in(ms_in), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .para_in0(para_in_V0), 
//    .para_in1(para_in_V1), 
//    .para_in2(para_in_V2), 
//    .para_in3(para_in_V3), 
    .scaled_coeff(scaled_coeff_V), 
    .para_out0(para_out_V0), 
//    .para_out1(para_out_V1), 
//    .para_out2(para_out_V2), 
//    .para_out3(para_out_V3), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .max(max_V)
    );
endmodule
