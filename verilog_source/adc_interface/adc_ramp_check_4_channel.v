`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:40:42 11/07/2018 
// Design Name: 
// Module Name:    adc_ramp_check_4_channel 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	1、这个设计没有把数据位宽拼成一路来实现动态自适应的port，因为希望多相的分接只出现在顶层文件
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module adc_ramp_check_4_channel #(
	parameter ADC_DATA_WIDTH = 8,
	parameter PARALLEL_PATH_NUM = 4
)	

	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		clk,
		detect_in,
		adc_sync_all_bit_i_A,
		adc_sync_all_bit_i_B,
		adc_sync_all_bit_i_C,
		adc_sync_all_bit_i_D,
		ADC_Is_Ramp_A,
		ADC_Is_Ramp_B,
		ADC_Is_Ramp_C,
		ADC_Is_Ramp_D
		
	);
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;	//因为有H和L两路
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                                       clk;
	input                                                       detect_in;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_A;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_B;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_C;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_D;
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output                                                      ADC_Is_Ramp_A;
	output                                                      ADC_Is_Ramp_B;
	output                                                      ADC_Is_Ramp_C;
	output                                                      ADC_Is_Ramp_D;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** TEST MODE Ramp信号检查 channel A *****//
	adc_ramp_check #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.PARALLEL_PATH_NUM(PARALLEL_PATH_NUM)
	)
	U_adc_ramp_check_A (
	.clk(clk), 
	.detect_in(detect_in), 
	.adc_sync_all_bit_i(adc_sync_all_bit_i_A), 
	.ADC_Is_Ramp(ADC_Is_Ramp_A)
	);
	
	//***** TEST MODE Ramp信号检查 channel B *****//	
	adc_ramp_check #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.PARALLEL_PATH_NUM(PARALLEL_PATH_NUM)
	)
	U_adc_ramp_check_B (
	.clk(clk), 
	.detect_in(detect_in), 
	.adc_sync_all_bit_i(adc_sync_all_bit_i_B), 
	.ADC_Is_Ramp(ADC_Is_Ramp_B)
	);
	
	//***** TEST MODE Ramp信号检查 channel C *****//
	adc_ramp_check #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.PARALLEL_PATH_NUM(PARALLEL_PATH_NUM)
	)
	U_adc_ramp_check_C (
	.clk(clk), 
	.detect_in(detect_in), 
	.adc_sync_all_bit_i(adc_sync_all_bit_i_C), 
	.ADC_Is_Ramp(ADC_Is_Ramp_C)
	);
	
	//***** TEST MODE Ramp信号检查 channel D *****//
	adc_ramp_check #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.PARALLEL_PATH_NUM(PARALLEL_PATH_NUM)
	)
	U_adc_ramp_check_D (
	.clk(clk), 
	.detect_in(detect_in), 
	.adc_sync_all_bit_i(adc_sync_all_bit_i_D), 
	.ADC_Is_Ramp(ADC_Is_Ramp_D)
	);

endmodule
