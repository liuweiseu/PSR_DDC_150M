`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:04:32 10/8/208 
// Design Name: 
// Module Name:    Aft_Digital_Gain 
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
module Aft_Digital_Gain #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
 	input clk,
	input rst,
	//input ms_in,
	
	input [15:0]scaled_coeff_I,	//ϵ
	input [15:0]scaled_coeff_Q,
	input [15:0]scaled_coeff_U,
	input [15:0]scaled_coeff_V,
	
	input en_sync_in,					//ͬź
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [31:0]para_in_I0,			//
//	input [31:0]para_in_I1,
//	input [31:0]para_in_I2,
//	input [31:0]para_in_I3,
	
	input [31:0]para_in_Q0,
//	input [31:0]para_in_Q1,
//	input [31:0]para_in_Q2,
//	input [31:0]para_in_Q3,
	
	input [31:0]para_in_U0,
//	input [31:0]para_in_U1,
//	input [31:0]para_in_U2,
//	input [31:0]para_in_U3,
	
	input [31:0]para_in_V0,
//	input [31:0]para_in_V1,
//	input [31:0]para_in_V2,
//	input [31:0]para_in_V3,
	
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
	
	output [31:0]max_I,
	output [31:0]max_Q,
	output [31:0]max_U,
	output [31:0]max_V
    );
//IƣǸ32bitѡ8bit
Digital_Gain_32bit #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_I (
    .clk(clk), 
    .rst(rst), 
    //.ms_in(ms_in), 
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
//QƣǸ32bitѡ8bit
Digital_Gain_32bit #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_Q (
    .clk(clk), 
    .rst(rst), 
    //.ms_in(ms_in), 
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
//UƣǸ32bitѡ8bit
Digital_Gain_32bit_neg #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_U (
    .clk(clk), 
    .rst(rst), 
    //.ms_in(ms_in), 
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
//VƣǸ32bitѡ8bit
Digital_Gain_32bit_neg #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Digital_Gain_V (
    .clk(clk), 
    .rst(rst), 
    //.ms_in(ms_in), 
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

