`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:04 11/06/2018 
// Design Name: 
// Module Name:    adc_buffer 
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
module adc_data_buffer#(
	parameter ADC_DATA_WIDTH = 8
	)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		adc_in_p,
		adc_in_n,
		adc_buf_o
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
	
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_n;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output    [ADC_DATA_WIDTH-1:0]                           adc_buf_o;

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
	
	//***** 差分输入数据IBUFDS *****//
	genvar i;
	generate
	for (i=0;i < ADC_DATA_WIDTH; i=i+1) 
	begin: adc_data_ibufds
		IBUFDS #(
		.DIFF_TERM("TRUE"),       // DifferentiL Termination (Virtex-5, Spartan-3E/3A)
		.IOSTANDARD("DEFAULT")     // Specify the input I/O standard
		) IBUF_adc_data (
		.O(adc_buf_o[i]),  // Buffer output
		.I(adc_in_p[i]),  // Diff_p buffer input (connect directly to top-level port)
		.IB(adc_in_n[i]) // Diff_n buffer input (connect directly to top-level port)
		);
	end
	endgenerate
	

endmodule
