`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:42:09 10/16/2016 
// Design Name: 
// Module Name:    data_combine 
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
module Data_Combine #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,				//同步信号输入
//	input [(BITWIDTH-1):0]cnt_sync_in,	
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [15:0]para_in0,
	input [15:0]para_in1,
	input [15:0]para_in2,
	input [15:0]para_in3,
	
	output reg en_sync_out,
//	output reg[(BITWIDTH+1):0]cnt_sync_out,
	output reg[(BITWIDTH+3):0]cnt_sync_out,
	
	output reg[15:0]para_out
    );
//cnt_sync_out是一个全局计数器,根据这个计数器的值，来确定什么时候输出什么信号
//en_sync_out是一个使能信号，使得同步信号有的时候开始计数	 
wire  [(BITWIDTH+4):0] cnt_sync_out_plus;
assign cnt_sync_out_plus = cnt_sync_out+1'b1;

always @(posedge clk)
	begin
		if(rst)
			en_sync_out<=0;
		else if(en_sync_in)
			en_sync_out<=1;
		else if(cnt_sync_out==(4*FFT_POINT-1))
			en_sync_out<=0;
	end
always @(posedge clk)
	begin
		if(rst)
			cnt_sync_out<=0;
		else if(en_sync_out)
			cnt_sync_out<=cnt_sync_out_plus[(BITWIDTH+3):0];
	end
/********************************************************************************/
//第一组参数缓存并读取
//reg [(BITWIDTH-1):0]read_addr1;
reg [(BITWIDTH+1):0]read_addr1;
reg read_en1;
wire [15:0]para_temp1;
//第一个ram读使能信号
always @(posedge clk)
	begin
		if(rst)
			read_en1<=0;
		else if(cnt_sync_out>(FFT_POINT-4) && cnt_sync_out<(2*FFT_POINT-3))
			read_en1<=1;
		else read_en1<=0;
	end
//第一个ram读地址信号
always @(posedge clk)
	begin
		if(rst)
			read_addr1<=0;
		else if(read_en1)
			read_addr1<=read_addr1+1;
	end
ram_para ram_para1 (
  .clka(clk), // input clka
  .ena(en_sync_in), // input ena
  .wea(en_sync_in), // input [0 : 0] wea
  .addra(cnt_sync_in), // input [8 : 0] addra
  .dina(para_in1), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(read_en1), // input enb
  .addrb(read_addr1), // input [8 : 0] addrb
  .doutb(para_temp1) // output [7 : 0] doutb
);
/********************************************************************************/
//第二组参数缓存并读取
//reg [(BITWIDTH-1):0]read_addr2;
reg [(BITWIDTH+1):0]read_addr2;
wire [(BITWIDTH+2):0]  read_addr2_plus;
reg read_en2;
wire [15:0]para_temp2;

assign read_addr2_plus = read_addr2+1'b1;

//第二个ram读使能信号
always @(posedge clk)
	begin
		if(rst)
			read_en2<=0;
		else if(cnt_sync_out>(2*FFT_POINT-4) && cnt_sync_out<(3*FFT_POINT-3))
			read_en2<=1;
		else read_en2<=0;
	end
//第二个ram读地址信号
always @(posedge clk)
	begin
		if(rst)
//			read_addr2<=511;
			read_addr2<=0;
		else if(read_en2)
//			read_addr2<=read_addr2-1;
			read_addr2<=read_addr2_plus[(BITWIDTH+1):0];
	end
ram_para ram_para2 (
  .clka(clk), // input clka
  .ena(en_sync_in), // input ena
  .wea(en_sync_in), // input [0 : 0] wea
  .addra(cnt_sync_in), // input [8 : 0] addra
  .dina(para_in2), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(read_en2), // input enb
  .addrb(read_addr2), // input [8 : 0] addrb
  .doutb(para_temp2) // output [7 : 0] doutb
);
/********************************************************************************/
//第三组参数缓存并读取
//reg [(BITWIDTH-1):0]read_addr3;
reg [(BITWIDTH+1):0]read_addr3;
reg read_en3;
wire [15:0]para_temp3;
wire [(BITWIDTH+2):0]  read_addr3_plus;

assign read_addr3_plus = read_addr3+1'b1;
//第三个ram读使能信号
always @(posedge clk)
	begin
		if(rst)
			read_en3<=0;
		else if(cnt_sync_out>(3*FFT_POINT-4) && cnt_sync_out<(4*FFT_POINT-3))
			read_en3<=1;
		else read_en3<=0;
	end
//第三个ram读地址信号
always @(posedge clk)
	begin
		if(rst)
//			read_addr3<=511;
			read_addr3<=0;
		else if(read_en3)
//			read_addr3<=read_addr3-1;
			read_addr3<=read_addr3_plus;
	end
ram_para ram_para3 (
  .clka(clk), // input clka
  .ena(en_sync_in), // input ena
  .wea(en_sync_in), // input [0 : 0] wea
  .addra(cnt_sync_in), // input [8 : 0] addra
  .dina(para_in3), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(read_en3), // input enb
  .addrb(read_addr3), // input [8 : 0] addrb
  .doutb(para_temp3) // output [7 : 0] doutb
);
/********************************************************************************/
//根据计数器值确定输出选择哪个
always @(posedge clk)
	begin
		if(rst)
			para_out<=0;
		else if(en_sync_in)
			para_out<=para_in0;
		else if(cnt_sync_out>(FFT_POINT-2) && cnt_sync_out<(2*FFT_POINT-1))
			para_out<=para_temp1;
		else if(cnt_sync_out>(2*FFT_POINT-2) && cnt_sync_out<(3*FFT_POINT-1))
			para_out<=para_temp2;
		else if(cnt_sync_out>(3*FFT_POINT-2) && cnt_sync_out<(4*FFT_POINT-1))
			para_out<=para_temp3;
		else para_out<=0;
	end

endmodule
