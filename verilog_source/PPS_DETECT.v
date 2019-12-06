`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:04 07/01/2017 
// Design Name: 
// Module Name:    PPS_DETECT 
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
module PPS_DETECT(
	input clk,
	input rst,
	input pps_in,
	output reg[31:0]cnt
    );
reg pps_in_reg;
//PPS�ź��ӳ�һ��clk
always @(posedge clk)
	begin
		if(rst)
			pps_in_reg<=0;
		else
			pps_in_reg<=pps_in;
	end
//���PPS������
reg cnt_en;
reg flag;
always @(posedge clk)
	begin
		if(rst)
			begin
				cnt_en<=0;
				flag<=0;
			end
			if((pps_in==0)&&(pps_in_reg==1)&&(time_cnt==0))//PPS������������FPGA�ڲ�������ͬʱ����
			begin
				cnt_en<=0;
				flag<=~flag;
			end
		else if((pps_in==0)&&(pps_in_reg==1))
			begin
				cnt_en<=1;
				flag<=~flag;
			end
		else if(time_cnt==0)
			cnt_en<=0;
	end
//��������ʼ����
reg [31:0]time_cnt;
always @(posedge clk)
	begin
		if(rst)
			time_cnt<=0;
		else if(time_cnt==299999999)
			time_cnt<=0;
		else 
			time_cnt<=time_cnt+1;
	end
//�������������
reg [31:0]cnt_reg;
always @(posedge clk)
	begin
		if(rst)
			cnt_reg<=0;
		else if(cnt_en)
			cnt_reg<=cnt_reg+1;
		else
			cnt_reg<=0;
	end
//���ֵ��ֵ
//reg cnt_en_reg;
//always @(posedge clk)
//	begin
//		if(rst)
//			cnt_en_reg<=0;
//		else
//			cnt_en_reg<=cnt_en;
//	end

always @(posedge clk)
	begin
		if(rst)
			cnt<=0;
		if((pps_in==0)&&(pps_in_reg==1)&&(time_cnt==0))//PPS������������FPGA�ڲ�������ͬʱ����
			cnt<=(flag<<31);
		else if((time_cnt==0)&&(cnt_en==1))//PPS������������FPGA�ڲ������岻ͬʱ��������Ǵ���PPS�����ش����˼���
			cnt<=cnt_reg|(flag<<31);
		else if((time_cnt==0)&&(cnt_en==0))//PPS���岻���ڣ�ֻ��FPGA�ڲ���������
			cnt<=32'h04000000;
	end
endmodule
