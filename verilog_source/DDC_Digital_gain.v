`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:39 11/20/2018 
// Design Name: 
// Module Name:    DDC_Digital_gain 
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
module DDC_Digital_gain #(
	parameter INPUT_WIDTH = 34,//DDC最终输出的位宽
	parameter OUTPUT_WIDTH = 18,		//移位后输出位宽
	parameter ADJ_WIDTH = 16
)
(
		clk,
		rst,	//幅度检测服务
		adjust,
		nd,
		data_150M_i,
		data_150M_q,
				
		rdy,
		data_150M_i_round,
		data_150M_q_round,
		max
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
	
	input                                     clk;
	input   [INPUT_WIDTH-1:0]                 data_150M_i;	//300MSps的数据，8路来自两个ADC核
	input   [INPUT_WIDTH-1:0]                 data_150M_q;
	input                                     nd;
	input                                     rst;
	input   [ADJ_WIDTH-1:0]                   adjust;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	output                                    rdy;		//与150M数据同步的数据有效信号
	output  [OUTPUT_WIDTH-1:0]                data_150M_i_round;
	output  [OUTPUT_WIDTH-1:0]                data_150M_q_round;
	output  [INPUT_WIDTH-1:0]                 max;

	//*************************************//
	//************ internal ***************//
	//*************************************//	
	wire     [INPUT_WIDTH-1:0]                 data_150M_i_reg;
	wire     [INPUT_WIDTH-1:0]                 data_150M_q_reg;
	wire     [INPUT_WIDTH-1:0]                 max_i;
	wire     [INPUT_WIDTH-1:0]                 max_q;
	wire     [INPUT_WIDTH-1:0]                 max_iq;
	reg      [INPUT_WIDTH-1:0]                 max_iq_reg;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	assign max_iq = (max_i>max_q)?max_i:max_q;

	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign max = max_iq_reg;
	
   	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	//***** 数字增益（移位） *****//
	adjust_para #(
	.INPUT_WIDTH(INPUT_WIDTH),
	.OUTPUT_WIDTH(OUTPUT_WIDTH),
	.ADJ_WIDTH(ADJ_WIDTH)
	)
	U3_ddc_adj (
    .clk(clk), 
    .adjust(adjust), 
    .data_in_i(data_150M_i), 
    .data_in_q(data_150M_q), 
    .nd(nd), 
    .data_out_i(data_150M_i_round), 
    .data_out_q(data_150M_q_round), 
    .rdy(rdy)
    );
	
	//***** 最大值检测I路 *****//
	getMax_signed #(
	.INPUT_WIDTH(INPUT_WIDTH)
	)
	U_getMax_signed_I (
    .clk(clk), 
    .rst(rst), 
    .nd(nd), 
    .data_in(data_150M_i), 
    .max(max_i)
    );
	
	//***** 最大值检测Q路 *****//
	getMax_signed #(
	.INPUT_WIDTH(INPUT_WIDTH)
	)
	U_getMax_signed_Q (
    .clk(clk), 
    .rst(rst), 
    .nd(nd), 
    .data_in(data_150M_q), 
    .max(max_q)
    );
	
	//***** 输出IQ最大值 *****//
	always @(posedge clk)
		max_iq_reg <= max_iq;
		
endmodule
