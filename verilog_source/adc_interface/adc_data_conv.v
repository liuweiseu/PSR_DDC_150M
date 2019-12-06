`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:10 11/12/2018 
// Design Name: 
// Module Name:    adc_data_conv 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	将ADC的unsigned数据转换为signed
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "../include/application_define.v"
module adc_data_conv#(
	parameter ADC_DATA_WIDTH = 8
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_unsigned_all_bit_i_A,
		adc_unsigned_all_bit_i_B,
		adc_unsigned_all_bit_i_C,
		adc_unsigned_all_bit_i_D,
		clk,
		adc_signed_all_bit_o_A,
		adc_signed_all_bit_o_B,
		adc_signed_all_bit_o_C,
		adc_signed_all_bit_o_D
	);
	
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	`ifdef RSR
		localparam PARALLEL_PATH_NUM = 4;
	`elsif PSR
		localparam PARALLEL_PATH_NUM = 2;
	`endif
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;
	
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数据
		localparam CHANNEL_NUM = 4;
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数据
		localparam CHANNEL_NUM = 2;
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数据
		localparam CHANNEL_NUM = 1;
	`endif
	localparam PARALLEL_PATH_NUM_PER_CHANNEL = PARALLEL_PATH_NUM_PER_CORE*CHANNEL_NUM;
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_unsigned_all_bit_i_A;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_unsigned_all_bit_i_B;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_unsigned_all_bit_i_C;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_unsigned_all_bit_i_D;	
	input                                                       clk;

	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output  [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_signed_all_bit_o_A;
	output  [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_signed_all_bit_o_B;
	output  [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_signed_all_bit_o_C;
	output  [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_signed_all_bit_o_D;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** CORE A conv *****//
	adc_data_conv_one_core U_adc_data_conv_one_core_A (
    .adc_unsigned_all_bit_i(adc_unsigned_all_bit_i_A), 
    .clk(clk), 
    .adc_signed_all_bit_o(adc_signed_all_bit_o_A)
    );
	
	//***** CORE B conv *****//
	adc_data_conv_one_core U_adc_data_conv_one_core_B (
    .adc_unsigned_all_bit_i(adc_unsigned_all_bit_i_B), 
    .clk(clk), 
    .adc_signed_all_bit_o(adc_signed_all_bit_o_B)
    );
	
	//***** CORE C conv *****//
	adc_data_conv_one_core U_adc_data_conv_one_core_C (
    .adc_unsigned_all_bit_i(adc_unsigned_all_bit_i_C), 
    .clk(clk), 
    .adc_signed_all_bit_o(adc_signed_all_bit_o_C)
    );
	
	//***** CORE D conv *****//
	adc_data_conv_one_core U_adc_data_conv_one_core_D (
    .adc_unsigned_all_bit_i(adc_unsigned_all_bit_i_D), 
    .clk(clk), 
    .adc_signed_all_bit_o(adc_signed_all_bit_o_D)
    );
	

endmodule
