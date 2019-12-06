`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:32 11/06/2018 
// Design Name: 
// Module Name:    adc_clk_if 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 1、包括了ibufds、iodelay和BUFIO、BUFR
//				2、BUFR的分频倍数根据后面ISERDES的并行路数决定，
//					以现有EV8AQ160的1:2DMUX为例，单核分成4路，设置"1"，ISERDES每个分2路；单核分成8路，设置"2"，ISERDES每个分4路
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module adc_clk_if #(
	parameter REFCLK_FREQ = 200.0,
	parameter CNTVALUE_WIDTH = 5,
	parameter FREQ_DIV = "2",	//根据ISERDES的分频倍数决定，注意是字符形式
	parameter CLK_DELAY = 0
    )
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		adc_clk_in,
		rst_bufr_asyn,			//BUFR的异步复位
		rst_sync,	// sync rst for idelay & iserdes	2015-7-27 BY ZTY
		refclk,
		adc_clk_bufio,
		adc_clk_bufr,
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
	
	input                                     adc_clk_in;
	input                                     rst_bufr_asyn;
	input                                     rst_sync;
	input                                     refclk;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	output                                    adc_clk_bufio;
	output                                    adc_clk_bufr;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                      T;
	wire                                      bufr_ce;
	wire                                      iodelay_ce;
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//

	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//

	assign      bufr_ce  = 1'b1;
	assign             T = 1'b1;
	assign    iodelay_ce = 1'b0;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** 时钟信号 IODELAY *****//
	IODELAYE1 #(
	.CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion ("TRUE"/"FALSE") 
	.DELAY_SRC("I"),                 // Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
	.HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
	.IDELAY_TYPE("FIXED"),         // "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE" 
	.IDELAY_VALUE(CLK_DELAY),        // Input delay tap setting (0-32)
	.ODELAY_TYPE("FIXED"),           // "FIXED", "VARIABLE", or "VAR_LOADABLE" 
	.ODELAY_VALUE(0),                // Output delay tap setting (0-32)
	.REFCLK_FREQUENCY(REFCLK_FREQ),        // IDELAYCTRL clock input frequency in MHz
	.SIGNAL_PATTERN("CLOCK")          // "DATA" or "CLOCK" input signal
	)
   IODELAY1_CLK (
	.CNTVALUEOUT(), // 5-bit output - Counter value for monitoring purpose
	.DATAOUT(adc_clk_delay_o),         // 1-bit output - Delayed data output
	.C(refclk),                     // 1-bit input - Clock input,与rst_sync同步
	.CE(iodelay_ce),                   // 1-bit input - Active high enable increment/decrement function
	.CINVCTRL(),       // 1-bit input - Dynamically inverts the Clock (C) polarity
	.CLKIN(),             // 1-bit input - Clock Access into the IODELAY
	.CNTVALUEIN(0),   // 5-bit input - Counter value for loadable counter application
	.DATAIN(),           // 1-bit input - Internal delay data
	.IDATAIN(adc_clk_in),         // 1-bit input - Delay data input
	.INC(),                 // 1-bit input - Increment / Decrement tap delay
	.ODATAIN(),         // 1-bit input - Data input for the output datapath from the device
	.RST(rst_sync),                 // 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/
								// ODELAY_VALUE tap. If no value is specified, the default is 0.
	.T(T)                      // 1-bit input - 3-state input control. Tie high for input-only or internal delay or
								// tie low for output only
   );
   
	//***** 时钟BUFIO*****//
   BUFIO clk_bufio (
      .O(adc_clk_bufio), // 1-bit output: Clock output port (connect to I/O clock loads)
      .I(adc_clk_delay_o)  // 1-bit input: Clock input port (connect to IBUFG)
   );
	
	//***** 接BUFR，供ISERDES和IODELAY使用 *****//
	BUFR #(
		.BUFR_DIVIDE(FREQ_DIV), // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8" 
		.SIM_DEVICE("VIRTEX6")  // Must be set to "VIRTEX6" 
	)
	BUFR_DIV (
		.O(adc_clk_bufr),     // 1-bit output: Clock output port
		.CE(bufr_ce),   // 1-bit input: Active high, clock enable (Divided modes only)
		.CLR(rst_bufr_asyn), // 1-bit input: Active high, asynchronous clear (Divided modes only)
		.I(adc_clk_delay_o)      // 1-bit input: Clock buffer input driven by an IBUFG, MMCM or local interconnect
	);

endmodule
