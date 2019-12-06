`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:19:16 11/12/2018 
// Design Name: 
// Module Name:    adc_min_detect 
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
`include "../include/application_define.v"
module adc_min_detect#(
	parameter ADC_DATA_WIDTH = 8
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_all_bit_i_A,
		adc_all_bit_i_B,
		adc_all_bit_i_C,
		adc_all_bit_i_D,
		clk,
		rst,
		`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数据
			adc_min_A,
			adc_min_B,
			adc_min_C,
			adc_min_D
		`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数据
			adc_min_L,
			adc_min_R
		`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数据
			adc_min_o
		`endif
		
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
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_all_bit_i_A;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_all_bit_i_B;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_all_bit_i_C;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_all_bit_i_D;	
	input                                                       clk;		
	input                                                       rst;

	//*************************************//
	//************ outputs ****************//
	//*************************************//
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数据
		output       [ADC_DATA_WIDTH-1:0]               adc_min_A;
		output       [ADC_DATA_WIDTH-1:0]               adc_min_B;
		output       [ADC_DATA_WIDTH-1:0]               adc_min_C;
		output       [ADC_DATA_WIDTH-1:0]               adc_min_D;
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数据
		output       [ADC_DATA_WIDTH-1:0]               adc_min_L;
		output       [ADC_DATA_WIDTH-1:0]               adc_min_R;
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数据
		output       [ADC_DATA_WIDTH-1:0]               adc_min_o;
	`endif
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	`ifdef FOUR_CHANNEL_1200M
	`elsif TWO_CHANNEL_2400M
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv2[0:1];
	`elsif ONE_CHANNEL_4800M
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv2[0:1];
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv1;
	`endif	
	wire      [ADC_DATA_WIDTH-1:0]                         adc_min_cores[0:3];
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	genvar i;
	`ifdef FOUR_CHANNEL_1200M
			assign     adc_min_A = adc_min_cores[0];
			assign     adc_min_B = adc_min_cores[1];
			assign     adc_min_C = adc_min_cores[2];
			assign     adc_min_D = adc_min_cores[3];
	`elsif TWO_CHANNEL_2400M
			assign     adc_min_L = comparator_lv2[0];
			assign     adc_min_R = comparator_lv2[1];
	`elsif ONE_CHANNEL_4800M
			assign     adc_min_o = comparator_lv1;
	`endif	

	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//

	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** CORE A 最小值*****//
	adc_min_one_core #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_min_one_core_A (
    .adc_all_bit_i_one_core(adc_all_bit_i_A), 
    .clk(clk), 
    .rst(rst), 
    .adc_min_o_one_core(adc_min_cores[0])
    );
	
	//***** CORE B 最小值*****//
	adc_min_one_core #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_min_one_core_B (
    .adc_all_bit_i_one_core(adc_all_bit_i_B), 
    .clk(clk), 
    .rst(rst), 
    .adc_min_o_one_core(adc_min_cores[1])
    );
	
	//***** CORE C 最小值*****//
	adc_min_one_core #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_min_one_core_C (
    .adc_all_bit_i_one_core(adc_all_bit_i_C), 
    .clk(clk), 
    .rst(rst), 
    .adc_min_o_one_core(adc_min_cores[2])
    );
	
	//***** CORE D 最小值*****//
	adc_min_one_core #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_min_one_core (
    .adc_all_bit_i_one_core(adc_all_bit_i_D), 
    .clk(clk), 
    .rst(rst), 
    .adc_min_o_one_core(adc_min_cores[3])
    );
	
	//***** 多层比较器pipeline *****//
	`ifdef FOUR_CHANNEL_1200M	//四路独立
	`elsif TWO_CHANNEL_2400M	//AB、CD合并找最小值
		genvar m;
		generate
			for (m=0;m < 2; m=m+1)
			begin: assign_comparator_lv2
				always @(posedge clk)
				begin
					comparator_lv2[m] <= (adc_min_cores[2*m+1]<adc_min_cores[2*m])?adc_min_cores[2*m+1]:adc_min_cores[2*m];
				end
			end
		endgenerate
	`endif

endmodule

