`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:25:29 11/06/2018 
// Design Name: 
// Module Name:    adc_data_sync 
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
module adc_data_sync #(
	parameter ADC_DATA_WIDTH = 8
)	


	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		wr_clk,
		rd_clk,
		arst,
		adc_async_all_bit_in,
		adc_sync_all_bit_o	//分解并行的数据合成为一路，由低到高
	);
	
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	function integer clog2b;
	input integer value;
	begin
		if (value==1)
			clog2b = 0;
		else begin
			value = value-1;
			for (clog2b=0;value>0;clog2b=clog2b+1)
				value = value>>1;
		end
	end
	endfunction
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	`ifdef RSR
		localparam PARALLEL_PATH_NUM = 4;
	`elsif PSR
		localparam PARALLEL_PATH_NUM = 2;
	`endif
	localparam FIFO_DEPTH = 16;	//必须2次幂，因为实际是调用IP核
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                              wr_clk;
	input                                              rd_clk;
	input                                              arst;
	input     [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_async_all_bit_in;
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                                wr_en;
	wire                                                rd_en;
	wire                                                srst;
	wire      [ADC_DATA_WIDTH-1:0]                      adc_in_paths[0:PARALLEL_PATH_NUM-1];
	wire      [ADC_DATA_WIDTH-1:0]                      adc_sync_paths[0:PARALLEL_PATH_NUM-1];
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	genvar i;
	generate
	for (i=0;i < PARALLEL_PATH_NUM; i=i+1) 
	begin: assign_data_out
		assign   adc_sync_all_bit_o[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH] = adc_sync_paths[i];
	end
	endgenerate
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	genvar k;
	generate
	for (k=0;k < PARALLEL_PATH_NUM; k=k+1) 
	begin: assign_data_in
		assign   adc_in_paths[k] = adc_async_all_bit_in[((k+1)*ADC_DATA_WIDTH-1):k*ADC_DATA_WIDTH];
	end
	endgenerate
	
	assign    wr_en = 1'b1;
	assign    rd_en = 1'b1;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** refclk异步复位同步释放 *****//
	reset_global u_reset_sync (
    .clk(rd_clk), 	//接全局同步时钟
    .rst_asyn(arst), 
    .rst_out(srst)
    );
	
	//***** 跨时钟域FIFO *****//
	genvar j;
	generate
	for (j=0;j < PARALLEL_PATH_NUM; j=j+1) 
	begin: adc_sync_fifo	
		adc_sync u_adc_sync (
		.clk(rd_clk),
		.rst(srst), // input rst
		.din(adc_in_paths[j]), // input  din
		.dout(adc_sync_paths[j]) // output  dout
		);
	end
	endgenerate

endmodule
