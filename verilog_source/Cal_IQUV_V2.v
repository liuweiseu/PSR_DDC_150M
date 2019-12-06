`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:20 05/15/2017 
// Design Name: 
// Module Name:    Cal_IQUV_V2 
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
module Cal_IQUV_V2 #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,       //同步信号输入
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	input [22:0]re0_L,      //数据输入
//	input [22:0]re1_L,
//	input [22:0]re2_L,
//	input [22:0]re3_L,
	input [22:0]im0_L,
//	input [22:0]im1_L,
//	input [22:0]im2_L,
//	input [22:0]im3_L,
	input [22:0]re0_R,      
//	input [22:0]re1_R,
//	input [22:0]re2_R,
//	input [22:0]re3_R,
	input [22:0]im0_R,
//	input [22:0]im1_R,
//	input [22:0]im2_R,
//	input [22:0]im3_R,
	
	output en_sync_out,       //同步信号输出  
//	output [(BITWIDTH-1):0]cnt_sync_out, 
	output [(BITWIDTH+1):0]cnt_sync_out, 
	
	output [47:0]out_RR0,       //数据输出
//	output [47:0]out_RR1, 
//	output [47:0]out_RR2, 
//	output [47:0]out_RR3, 
	
	output [47:0]out_LL0,
//	output [47:0]out_LL1,
//	output [47:0]out_LL2,
//	output [47:0]out_LL3,
	
	output [47:0]out_Re_RL0,
//	output [47:0]out_Re_RL1,
//	output [47:0]out_Re_RL2,
//	output [47:0]out_Re_RL3,
	
	output [47:0]out_Im_RL0
//	output [47:0]out_Im_RL1,
//	output [47:0]out_Im_RL2,
//	output [47:0]out_Im_RL3
    );

//计算LL
//wire en_sync_out;
//wire [(BITWIDTH-1):0]cnt_sync_out;
//wire [(BITWIDTH+1):0]cnt_sync_out;
//wire [46:0]out_LL0_temp;//,out_LL1_temp,out_LL2_temp,out_LL3_temp;
Cal_LR_POWER #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Cal_L_POWER (
    .clk(clk), 
    .rst(rst), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .re0(re0_L), 
//    .re1(re1_L), 
//    .re2(re2_L), 
//    .re3(re3_L), 
    .im0(im0_L), 
//    .im1(im1_L), 
//    .im2(im2_L), 
//    .im3(im3_L), 
    .en_sync_out(), 
    .cnt_sync_out(), 
//    .out0(out_LL0_temp)
	 .out0(out_LL0)
//    .out1(out_LL1_temp), 
//    .out2(out_LL2_temp), 
//    .out3(out_LL3_temp)
    );
//assign out_LL0={out_LL0_temp[46],out_LL0_temp}; 	//此处是为了保证输出为47比特，这样后续设计不用修改
//assign out_LL0={1'b0,out_LL0_temp}; 
//assign out_LL1={out_LL1_temp[46],out_LL1_temp};
//assign out_LL2={out_LL2_temp[46],out_LL2_temp};
//assign out_LL3={out_LL3_temp[46],out_LL3_temp};

//计算RR
//wire [46:0]out_RR0_temp;//,out_RR1_temp,out_RR2_temp,out_RR3_temp;
Cal_LR_POWER #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Cal_R_POWER (
    .clk(clk), 
    .rst(rst), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .re0(re0_R), 
//    .re1(re1_R), 
//    .re2(re2_R), 
//    .re3(re3_R), 
    .im0(im0_R), 
//    .im1(im1_R), 
//    .im2(im2_R), 
//    .im3(im3_R), 
    .en_sync_out(en_sync_out), 
    .cnt_sync_out(cnt_sync_out), 
//    .out0(out_RR0_temp)
	 .out0(out_RR0)
//    .out1(out_RR1_temp), 
//    .out2(out_RR2_temp), 
//    .out3(out_RR3_temp)
    );
//assign out_RR0={out_RR0_temp[46],out_RR0_temp};		//此处是为了保证输出为47比特，这样后续设计不用修改
//assign out_RR0={1'b0,out_RR0_temp};
//assign out_RR1={out_RR1_temp[46],out_RR1_temp};
//assign out_RR2={out_RR2_temp[46],out_RR2_temp};
//assign out_RR3={out_RR3_temp[46],out_RR3_temp};
//计算Re_RL
wire [46:0]out_Re_RL0_temp;//,out_Re_RL1_temp,out_Re_RL2_temp,out_Re_RL3_temp;
wire [46:0]out_Im_RL0_temp;//,out_Im_RL1_temp,out_Im_RL2_temp,out_Im_RL3_temp;
Cal_ReIm_RL #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)Cal_ReIm_RL (
    .clk(clk), 
    .rst(rst), 
//    .en_sync_in(en_sync_in), 
//    .cnt_sync_in(cnt_sync_in), 
    .re0_R(re0_R), 
//    .re1_R(re1_R), 
//    .re2_R(re2_R), 
//    .re3_R(re3_R), 
    .im0_R(im0_R), 
//    .im1_R(im1_R), 
//    .im2_R(im2_R), 
//    .im3_R(im3_R), 
    .re0_L(re0_L), 
//    .re1_L(re1_L), 
//    .re2_L(re2_L), 
//    .re3_L(re3_L), 
    .im0_L(im0_L), 
//    .im1_L(im1_L), 
//    .im2_L(im2_L), 
//    .im3_L(im3_L), 
//    .en_sync_out(), 
//    .cnt_sync_out(), 
    .out_Re0(out_Re_RL0_temp), 
//    .out_Re1(out_Re_RL1_temp), 
//    .out_Re2(out_Re_RL2_temp), 
//    .out_Re3(out_Re_RL3_temp), 
    .out_Im0(out_Im_RL0_temp)
//    .out_Im1(out_Im_RL1_temp), 
//    .out_Im2(out_Im_RL2_temp), 
//    .out_Im3(out_Im_RL3_temp)
    );
//assign out_Re_RL0={out_Re_RL0_temp[46],out_Re_RL0_temp};	//此处是为了保证输出为47比特，这样后续设计不用修改
assign out_Re_RL0={out_Re_RL0_temp[46],out_Re_RL0_temp};
//assign out_Re_RL1={out_Re_RL1_temp[46],out_Re_RL1_temp};
//assign out_Re_RL2={out_Re_RL2_temp[46],out_Re_RL2_temp};
//assign out_Re_RL3={out_Re_RL3_temp[46],out_Re_RL3_temp};

assign out_Im_RL0={out_Im_RL0_temp[46],out_Im_RL0_temp};
//assign out_Im_RL1={out_Im_RL1_temp[46],out_Im_RL1_temp};
//assign out_Im_RL2={out_Im_RL2_temp[46],out_Im_RL2_temp};
//assign out_Im_RL3={out_Im_RL3_temp[46],out_Im_RL3_temp};

endmodule
