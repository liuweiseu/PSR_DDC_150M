`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:34 11/06/2018 
// Design Name: 
// Module Name:    adc_data_interface_one_core 
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
module adc_data_interface_one_core#(
	parameter REFCLK_FREQ = 200.0,
	parameter ADC_DATA_WIDTH = 8,
	parameter CNTVALUEIN_H[7 : 0] = {0,0,0,0,0,0,0,0},
	parameter CNTVALUEIN_L[7 : 0] = {0,0,0,0,0,0,0,0},
	parameter CLK_DELAY = 0
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_clk_p,
		adc_clk_n,
		adc_in_H_p,
		adc_in_H_n,
		adc_in_L_p,
		adc_in_L_n,
		refclk,
		rst_iserdes_async,	//内部完成同步处理
		rst_iodelay_dat_async,	//内部完成同步处理
		rst_iodelay_clk_async,	//内部完成同步处理
		rst_idelayctrl_asyn,		
		rst_bufr_asyn,
		clk,			//FPGA内部主时钟，频率与BUFR分频后一致		
		arst_data_sync,
		idelayctrl_rdy,
		adc_sync_all_bit_o_H,
		adc_sync_all_bit_o_L
		
	);
	
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	`ifdef RSR
		localparam PARALLEL_PATH_NUM = 4;
		localparam FREQ_DIV = "2";
	`elsif PSR
		localparam PARALLEL_PATH_NUM = 2;
		localparam FREQ_DIV = "BYPASS";
	`endif

	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                                       adc_clk_p;
	input                                                       adc_clk_n;
	input     [ADC_DATA_WIDTH-1:0]                              adc_in_H_p;
	input     [ADC_DATA_WIDTH-1:0]                              adc_in_H_n;
	input     [ADC_DATA_WIDTH-1:0]                              adc_in_L_p;
	input     [ADC_DATA_WIDTH-1:0]                              adc_in_L_n;
	input                                                       refclk;
	input                                                       rst_iserdes_async;	//;	//内部完成同步处理
	input                                                       rst_iodelay_dat_async;
	input                                                       rst_iodelay_clk_async;
	
	input                                                       rst_idelayctrl_asyn;		
	input                                                       rst_bufr_asyn;
	input                                                       clk;			//FPGA内部主时钟，频率与BUFR分频后一致
	input                                                       arst_data_sync;
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	output                                                      idelayctrl_rdy;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]            adc_sync_all_bit_o_H;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]            adc_sync_all_bit_o_L;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                               adc_clk_buf;
	wire                                               rst_clk_iodelay_sync;
	wire                                               rst_dat_iodelay_sync;
	wire                                               rst_iserdes_sync;
	wire                                               adc_clk_bufio;
	wire                                               adc_clk_bufr;	
	wire                                               data_idelayctrl_rdy_H;
	wire                                               data_idelayctrl_rdy_L;	
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_single_path_all_bit_o_H;	
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_single_path_all_bit_o_L;
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign data_idelayctrl_rdy = data_idelayctrl_rdy_H & data_idelayctrl_rdy_L;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** refclk异步复位同步释放 *****//
	reset_global u_reset_sync_clk_iodelay (
    .clk(refclk), 	//接div时钟
    .rst_asyn(rst_iodelay_clk_async), 
    .rst_out(rst_clk_iodelay_sync)
    );
		
	//***** 时钟buffer *****//
	adc_clk_buffer u_adc_clk_buffer (
	.adc_clk_p(adc_clk_p), 
	.adc_clk_n(adc_clk_n), 
	.adc_clk_buf(adc_clk_buf)
	);
	
	//***** 异步复位同步释放 *****//
	reset_global u_reset_sync_data_iodelay (
    .clk(adc_clk_bufr), 	//接div时钟
    .rst_asyn(rst_iodelay_dat_async), 
    .rst_out(rst_dat_iodelay_sync)
    );
	
	//***** 异步复位同步释放 *****//
	reset_global u_reset_sync_data_iserdes (
    .clk(adc_clk_bufr), 	//接div时钟
    .rst_asyn(rst_iserdes_async), 
    .rst_out(rst_iserdes_sync)
    );
		
	//***** IODELAYCTRL *****//
	IDELAYCTRL IDELAYCTRL1 (
	.RDY(idelayctrl_rdy),       // 1-bit Ready output
	.REFCLK(refclk), 				 // 1-bit Reference clock input
	.RST(rst_idelayctrl_asyn)   // 1-bit Reset input
   );
   
	//***** 时钟IODELAY,BUFIO和BUFR *****//
	adc_clk_if #(
	.REFCLK_FREQ(REFCLK_FREQ),
	.FREQ_DIV(FREQ_DIV),
	.CLK_DELAY(CLK_DELAY)
	)
	u_adc_clk_if (
	.adc_clk_in(adc_clk_buf), 
	.rst_bufr_asyn(rst_bufr_asyn), 
	.rst_sync(rst_clk_iodelay_sync), 
	.refclk(refclk), 
	.adc_clk_bufio(adc_clk_bufio), 
	.adc_clk_bufr(adc_clk_bufr)
	);
	//***** H路接口 *****//
	adc_if_single_path #(
	.REFCLK_FREQ(REFCLK_FREQ),
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.CNTVALUEIN(CNTVALUEIN_H)
	)
	u_adc_if_single_path_H (
	.adc_clk_bufio(adc_clk_bufio), 
	.adc_clk_bufr(adc_clk_bufr), 
	.adc_in_p(adc_in_H_p), 
	.adc_in_n(adc_in_H_n),  
	.rst_iodelay_sync(rst_dat_iodelay_sync),
	.rst_iserdes_sync(rst_iserdes_sync), 
	.adc_single_path_all_bit_o(adc_single_path_all_bit_o_H)
	);	
	
	//***** H路跨时钟域处理 *****//
	adc_data_sync #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	u_adc_data_sync_H (
	.wr_clk(adc_clk_bufr), 
	.rd_clk(clk), 
	.arst(arst_data_sync),
	.adc_async_all_bit_in(adc_single_path_all_bit_o_H), 
	.adc_sync_all_bit_o(adc_sync_all_bit_o_H)
    );
	
	//***** L路接口 *****//
	adc_if_single_path #(
	.REFCLK_FREQ(REFCLK_FREQ),
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.CNTVALUEIN(CNTVALUEIN_L)
	)
	u_adc_if_single_path_L (
	.adc_clk_bufio(adc_clk_bufio), 
	.adc_clk_bufr(adc_clk_bufr), 
	.adc_in_p(adc_in_L_p), 
	.adc_in_n(adc_in_L_n), 
	.rst_iodelay_sync(rst_dat_iodelay_sync),
	.rst_iserdes_sync(rst_iserdes_sync),
	.adc_single_path_all_bit_o(adc_single_path_all_bit_o_L)
	);	
	
	//***** L路跨时钟域处理 *****//
	adc_data_sync #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	u_adc_data_sync_L (
	.wr_clk(adc_clk_bufr), 
	.rd_clk(clk), 
	.arst(arst_data_sync),
	.adc_async_all_bit_in(adc_single_path_all_bit_o_L), 
	.adc_sync_all_bit_o(adc_sync_all_bit_o_L)
    );

endmodule
