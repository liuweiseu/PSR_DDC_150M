`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:58:31 11/22/2013 
// Design Name: 
// Module Name:    adjust_para
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 			�����ݽ�����λ�ͽضϣ�ͬʱ��rdy�źŽ�����ʱ�����������rdy��� 
//                          
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module adjust_para #(
	parameter INPUT_WIDTH = 27,
	parameter OUTPUT_WIDTH = 20,
	parameter ADJ_WIDTH = 11
	)
	(
	//*************************************//
	//************* ports *****************//
	//*************************************//
		clk,
		adjust,					//���Ƶ�λ��
		data_in_i,
		data_in_q,
		nd,
		
		data_out_i,
		data_out_q,
		rdy
	);
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input 							clk;
	input 	[ADJ_WIDTH-1:0] 		adjust;					//���Ƶ�λ��
	input 	[INPUT_WIDTH-1:0] 		data_in_i;
	input 	[INPUT_WIDTH-1:0] 		data_in_q;
	input							nd;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output 	[OUTPUT_WIDTH-1:0] 		data_out_i;
	output  [OUTPUT_WIDTH-1:0] 		data_out_q;
	output 		 					rdy;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//	
	wire     [INPUT_WIDTH-1:0]       din_reg_i_buffer_in;
	wire     [INPUT_WIDTH-1:0]       din_reg_q_buffer_in;
	reg     [INPUT_WIDTH-1:0]       din_reg_i_shift=0;
	reg     [INPUT_WIDTH-1:0]       din_reg_q_shift=0;
	reg     [INPUT_WIDTH:0]      din_reg_i_roundoff=0;
	reg     [INPUT_WIDTH:0]      din_reg_q_roundoff=0;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	assign data_out_i = din_reg_i_roundoff[INPUT_WIDTH-1:(INPUT_WIDTH-OUTPUT_WIDTH)];	//din_reg_q_roundoff�����λֻ������ļӷ������ã���ֹ����warning��
	assign data_out_q = din_reg_q_roundoff[INPUT_WIDTH-1:(INPUT_WIDTH-OUTPUT_WIDTH)]; 
	
	//***** ��һ�����ڽ������� *****//
	delay_line #(
	.DATA_WIDTH(INPUT_WIDTH),
	.PIPELINE_DEPTH(1)
	)
	U_delay_line_data_i (
	.clk(clk),
	.nd(nd), 
	.din(data_in_i), 
	.q(din_reg_i_buffer_in)
	);
	delay_line #(
	.DATA_WIDTH(INPUT_WIDTH),
	.PIPELINE_DEPTH(1)
	)
	U_delay_line_data_q (
	.clk(clk),
	.nd(nd), 
	.din(data_in_q), 
	.q(din_reg_q_buffer_in)
	);
	
	//***** �ڶ���������λ *****//
	always @(posedge clk)			
	begin				//
		din_reg_i_shift <= din_reg_i_buffer_in << adjust;
		din_reg_q_shift <= din_reg_q_buffer_in << adjust;
	end
	
	//***** ���������ڼ������� *****//
	always @(posedge clk)			
	begin				
		din_reg_i_roundoff <= din_reg_i_shift[(INPUT_WIDTH-1):(INPUT_WIDTH-OUTPUT_WIDTH)]+din_reg_i_shift[(INPUT_WIDTH-OUTPUT_WIDTH)-1];
		din_reg_q_roundoff <= din_reg_q_shift[(INPUT_WIDTH-1):(INPUT_WIDTH-OUTPUT_WIDTH)]+din_reg_q_shift[(INPUT_WIDTH-OUTPUT_WIDTH)-1];
	end
	
	//***** ��ʱ����nd����ͬ�������rdy���� *****//
	delay_line #(
	.DATA_WIDTH(1),
	.PIPELINE_DEPTH(3)
	)
	U_delay_line_rdy (
	.clk(clk),
	.nd(1'b1), 
	.din(nd), 
	.q(rdy)
	);
			
endmodule
