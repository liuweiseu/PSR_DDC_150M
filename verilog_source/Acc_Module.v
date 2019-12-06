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
// Additional Comments: ʵ���ۻ�����Ϊ��cont_acc+1��
//
//ע�⣺��ģ���һ�ι���ʱ��������ۼ�num_acc�εĽ�������������num_acc+1�εĽ��������
//////////////////////////////////////////////////////////////////////////////////
module Acc_Module#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input [15:0]num_acc,         		 //�����ۼӴ���
	
	input en_sync_in,            		//����ͬ���ź�
//	input [(BITWIDTH-1):0]cnt_sync_in,      		 //���ͬ��������
	input [(BITWIDTH+1):0]cnt_sync_in, 
	input [15:0]acc_in,          		 //��������
	
	output reg en_sync_out,      		//���ͬ���ź�
//	output reg [(BITWIDTH-1):0]cnt_sync_out, 	//���ͬ��������
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	output reg[31:0]acc_out      		//�������
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
wire [31:0]ram_out;        //RAM���������	
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
adder_acc U1 ( //��ʱ2��clk
	.a(adder_in), // Bus [63 : 0] 
	.b(acc_in_reg2), 		// Bus [48 : 0]
	.clk(clk),  
	.sclr(rst),
	.s(adder_out) 		// Bus [63 : 0]
	); 
reg [15:0]num_acc_reg;  //���ڼ�¼�Ѿ��ۼ��˶��ٴ�
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
		//if((en_sync_in==1) && (en_sync_in_reg1==0))//������Ҫ�ж�����ͬ���źŵ�������
		  if(cnt_sync_in==0)	//	���������޸ģ�����Թ���������һֱ�������ģ���en_sync_in�ź�һֱ�Ǹߵ�ƽ��
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
				if(num_acc_reg2==num_acc)//�ж��Ƿ���ȣ�����
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

