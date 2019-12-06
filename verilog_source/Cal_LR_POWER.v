`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:52 10/12/2016 
// Design Name: 
// Module Name:    Cal_I 
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
//说明：
//该模块的输入为4路fft之后的数据，输出为平方和之后的功率值
module Cal_LR_POWER#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,              
	input rst,
	
	input en_sync_in,					//同步信号输入
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [22:0]re0,      			//数据输入
//	input [22:0]re1,
//	input [22:0]re2,
//	input [22:0]re3,
	input [22:0]im0,
//	input [22:0]im1,
//	input [22:0]im2,
//	input [22:0]im3,   
	
	output reg en_sync_out,       //同步信号输出
//	output reg [(BITWIDTH-1):0]cnt_sync_out,
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	
	output [47:0]out0    			 //数据输出
//	output [46:0]out1,
//	output [46:0]out2,
//	output [46:0]out3
	);
//算第一组参数 out0
wire [45:0]re_re_temp0;
wire [45:0]im_im_temp0;
multiplier mult_re_re0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(re0), 
	.b(re0), 
	.p(re_re_temp0)
);
multiplier mult_im_im0(      //延时3个clk
	.sclr(rst), 
	.clk(clk), 
	.a(im0), 
	.b(im0), 
	.p(im_im_temp0)
);
wire [46:0]out0_temp;
adder adder0 (   //延时1个clk
  .a(re_re_temp0), // input [45 : 0] a
  .b(im_im_temp0), // input [45 : 0] b
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .s(out0_temp) // output [46 : 0] s
);
assign  out0 = {1'b0,out0_temp};
////算第二组参数 out1
//wire [45:0]re_re_temp1;
//wire [45:0]im_im_temp1;
//multiplier mult_re_re1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re1), 
//	.b(re1), 
//	.p(re_re_temp1)
//);
//multiplier mult_im_im1(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im1), 
//	.b(im1), 
//	.p(im_im_temp1)
//);
//adder adder1 (   //延时1个clk
//  .a(re_re_temp1), // input [45 : 0] a
//  .b(im_im_temp1), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out1) // output [46 : 0] s
//);
////算第三组参数 out2
//wire [45:0]re_re_temp2;
//wire [45:0]im_im_temp2;
//multiplier mult_re_re2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re2), 
//	.b(re2), 
//	.p(re_re_temp2)
//);
//multiplier mult_im_im2(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im2), 
//	.b(im2), 
//	.p(im_im_temp2)
//);
//adder adder2 (   //延时1个clk
//  .a(re_re_temp2), // input [45 : 0] a
//  .b(im_im_temp2), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out2) // output [46 : 0] s
//);
////算第三组参数 out3
//wire [45:0]re_re_temp3;
//wire [45:0]im_im_temp3;
//multiplier mult_re_re3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(re3), 
//	.b(re3), 
//	.p(re_re_temp3)
//);
//multiplier mult_im_im3(      //延时3个clk
//	.sclr(rst), 
//	.clk(clk), 
//	.a(im3), 
//	.b(im3), 
//	.p(im_im_temp3)
//);
//adder adder3 (   //延时1个clk
//  .a(re_re_temp3), // input [45 : 0] a
//  .b(im_im_temp3), // input [45 : 0] b
//  .clk(clk), // input clk
//  .sclr(rst), // input sclr
//  .s(out3) // output [46 : 0] s
//);

//同步信号输出
reg en_sync_reg0;
reg en_sync_reg1;
reg en_sync_reg2;
//reg [(BITWIDTH-1):0]cnt_sync_reg0;
//reg [(BITWIDTH-1):0]cnt_sync_reg1;
//reg [(BITWIDTH-1):0]cnt_sync_reg2;
reg [(BITWIDTH+1):0]cnt_sync_reg0;
reg [(BITWIDTH+1):0]cnt_sync_reg1;
reg [(BITWIDTH+1):0]cnt_sync_reg2;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_reg0<=0;
				en_sync_reg1<=0;
				en_sync_reg2<=0;
				en_sync_out<=0;
				
				cnt_sync_reg0<=0;
				cnt_sync_reg1<=0;
				cnt_sync_reg2<=0;
				cnt_sync_out<=0;
			end
		else 
			begin
				en_sync_reg0<=en_sync_in;
				en_sync_reg1<=en_sync_reg0;
				en_sync_reg2<=en_sync_reg1;
				en_sync_out<=en_sync_reg2;
				
				cnt_sync_reg0<=cnt_sync_in;
				cnt_sync_reg1<=cnt_sync_reg0;
				cnt_sync_reg2<=cnt_sync_reg1;
				cnt_sync_out<=cnt_sync_reg2;
			end
	end

endmodule
