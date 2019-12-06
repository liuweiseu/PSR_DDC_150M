`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:57:14 05/02/2017 
// Design Name: 
// Module Name:    Freq_Equalization 
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
module Freq_Equalization #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
//	input [(BITWIDTH-1):0]para_waddr,		//��4��ram��д��������ؿ����ź�
	input [(BITWIDTH+1):0]para_waddr,
	input w_en0,
//	input w_en1,
//	input w_en2,
//	input w_en3,
	input [15:0]para_in,
	
//	input [(BITWIDTH-1):0]para_raddr,		//��4��ram�����������ؿ����ź�
	input [(BITWIDTH+1):0]para_raddr,
	input r_en0,
//	input r_en1,
//	input r_en2,
//	input r_en3,
	output [15:0]para_out,
	
	input en_sync_in,
//	input [(BITWIDTH-1):0]cnt_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,
	input [22:0]re_in0,
	input [22:0]im_in0,
	
	output en_sync_out,
//	output [(BITWIDTH-1):0]cnt_sync_out,
	output [(BITWIDTH+1):0]cnt_sync_out,
	output [22:0]re_out0,
	output [22:0]im_out0

    );
//���ǵ�ַ���ص�RAM��ַ����1clk������ϵ������1clk���������ݺ�ͬ���źŶ�Ҫ�ӳ�2clk
reg en_sync_in_reg1,en_sync_in_reg2;
//reg [(BITWIDTH-1):0]cnt_sync_in_reg1,cnt_sync_in_reg2;
reg [(BITWIDTH+1):0]cnt_sync_in_reg1,cnt_sync_in_reg2;
reg [22:0]re_in0_reg1,re_in0_reg2;
reg [22:0]im_in0_reg1,im_in0_reg2;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_in_reg1<=0;
				en_sync_in_reg2<=0;
				cnt_sync_in_reg1<=0;
				cnt_sync_in_reg2<=0;
				
				re_in0_reg1<=re_in0;    //����Ҫ��λ
				re_in0_reg2<=re_in0;    //����Ҫ��λ
				im_in0_reg1<=im_in0;    //����Ҫ��λ
				im_in0_reg2<=im_in0;    //����Ҫ��λ
			end
		else
			begin
				en_sync_in_reg1<=en_sync_in;
				en_sync_in_reg2<=en_sync_in_reg1;
				cnt_sync_in_reg1<=cnt_sync_in;
				cnt_sync_in_reg2<=cnt_sync_in_reg1;
				
				re_in0_reg1<=re_in0;
				re_in0_reg2<=re_in0_reg1;
				
				im_in0_reg1<=im_in0;
				im_in0_reg2<=im_in0_reg1;
			end
	end
//�������һ��ram���ݶ�д��д�Ļ���ͨ��ʹ�ܡ����ݺ͵�ַ3���źż��ɣ���������ͨ��ʹ�ܿ��ƶ����������ǰ��ĸ���ַ
//reg [(BITWIDTH-1):0]para_raddr_temp0;//,para_raddr_temp1,para_raddr_temp2,para_raddr_temp3;
reg [(BITWIDTH+1):0]para_raddr_temp0;
wire [15:0]para_out0;//,para_out1,para_out2,para_out3;
always @(posedge clk)
	begin
		if(rst)
				para_raddr_temp0<=0;
		else if(r_en0)
			para_raddr_temp0<=para_raddr;
		else 
			para_raddr_temp0<=cnt_sync_in;	//������ͬ���������ĵ�5��clk��ʱ
	end
	
//always @(posedge clk)
//	begin
//		if(rst)
//				para_raddr_temp1<=0;
//		else if(r_en1)
//			para_raddr_temp1<=para_raddr;
//		else 
//			para_raddr_temp1<=cnt_sync_in;	//������ͬ���������ĵ�5��clk��ʱ
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//				para_raddr_temp2<=0;
//		else if(r_en2)
//			para_raddr_temp2<=para_raddr;
//		else 
//			para_raddr_temp2<=cnt_sync_in;	//������ͬ���������ĵ�5��clk��ʱ
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//				para_raddr_temp3<=0;
//		else if(r_en3)
//			para_raddr_temp3<=para_raddr;
//		else 
//			para_raddr_temp3<=cnt_sync_in;	//������ͬ���������ĵ�5��clk��ʱ
//	end

//always @(posedge clk)
//	begin
//		if(rst)
//			para_out<=0;
//		else if(r_en0)
//			para_out<=para_out0;
//		else if(r_en1)
//			para_out<=para_out1;
//		else if(r_en2)
//			para_out<=para_out2;
//		else if(r_en3)
//			para_out<=para_out3;
//		else
//			para_out<=0;
//	end
assign para_out = para_out0;
//�������ݻ���RAM
 Freq_Equa_Para Freq_Equa_Para0 (
  .clka(clk), // input clka
  .ena(w_en0), // input ena
  .wea(w_en0), // input [0 : 0] wea
  .addra(para_waddr), // input [8 : 0] addra
  .dina(para_in), // input [15 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(1), // inpuet enb
  .addrb(para_raddr_temp0), // input [8 : 0] addrb
  .doutb(para_out0) // output [15 : 0] doutb
);
// Freq_Equa_Para Freq_Equa_Para1 (
//  .clka(clk), // input clka
//  .ena(w_en1), // input ena
//  .wea(w_en1), // input [0 : 0] wea
//  .addra(para_waddr), // input [8 : 0] addra
//  .dina(para_in), // input [15 : 0] dina
//  .clkb(clk), // input clkb
//  .rstb(rst), // input rstb
//  .enb(1), // inpuet enb
//  .addrb(para_raddr_temp1), // input [8 : 0] addrb
//  .doutb(para_out1) // output [15 : 0] doutb
//);
// Freq_Equa_Para Freq_Equa_Para2 (
//  .clka(clk), // input clka
//  .ena(w_en2), // input ena
//  .wea(w_en2), // input [0 : 0] wea
//  .addra(para_waddr), // input [8 : 0] addra
//  .dina(para_in), // input [15 : 0] dina
//  .clkb(clk), // input clkb
//  .rstb(rst), // input rstb
//  .enb(1), // inpuet enb
//  .addrb(para_raddr_temp2), // input [8 : 0] addrb
//  .doutb(para_out2) // output [15 : 0] doutb
//);
// Freq_Equa_Para Freq_Equa_Para3 (
//  .clka(clk), // input clka
//  .ena(w_en3), // input ena
//  .wea(w_en3), // input [0 : 0] wea
//  .addra(para_waddr), // input [8 : 0] addra
//  .dina(para_in), // input [15 : 0] dina
//  .clkb(clk), // input clkb
//  .rstb(rst), // input rstb
//  .enb(1), // inpuet enb
//  .addrb(para_raddr_temp3), // input [8 : 0] addrb
//  .doutb(para_out3) // output [15 : 0] doutb
//);
//����˷�ģ��
ReIm_Multi #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)ReIm_Multi0(
    .clk(clk), 
    .rst(rst), 
    .en_sync_in(en_sync_in_reg2), 
    .cnt_sync_in(cnt_sync_in_reg2), 
    .re_in0(re_in0_reg2), 
//    .re_in1(re_in1_reg2), 
//    .re_in2(re_in2_reg2), 
//    .re_in3(re_in3_reg2), 
    .im_in0(im_in0_reg2), 
//    .im_in1(im_in1_reg2), 
//    .im_in2(im_in2_reg2), 
//    .im_in3(im_in3_reg2), 
    .para0(para_out0), 
//    .para1(para_out1), 
//    .para2(para_out2), 
//    .para3(para_out3), 
    .en_sync_out(en_sync_out), 
    .cnt_sync_out(cnt_sync_out), 
    .re_out0(re_out0), 
//    .re_out1(re_out1), 
//    .re_out2(re_out2), 
//    .re_out3(re_out3), 
    .im_out0(im_out0)
//    .im_out1(im_out1), 
//    .im_out2(im_out2), 
//    .im_out3(im_out3)
    );
endmodule
