`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:59 09/17/2015 
// Design Name: 
// Module Name:    DATA_FOR_ARM 
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
/***********************************˼·************************************
˼·���տ�ʼRAMд����ʹ�ܣ�д����дʹ�����ͣ�data_ready�����ready�źţ�����ARM������׼���ã�
ARM��⵽���źź󣬿�ʼ��һ����ַ��һ�����ݣ�����ַ����2047ʱ���ָ�дʹ��
*д����ʱӦ��ע��,Ӧ����⵽en_sync_in�������أ����ɿ�ʼд�����ݣ�������ܴ����ݵ��м俪ʼд��
*data_ready�ź���дʹ�ܽ���һ��Ϊ��ʱ����������δд�꣬Ϊ��ʱ����������д��
****************************************************************************/
//////////////////////////////////////////////////////////////////////////////////
module DATA_FOR_ARM#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	input [15:0]data_in,
	input en_sync_in,			//��������ݿ�һ�����ڣ����ʹ���ź�������һ�𵽴������ģ���ڽ�������ʱһ��clk
	output reg data_ready,	//��дʹ�ܽ�����
	input [(BITWIDTH+3):0]arm_addr,
	output [15:0]arm_data
    );
reg [(BITWIDTH+3):0]addr_in;//д��ַ
reg en_sync_in_reg;//en_sync_in��һ��clk��ʱ
reg addr_in_en;//д��ַʹ�ܣ��üĴ���Ϊ1ʱ��д��ַ�ſ����ۼ�
//en_sync_in_reg��ֵ
always @(posedge clk)
	begin
		if(rst)
			en_sync_in_reg <=0;
		else 
			en_sync_in_reg <=en_sync_in;
	end
	//дʹ����λʱ����⵽en_sync_in�������أ�����д��ַʹ�ܣ���д��ַ�ӵ�2047ʱ����������д�꣬��ʱ���ر�дʹ��
always @(posedge clk)
	begin
		if(rst)
			addr_in_en <=0;
		else if((en_sync_in_reg==0) && (en_sync_in==1) &&(data_ready==1))
			addr_in_en <=1;
		else if(addr_in==(4*FFT_POINT-1))
			addr_in_en <=0;
	end
//��arm�������ĵ�ַ����2047ʱ������������ȡ�꣬��ʱ��дʹ����λ���ȴ���ʼ���ִ�������һ�ִ�����Ҫ����
always @(posedge clk)
	begin
		if(rst)
			data_ready <=1'b0;
		else if(arm_addr==(4*FFT_POINT-1))
			data_ready <=1'b1;
		else if(addr_in==(4*FFT_POINT-1))
			data_ready <=1'b0;
	end
//addr_in��ֵ	
always @(posedge clk)
	begin
		if(rst)
			addr_in <=0;
		else if(addr_in_en)
			addr_in<=addr_in+1;
	end
ARM_DATA U10_arm_data (
  .clka(clk), // input clka
  .ena(1'b1), // input ena
  .wea(addr_in_en), // input [0 : 0] wea
  .addra(addr_in), // input [12 : 0] addra
  .dina(data_in), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .addrb(arm_addr), // input [12 : 0] addrb
  .doutb(arm_data) // output [7 : 0] doutb
);

endmodule
