`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:36 11/06/2018 
// Design Name: 
// Module Name:    adc_if_single_path 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	1、接ADC的一路H或L数据，分成2（PSR）或4（RSR）路并行输出，包括了IODELAY、ISERDES或IDDR等
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "../include/application_define.v"
module adc_if_single_path #(
	parameter REFCLK_FREQ = 200.0,
	parameter ADC_DATA_WIDTH = 8,
	parameter CNTVALUEIN[7 : 0] = {0,0,0,0,0,0,0,0}
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_clk_bufio,
		adc_clk_bufr,
		adc_in_p,
		adc_in_n,
		rst_iodelay_sync,	//与输入的adc_clk_bufr同步
		rst_iserdes_sync,	//与输入的adc_clk_bufr同步
		adc_single_path_all_bit_o	//分解并行的数据合成为一路，由低到高
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

	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                              adc_clk_bufio;
	input                                              adc_clk_bufr;
	input     [ADC_DATA_WIDTH-1:0]                     adc_in_p;
	input     [ADC_DATA_WIDTH-1:0]                     adc_in_n;
	input                                              rst_iodelay_sync;	
	input                                              rst_iserdes_sync;	
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_single_path_all_bit_o;		


	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                                adc_clk_buf;
	wire                                                adc_clk_bufr;
	wire                                                adc_clk_bufio;
	wire      [ADC_DATA_WIDTH-1:0]                      adc_buf_o;
	wire      [ADC_DATA_WIDTH-1:0]                      adc_delay_o;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]    adc_parrel_o;
	wire                                                rst_iserdes_iodelay_sync_d1;
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign   adc_single_path_all_bit_o = adc_parrel_o;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//

	//***** 数据buffer *****//
	adc_data_buffer #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	u_adc_data_buffer (
	.adc_in_p(adc_in_p), 
	.adc_in_n(adc_in_n), 
	.adc_buf_o(adc_buf_o)
	);
	
	//***** 数据IODELAY *****//
	adc_data_iodelay #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.REFCLK_FREQ(REFCLK_FREQ),
	.CNTVALUEIN(CNTVALUEIN)
	)
	u_adc_data_iodelay (
	.adc_buf_in(adc_buf_o), 
	.adc_clk_bufio(adc_clk_bufr), 
	.adc_clk_bufr(adc_clk_bufr), 
	.rst_sync(rst_iodelay_sync), 
	.adc_delay_o(adc_delay_o)
	);
	
	//***** 数据serdes *****//
	adc_iserdes #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	u_adc_iserdes (
	.adc_data_from_iodelay(adc_delay_o), 
	.adc_clk_bufio(adc_clk_bufio), 
	.adc_clk_bufr(adc_clk_bufr), 
	.rst_iserdes_sync(rst_iserdes_sync), 
	.adc_parrel_o(adc_parrel_o)
	);
	
endmodule
