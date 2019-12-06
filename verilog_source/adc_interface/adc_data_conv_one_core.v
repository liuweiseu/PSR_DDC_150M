`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:15 11/12/2018 
// Design Name: 
// Module Name:    adc_data_conv_one_core 
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
module adc_data_conv_one_core#(
	parameter ADC_DATA_WIDTH = 8
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_unsigned_all_bit_i,
		clk,
		adc_signed_all_bit_o
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
	
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_unsigned_all_bit_i;	
	input                                                       clk;		

	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_signed_all_bit_o;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path_reg[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path_logic[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path_o_reg[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	genvar m;
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_signed_all_bit_o
		 assign adc_signed_all_bit_o[(m+1)*ADC_DATA_WIDTH-1:m*ADC_DATA_WIDTH] = adc_path_o_reg[m];
	end
	endgenerate		
	//*************************************//
	//*********** assign internals ********//
	//*************************************//

	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_path_		
		assign     adc_path[m] = adc_unsigned_all_bit_i[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
	end
	endgenerate
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	//***** input buffer *****//
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_path_buf_in
		delay_line #(
		.DATA_WIDTH(ADC_DATA_WIDTH),
		.PIPELINE_DEPTH(1) 
		)
		U_delay_line_adc_path (
		.clk(clk), 
		.nd(1'b1), 
		.din(adc_path[m]), 
		.q(adc_path_reg[m])
		);
	end
	endgenerate
	
	//***** logic *****//
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_path_logic
		 assign adc_path_logic[m] = {(~adc_path_reg[m][ADC_DATA_WIDTH-1]),adc_path_reg[m][ADC_DATA_WIDTH-2:0]};
	end
	endgenerate		
	
	//***** output buffer *****//
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_path_o
		delay_line #(
		.DATA_WIDTH(ADC_DATA_WIDTH),
		.PIPELINE_DEPTH(1) 
		)
		U_delay_line_adc_path (
		.clk(clk), 
		.nd(1'b1), 
		.din(adc_path_logic[m]), 
		.q(adc_path_o_reg[m])
		);
	end
	endgenerate

endmodule
