`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       WXH
// 
// Create Date:    14:38:48 08/11/2012 
// Design Name: 
// Module Name:    power specturm acc
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 实际累积次数为：cont_acc+1次
//
//注意：该模块第一次工作时，是输出累加num_acc次的结果，往后都是输出num_acc+1次的结果！！！
//////////////////////////////////////////////////////////////////////////////////
module Acc_Module#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input [15:0]num_acc,         		 //输入累加次数
	
	input en_sync_in,            		//输入同步信号
//	input [(BITWIDTH-1):0]cnt_sync_in,      		 //输出同步计数器
	input [(BITWIDTH+1):0]cnt_sync_in, 
	input [15:0]acc_in,          		 //输入数据
	
	output reg en_sync_out,      		//输出同步信号
//	output reg [(BITWIDTH-1):0]cnt_sync_out, 	//输出同步计数器
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	output reg[31:0]acc_out      		//输出数据
	);
	 
		

	
reg en_sync_in_reg1,en_sync_in_reg2,en_sync_in_reg3;
//reg [(BITWIDTH-1):0]cnt_sync_in_reg1,cnt_sync_in_reg2,cnt_sync_in_reg3;
reg [(BITWIDTH+1):0]cnt_sync_in_reg1,cnt_sync_in_reg2,cnt_sync_in_reg3;
reg [15:0]acc_in_reg1,acc_in_reg2;	
always @(posedge clk)
		begin
			if(rst)
				begin
					en_sync_in_reg1<=0;
					en_sync_in_reg2<=0;
					en_sync_in_reg3<=0;
					cnt_sync_in_reg1<=9'b0;
					cnt_sync_in_reg2<=9'b0;
					cnt_sync_in_reg3<=9'b0;
					acc_in_reg1<=16'b0;
					acc_in_reg2<=16'b0;
				end
			else
				begin
					en_sync_in_reg1<=en_sync_in;
					en_sync_in_reg2<=en_sync_in_reg1;
					en_sync_in_reg3<=en_sync_in_reg2;
					cnt_sync_in_reg1<=cnt_sync_in;
					cnt_sync_in_reg2<=cnt_sync_in_reg1;
					cnt_sync_in_reg3<=cnt_sync_in_reg2;
					acc_in_reg1<=acc_in;
					acc_in_reg2<=acc_in_reg1;
				end
		end
wire [31:0]ram_out;        //RAM的数据输出	
wire [31:0]adder_out;	

ram_acc U2 (
  .clka(clk), // input clka
  .ena(en_sync_in_reg3), // input ena
  .wea(en_sync_in_reg3), // input [0 : 0] wea
  .addra(cnt_sync_in_reg3), // input [13 : 0] addra
  .dina(adder_out), // input [63 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(1'b1), // input enb
  .addrb(cnt_sync_in), // input [13 : 0] addrb
  .doutb(ram_out) // output [63 : 0] doutb
);

reg [31:0]adder_in;
adder_acc U1 ( //延时2个clk
	.a(adder_in), // Bus [63 : 0] 
	.b(acc_in_reg2), 		// Bus [48 : 0]
	.clk(clk),  
	.sclr(rst),
	.s(adder_out) 		// Bus [63 : 0]
	); 
reg [15:0]num_acc_reg;  //用于记录已经累加了多少次
wire [16:0] num_acc_reg_plus;

assign num_acc_reg_plus = num_acc_reg+1'b1;

always @(posedge clk)
	begin
		if(rst)
			adder_in<=32'b0;
		else
			begin
				if(num_acc_reg==0)
					adder_in<=32'b0;
				else 
					adder_in<=ram_out;
			end
	end
	
always @(posedge clk)
	begin
		if(rst)
			num_acc_reg<=16'b0;
		else
		//if((en_sync_in==1) && (en_sync_in_reg1==0))//这里是要判断输入同步信号的上升沿
		  if(cnt_sync_in==0)	//	这里这样修改，是针对过来的数据一直是连续的，即en_sync_in信号一直是高电平，
				if(num_acc_reg==num_acc)
					num_acc_reg<=16'b0;
				else 
					num_acc_reg<=num_acc_reg_plus[15:0];
			else num_acc_reg<=num_acc_reg;
	end
	
reg [15:0]num_acc_reg1,num_acc_reg2;
always @(posedge clk)
	begin
		if(rst)
			begin
				num_acc_reg1<=16'b0;
				num_acc_reg2<=16'b0;
			end
		else
			begin
				num_acc_reg1<=num_acc_reg;
				num_acc_reg2<=num_acc_reg1;
			end
	end

always @(posedge clk)
	begin
		if(rst)
			begin
				acc_out<=32'b0;
				en_sync_out<=0;
				cnt_sync_out<=9'b0;
			end
		else 
			begin
				if(num_acc_reg2==num_acc)//判断是否相等，并且
					begin
						acc_out<=adder_out;
						en_sync_out<=en_sync_in_reg3;
						cnt_sync_out<=cnt_sync_in_reg3;
					end
				else
					begin
						acc_out<=32'b0;
						en_sync_out<=0;
						cnt_sync_out<=9'b0;
					end
			end
	end

endmodule

