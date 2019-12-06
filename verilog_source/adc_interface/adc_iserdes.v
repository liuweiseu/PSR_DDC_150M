`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:28 11/06/2018 
// Design Name: 
// Module Name:    adc_iserdes 
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
module adc_iserdes #(
	parameter ADC_DATA_WIDTH = 8
	)

	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
	adc_data_from_iodelay,		//接来自ADC的一路H或L数据
	adc_clk_bufio,
	adc_clk_bufr,
	rst_iserdes_sync,	// sync rst for idelay & iserdes	2015-7-27 BY ZTY
	adc_parrel_o
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
	
	input     [ADC_DATA_WIDTH-1:0]                           adc_data_from_iodelay;
	input                                                    adc_clk_bufio;
	input                                                    adc_clk_bufr;
	input                                                    rst_iserdes_sync;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output    [PARALLEL_PATH_NUM*ADC_DATA_WIDTH-1:0]         adc_parrel_o;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire      [ADC_DATA_WIDTH-1:0]                           adc_serdes[0:PARALLEL_PATH_NUM-1];
	wire                                                     clkb;
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	genvar i;
	generate
	for (i=1;i <= PARALLEL_PATH_NUM; i=i+1) 
	begin: assign_adc_iserdes
		assign adc_parrel_o[((i*ADC_DATA_WIDTH)-1):((i-1)*ADC_DATA_WIDTH)] = adc_serdes[i-1];
	end
	endgenerate
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	assign  clkb = ~adc_clk_bufio;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//

   `ifdef RSR	
	//***** 数据信号ISERDES *****//
	genvar j;
	generate
	for (j=0;j < ADC_DATA_WIDTH; j=j+1) 
	begin: adc_data_iserdes
		ISERDESE1 #(
		.DATA_RATE("DDR"),           // SDR or DDR
		.DATA_WIDTH(PARALLEL_PATH_NUM),              // Parallel data width (2-8, 10)
		.DYN_CLKDIV_INV_EN("FALSE"), // Enable DYNCLKDIVINVSEL inversion (TRUE/FALSE)
		.DYN_CLK_INV_EN("FALSE"),    // Enable DYNCLKINVSEL inversion (TRUE/FALSE)
		.INTERFACE_TYPE("NETWORKING"),   // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, or OVERSAMPLE
		.IOBDELAY("BOTH"),           // NONE, IBUF, IFD, BOTH
		.NUM_CE(1),                  // Number of clock enables (1 or 2)
		.OFB_USED("FALSE"),          // Select OFB path (TRUE/FALSE)
		.SERDES_MODE("MASTER")       // MASTER or SLAVE
		)
		ISERDES1_adc_data (
		.O(),                       // 1-bit Combinatorial output
		// Q1 - Q6: 1-bit (each) Data outputs
		.Q1(adc_serdes[3][j]),
		.Q2(adc_serdes[2][j]),
		.Q3(adc_serdes[1][j]),
		.Q4(adc_serdes[0][j]),
		.Q5(),
		.Q6(),
		// SHIFTOUT1/SHIFTOUT2: 1-bit (each) Cascade outputs for data width expansion
		.SHIFTOUT1(),
		.SHIFTOUT2(),
		.BITSLIP(1'b0),           // 1-bit The BITSLIP pin performs a Bitslip operation synchronous to CLKDIV
		.CE1(1'b1),		// CE1, CE2: 1-bit (each) Data register clock enable inputs
		.CE2(),
		.CLK(adc_clk_bufio),                   // 1-bit Clock input
		.CLKB(clkb),                 // 1-bit Secondary clock input
		.CLKDIV(adc_clk_bufr),             // 1-bit Divided clock input
		.D(),                       // 1-bit Data input
		.DDLY(adc_data_from_iodelay[j]),                 // 1-bit Serial input data from IODELAY
		.DYNCLKDIVSEL(), // 1-bit Dynamic CLKDIV inversion input
		.DYNCLKSEL(),       // 1-bit Dynamic CLK/CLKB inversion input
		.OCLK(),                 // 1-bit High speed output clock input
		.OFB(),                   // 1-bit Feedback path input
		.RST(rst_iserdes_sync),                   // 1-bit Active high asynchronous reset input
		// SHIFTIN1/SHIFTIN2: 1-bit (each) Cascade inputs for data width expansion
		.SHIFTIN1(),
		.SHIFTIN2() 
		);
	end
	endgenerate
	`elsif PSR
	genvar j;
	generate
	for (j=0;j < ADC_DATA_WIDTH; j=j+1) 
	begin: adc_data_iddr
		IDDR #(
		.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE" 
								  //    or "SAME_EDGE_PIPELINED" 
		.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
		.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
		.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
		) IDDR_adc_data (
		.Q1(adc_serdes[0][j]), // 1-bit output for positive edge of clock 
		.Q2(adc_serdes[1][j]), // 1-bit output for negative edge of clock
		.C(adc_clk_bufr),   // 1-bit clock input
		.CE(1'b1), // 1-bit clock enable input
		.D(adc_data_from_iodelay[j]),   // 1-bit DDR data input
		.R(rst_iserdes_sync),   // 1-bit reset
		.S(1'b0)    // 1-bit set
		);
	end 
	endgenerate
	`endif
endmodule
