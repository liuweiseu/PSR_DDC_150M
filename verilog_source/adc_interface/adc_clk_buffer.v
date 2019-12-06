`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:38 11/06/2018 
// Design Name: 
// Module Name:    adc_clk_buffer 
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
module adc_clk_buffer #(
	)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		adc_clk_p,
		adc_clk_n,
		adc_clk_buf
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
	
	input                                     adc_clk_p;
	input                                     adc_clk_n;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output                                    adc_clk_buf;

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
	
	//***** 差分输入时钟*****//
	IBUFGDS #(
	.DIFF_TERM("TRUE"),       // DifferentiL Termination (Virtex-5, Spartan-3E/3A)
	.IOSTANDARD("DEFAULT")     // Specify the input I/O standard
	) 
	IBUFGDS_CLK (
	.O(adc_clk_buf),  // Buffer output
	.I(adc_clk_p),  // Diff_p buffer input (connect directly to top-level port)
	.IB(adc_clk_n) // Diff_n buffer input (connect directly to top-level port)
	);
	
endmodule
