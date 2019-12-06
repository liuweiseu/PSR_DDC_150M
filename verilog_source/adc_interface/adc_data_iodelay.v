`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:00 11/06/2018 
// Design Name: 
// Module Name:    adc_data_iodelay 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  1、将所有位宽的CNTVALUEIN和CNTVALUEOUT按数据最低位在低、
//                    最高位在高接成一个XX_ALL信号，这样即使数据和CNTVALUE位宽变化，模块也不需要做任何修改
//                    例如两位数据L0,L1，对应的CNTVALUEIN_ALL={CNTVALUEIN1,CNTVALUEIN0}；输出同理
//               2、IDELAYCTRL和IDELAY
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

//`resetall
//`include "marcos.v"
module adc_data_iodelay#(
	parameter REFCLK_FREQ = 200.0,
	parameter ADC_DATA_WIDTH = 8,
	parameter integer CNTVALUEIN[7 : 0]= {0,0,0,0,0,0,0,0}
	)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
	adc_buf_in,
	adc_clk_bufio,
	adc_clk_bufr,
	rst_sync,	// sync rst for idelay & iserdes	2015-7-27 BY ZTY
	adc_delay_o
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
	
	input     [ADC_DATA_WIDTH-1:0]                           adc_buf_in;
	input                                                    adc_clk_bufio;
	input                                                    adc_clk_bufr;
	input                                                    rst_sync;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output    [ADC_DATA_WIDTH-1:0]                           adc_delay_o;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	wire                                      T;
	wire                                      iodelay_ce;
	

	
	assign T           = 1'b1;
	assign iodelay_ce  = 1'b0;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//

	
   
	//***** 数据信号IODELAY *****//
	genvar j;
	generate
	for (j=0;j < ADC_DATA_WIDTH; j=j+1) 
	begin: adc_data_iodelay
		IODELAYE1 #(
		.CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion ("TRUE"/"FALSE") 
		.DELAY_SRC("I"),                 // Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
		.HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
		.IDELAY_TYPE("FIXED"),         // "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE" 
		.IDELAY_VALUE(CNTVALUEIN[ADC_DATA_WIDTH-1-j]),        			// Input delay tap setting (0-32) 
		.ODELAY_TYPE("FIXED"),           // "FIXED", "VARIABLE", or "VAR_LOADABLE" 
		.ODELAY_VALUE(0),                // Output delay tap setting (0-32)
		.REFCLK_FREQUENCY(REFCLK_FREQ),        // IDELAYCTRL clock input frequency in MHz
		.SIGNAL_PATTERN("DATA")          // "DATA" or "CLOCK" input signal
		)
		IODELAY1_adc_data (
		.CNTVALUEOUT(), // 5-bit output - Counter value for monitoring purpose
		.DATAOUT(adc_delay_o[j]),         // 1-bit output - Delayed data output
		.IDATAIN(adc_buf_in[j]),         // 1-bit input - Delay data input
		.CNTVALUEIN(0),	// 5-bit input - Counter value for loadable counter application
		.C(adc_clk_bufr), 		// 与rst_sync同步
		.CE(iodelay_ce),  
		.RST(rst_sync),                 // 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/
		 // ODELAY_VALUE tap. If no value is specified, the default is 0.
		.T(T)                      // 1-bit input - 3-state input control. Tie high for input-only or internal delay or
		 // tie low for output only.
		);
	end
	endgenerate

endmodule
