`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:29 10/15/2016 
// Design Name: 
// Module Name:    Acc_IQUV 
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
module Acc_IQUV#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input [15:0]num_acc,		//累加次数 
	
	input en_sync_in,			//同步信号 
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [15:0]para_in_I0,	//数据输入
//	input [15:0]para_in_I1,
//	input [15:0]para_in_I2,
//	input [15:0]para_in_I3,
	
	input [15:0]para_in_Q0,
//	input [15:0]para_in_Q1,
//	input [15:0]para_in_Q2,
//	input [15:0]para_in_Q3,
	
	input [15:0]para_in_U0,
//	input [15:0]para_in_U1,
//	input [15:0]para_in_U2,
//	input [15:0]para_in_U3,
	
	input [15:0]para_in_V0,
//	input [15:0]para_in_V1,
//	input [15:0]para_in_V2,
//	input [15:0]para_in_V3,
	
		
	output en_sync_out,			//同步信号输出
//	output [(BITWIDTH-1):0]cnt_sync_out,
	output [(BITWIDTH+1):0]cnt_sync_out,
	
	output [31:0]para_out_I0,	//数据输出
//	output [31:0]para_out_I1,
//	output [31:0]para_out_I2,
//	output [31:0]para_out_I3,
	
	output [31:0]para_out_Q0,
//	output [31:0]para_out_Q1,
//	output [31:0]para_out_Q2,
//	output [31:0]para_out_Q3,
	
	output [31:0]para_out_U0,
//	output [31:0]para_out_U1,
//	output [31:0]para_out_U2,
//	output [31:0]para_out_U3,
	
	output [31:0]para_out_V0
//	output [31:0]para_out_V1,
//	output [31:0]para_out_V2,
//	output [31:0]para_out_V3
    );
//累加模块 I累加
Acc_Module #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Acc_I0 (
    .rst(rst), 
    .clk(clk), 
    .num_acc(num_acc), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .acc_in(para_in_I0), 
    .en_sync_out(en_sync_out), 
    .cnt_sync_out(cnt_sync_out), 
    .acc_out(para_out_I0)
    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_I1 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_I1), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_I1)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_I2 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_I2), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_I2)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_I3 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_I3), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_I3)
//    );
//Q参数累加
Acc_Module #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Acc_Q0 (
    .rst(rst), 
    .clk(clk), 
    .num_acc(num_acc), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .acc_in(para_in_Q0), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .acc_out(para_out_Q0)
    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_Q1 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_Q1), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_Q1)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_Q2 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_Q2), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_Q2)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_Q3 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_Q3), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_Q3)
//    );
//U参数累加
Acc_Module #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Acc_U0 (
    .rst(rst), 
    .clk(clk), 
    .num_acc(num_acc), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .acc_in(para_in_U0), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .acc_out(para_out_U0)
    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_U1 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_U1), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_U1)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_U2 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_U2), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_U2)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_U3 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_U3), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_U3)
//    );
//V参数累加
Acc_Module #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Acc_V0 (
    .rst(rst), 
    .clk(clk), 
    .num_acc(num_acc), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .acc_in(para_in_V0), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .acc_out(para_out_V0)
    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_V1 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_V1), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_V1)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_V2 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_V2), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_V2)
//    );
//Acc_Module #(
//	 .BITWIDTH(BITWIDTH),
//	 .FFT_POINT(FFT_POINT),
//	 .SUB_FFT_POINT(SUB_FFT_POINT)
//)Acc_V3 (
//    .rst(rst), 
//    .clk(clk), 
//    .num_acc(num_acc), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
//    .acc_in(para_in_V3), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
//    .acc_out(para_out_V3)
//    );
endmodule
