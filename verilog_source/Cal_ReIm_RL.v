`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:49 05/15/2017 
// Design Name: 
// Module Name:    Cal_Re_RL 
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
module Cal_ReIm_RL#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,              
	input rst,
	
//	input en_sync_in,					//同步信号输入
//	input [(BITWIDTH-1):0]cnt_sync_in,
//	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [22:0]re0_R,      			//数据输入
//	input [22:0]re1_R,
//	input [22:0]re2_R,
//	input [22:0]re3_R,
	input [22:0]im0_R,
//	input [22:0]im1_R,
//	input [22:0]im2_R,
//	input [22:0]im3_R,   
	
	input [22:0]re0_L,      			//数据输入
//	input [22:0]re1_L,
//	input [22:0]re2_L,
//	input [22:0]re3_L,
	input [22:0]im0_L,
//	input [22:0]im1_L,
//	input [22:0]im2_L,
//	input [22:0]im3_L, 
	
//	output reg en_sync_out,       //同步信号输出
//	output reg [(BITWIDTH-1):0]cnt_sync_out,
//	output reg [(BITWIDTH+1):0]cnt_sync_out,
	
	output [46:0]out_Re0,     			 //数据输出
//	output [46:0]out_Re1,
//	output [46:0]out_Re2,
//	output [46:0]out_Re3,
	output [46:0]out_Im0     			 
//	output [46:0]out_Im1,
//	output [46:0]out_Im2,
//	output [46:0]out_Im3
    );


//计算实部
//计算第一组RrRl+IrIl
wire [45:0]RrRl_temp0;
wire [45:0]IrIl_temp0;
multiplier mult_RrRl0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(re0_R), 
	.b(re0_L), 
	.p(RrRl_temp0)
);
multiplier mult_IrIl0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(im0_R), 
	.b(im0_L), 
	.p(IrIl_temp0)
);
adder adder0  (
  .a(RrRl_temp0), // input [45 : 0] a
  .b(IrIl_temp0), // input [45 : 0] b
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .s(out_Re0) // output [46 : 0] s
);
////计算第二组RrRl+IrIl
//wire [45:0]RrRl_temp1;
//wire [45:0]IrIl_temp1;
//multiplier mult_RrRl1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re1_R), 
//	.b(re1_L), 
//	.p(RrRl_temp1)
//);
//multiplier mult_IrIl1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im1_R), 
//	.b(im1_L), 
//	.p(IrIl_temp1)
//);
//adder adder1  (
//  .a(RrRl_temp1), // input [45 : 0] a
//  .b(IrIl_temp1), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Re1) // output [46 : 0] s
//);
////计算第三组RrRl+IrIl
//wire [45:0]RrRl_temp2;
//wire [45:0]IrIl_temp2;
//multiplier mult_RrRl2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re2_R), 
//	.b(re2_L), 
//	.p(RrRl_temp2)
//);
//multiplier mult_IrIl2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im2_R), 
//	.b(im2_L), 
//	.p(IrIl_temp2)
//);
//adder adder2  (
//  .a(RrRl_temp2), // input [45 : 0] a
//  .b(IrIl_temp2), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Re2) // output [46 : 0] s
//);
////计算第四组RrRl+IrIl
//wire [45:0]RrRl_temp3;
//wire [45:0]IrIl_temp3;
//multiplier mult_RrRl3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re3_R), 
//	.b(re3_L), 
//	.p(RrRl_temp3)
//);
//multiplier mult_IrIl3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im3_R), 
//	.b(im3_L), 
//	.p(IrIl_temp3)
//);
//adder adder3  (
//  .a(RrRl_temp3), // input [45 : 0] a
//  .b(IrIl_temp3), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Re3) // output [46 : 0] s
//);

//计算虚部
//计算第一组IrRl-RrIl
wire [45:0]RrIl_temp0;
wire [45:0]IrRl_temp0;
multiplier mult_RrIl0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(re0_R), 
	.b(im0_L), 
	.p(RrIl_temp0)
);
multiplier mult_IrRl0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(im0_R), 
	.b(re0_L), 
	.p(IrRl_temp0)
);
subber subber0(
  .a(IrRl_temp0), // input [45 : 0] a
  .b(RrIl_temp0), // input [45 : 0] b
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .s(out_Im0) // output [46 : 0] s
);
////计算第二组IrRl-RrIl
//wire [45:0]RrIl_temp1;
//wire [45:0]IrRl_temp1;
//multiplier mult_RrIl1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re1_R), 
//	.b(im1_L), 
//	.p(RrIl_temp1)
//);
//multiplier mult_IrRl1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im1_R), 
//	.b(re1_L), 
//	.p(IrRl_temp1)
//);
//subber subber1 (
//  .a(IrRl_temp1), // input [45 : 0] a
//  .b(RrIl_temp1), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Im1) // output [46 : 0] s
//);
////计算第三组IrRl-RrIl
//wire [45:0]RrIl_temp2;
//wire [45:0]IrRl_temp2;
//multiplier mult_RrIl2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re2_R), 
//	.b(im2_L), 
//	.p(RrIl_temp2)
//);
//multiplier mult_IrRl2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im2_R), 
//	.b(re2_L), 
//	.p(IrRl_temp2)
//);
//subber subber2 (
//  .a(IrRl_temp2), // input [45 : 0] a
//  .b(RrIl_temp2), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Im2) // output [46 : 0] s
//);
////计算第四组IrRl-RrIl
//wire [45:0]RrIl_temp3;
//wire [45:0]IrRl_temp3;
//multiplier mult_RrIl3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re3_R), 
//	.b(im3_L), 
//	.p(RrIl_temp3)
//);
//multiplier mult_IrRl3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im3_R), 
//	.b(re3_L), 
//	.p(IrRl_temp3)
//);
//subber subber3 (
//  .a(IrRl_temp3), // input [45 : 0] a
//  .b(RrIl_temp3), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out_Im3) // output [46 : 0] s
//);
//同步信号输出
//reg en_sync_reg0;
//reg en_sync_reg1;
//reg en_sync_reg2;
////reg [(BITWIDTH-1):0]cnt_sync_reg0;
////reg [(BITWIDTH-1):0]cnt_sync_reg1;
////reg [(BITWIDTH-1):0]cnt_sync_reg2;
//reg [(BITWIDTH+1):0]cnt_sync_reg0;
//reg [(BITWIDTH+1):0]cnt_sync_reg1;
//reg [(BITWIDTH+1):0]cnt_sync_reg2;
//always @(posedge clk)
//	begin
//		if(rst)
//			begin
//				en_sync_reg0<=0;
//				en_sync_reg1<=0;
//				en_sync_reg2<=0;
//				en_sync_out<=0;
//				
//				cnt_sync_reg0<=0;
//				cnt_sync_reg1<=0;
//				cnt_sync_reg2<=0;
//				cnt_sync_out<=0;
//			end
//		else 
//			begin
//				en_sync_reg0<=en_sync_in;
//				en_sync_reg1<=en_sync_reg0;
//				en_sync_reg2<=en_sync_reg1;
//				en_sync_out<=en_sync_reg2;
//				
//				cnt_sync_reg0<=cnt_sync_in;
//				cnt_sync_reg1<=cnt_sync_reg0;
//				cnt_sync_reg2<=cnt_sync_reg1;
//				cnt_sync_out<=cnt_sync_reg2;
//			end
//	end

endmodule
