`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:26 05/15/2017 
// Design Name: 
// Module Name:    Data_Combine_RL 
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
module Data_Combine_RL #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,				//ͬ���ź�����
	input [(BITWIDTH+1):0]cnt_sync_in,
	
	input [15:0]para_in0,
	input [15:0]para_in1,
	
	output reg en_sync_out,
	output reg[(BITWIDTH+2):0]cnt_sync_out,
	
	output reg[15:0]para_out
    );


//parameter cnt=2048;
//parameter ram_depth=11;
//cnt_sync_out��һ��ȫ�ּ�����,���������������ֵ����ȷ��ʲôʱ�����ʲô�ź�
//en_sync_out��һ��ʹ���źţ�ʹ��ͬ���ź��е�ʱ��ʼ����	 
always @(posedge clk)
	begin
		if(rst)
			en_sync_out<=0;
		else if(en_sync_in)
			en_sync_out<=1;
		else if(cnt_sync_out==(2*FFT_POINT-1))
			en_sync_out<=0;
	end
always @(posedge clk)
	begin
		if(rst)
			cnt_sync_out<=0;
		else if(en_sync_out)
			cnt_sync_out<=cnt_sync_out+1;
	end
/********************************************************************************/
//��һ��������沢��ȡ
reg [(BITWIDTH+1):0]read_addr1;
reg read_en1;
wire [15:0]para_temp1;
//��һ��ram��ʹ���ź�
always @(posedge clk)
	begin
		if(rst)
			read_en1<=0;
		else if(cnt_sync_out>(FFT_POINT-4) && cnt_sync_out<(2*FFT_POINT-3))
			read_en1<=1;
		else read_en1<=0;
	end
//��һ��ram����ַ�ź�
always @(posedge clk)
	begin
		if(rst)
			read_addr1<=0;
		else if(read_en1)
			read_addr1<=read_addr1+1;
	end
ram_para_all_V2 ram_para1 (
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
//���ݼ�����ֵȷ�����ѡ���ĸ�
always @(posedge clk)
	begin
		if(rst)
			para_out<=0;
		else if(en_sync_in)
			para_out<=para_in0;
		else if(cnt_sync_out>(FFT_POINT-2) && cnt_sync_out<(2*FFT_POINT-1))
			para_out<=para_temp1;
		else para_out<=0;
	end

endmodule

