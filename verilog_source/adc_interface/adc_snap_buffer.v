`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:34:54 11/07/2018 
// Design Name: 
// Module Name:    adc_snap_buffer 
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
module adc_snap_buffer #(
	parameter ADC_DATA_WIDTH = 8,
	parameter ARM_BUS_DATA_WIDTH = 16
	)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		wr_clk,
		rd_clk,
		srst,
		adc_sync_all_bit_i_A,
		adc_sync_all_bit_i_B,
		adc_sync_all_bit_i_C,
		adc_sync_all_bit_i_D,
		snap_capture_start,
		adc_snap_addr,
		
		adc_snap_data,
		snap_capture_ready
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
	
	localparam WR_ADDR_THRESHOLD = 511;
	localparam WR_ADDR_WIDTH = clog2b(WR_ADDR_THRESHOLD+1);
	`ifdef RSR	
		localparam PARALLEL_PATH_NUM = 4;
	`elsif PSR 
		localparam PARALLEL_PATH_NUM = 2;
	`endif
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;
	localparam SNAP_RD_ADDR_WIDTH = clog2b(WR_ADDR_THRESHOLD*ADC_DATA_WIDTH*4*PARALLEL_PATH_NUM_PER_CORE/ADC_DATA_WIDTH);
	localparam INPUT_DATA_WIDTH = ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE;

	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                     wr_clk;
	input                                     rd_clk;
	input                                     srst;
	input     [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_A;
	input     [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_B;
	input     [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_C;
	input     [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_D;
	input                                     snap_capture_start;
	input     [ARM_BUS_DATA_WIDTH-1:0]        adc_snap_addr;
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
    
	output    [ADC_DATA_WIDTH-1:0]            adc_snap_data;
	output                                    snap_capture_ready;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	reg                                       wea;
	reg       [WR_ADDR_WIDTH-1:0]             wr_addr;
	wire      [INPUT_DATA_WIDTH*4-1:0]        dina;
	wire      [SNAP_RD_ADDR_WIDTH-1:0]        rd_addr;
	reg                                       snap_capture_start_reg;
	reg                                       snap_capture_ready_reg;
	wire      [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_A_reg;
	wire      [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_B_reg;
	wire      [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_C_reg;
	wire      [INPUT_DATA_WIDTH-1:0]          adc_sync_all_bit_i_D_reg;
	
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign snap_capture_ready = snap_capture_ready_reg;
	assign            rd_addr = adc_snap_addr[SNAP_RD_ADDR_WIDTH-1:0];
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	assign dina = {adc_sync_all_bit_i_D_reg,adc_sync_all_bit_i_C_reg,adc_sync_all_bit_i_B_reg,adc_sync_all_bit_i_A_reg};
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** 数据输入打拍,A *****//
	delay_line #(
	.DATA_WIDTH(INPUT_DATA_WIDTH),
	.PIPELINE_DEPTH(3) 
	)
	U_delay_line_A (
	.clk(wr_clk), 
	.nd(1'b1), 
	.din(adc_sync_all_bit_i_A), 
	.q(adc_sync_all_bit_i_A_reg)
	);
	
	//***** 数据输入打拍,B *****//
	delay_line #(
	.DATA_WIDTH(INPUT_DATA_WIDTH),
	.PIPELINE_DEPTH(3) 
	)
	U_delay_line_B (
	.clk(wr_clk), 
	.nd(1'b1), 
	.din(adc_sync_all_bit_i_B), 
	.q(adc_sync_all_bit_i_B_reg)
	);
	
	//***** 数据输入打拍,C *****//
	delay_line #(
	.DATA_WIDTH(INPUT_DATA_WIDTH),
	.PIPELINE_DEPTH(3) 
	)
	U_delay_line_C (
	.clk(wr_clk), 
	.nd(1'b1), 
	.din(adc_sync_all_bit_i_C), 
	.q(adc_sync_all_bit_i_C_reg)
	);
	//***** 数据输入打拍,D*****//
	delay_line #(
	.DATA_WIDTH(INPUT_DATA_WIDTH),
	.PIPELINE_DEPTH(3) 
	)
	U_delay_line_D (
	.clk(wr_clk), 
	.nd(1'b1), 
	.din(adc_sync_all_bit_i_D), 
	.q(adc_sync_all_bit_i_D_reg)
	);
	
	//***** snap_capture_start打拍 *****//
	always @(posedge wr_clk)
	begin
		if(srst)
			snap_capture_start_reg <= 1'b0;
		else
			snap_capture_start_reg <= snap_capture_start;
	end
	
	//***** 检测snap_capture_start上升沿，拉高wea，ram写满后wea自动拉低 *****//
	always @(posedge wr_clk)
	begin
		if(srst)
			begin
				wea <= 1'b0;
				snap_capture_ready_reg <= 1'b0;
			end
		else if(snap_capture_start==1 && snap_capture_start_reg ==0)
			begin
				wea <= 1'b1;
				snap_capture_ready_reg <= 1'b0;
			end
		else if(wr_addr == WR_ADDR_THRESHOLD)
			begin
				wea <= 1'b0;
				snap_capture_ready_reg <= 1'b1;
			end
		else
			begin
				wea <= wea;
				snap_capture_ready_reg <= snap_capture_ready_reg;
			end 
	end
	
	//***** wr_addr自动+1 *****//
	always @(posedge wr_clk)
	begin
		if(srst)
			wr_addr <= 1'b0;
		else if(wea == 1'b1)
			wr_addr <= wr_addr + 1'b1;
		else
			wr_addr <= wr_addr;
	end
	
	//***** Snap数据缓存，RAM *****//	
	`ifdef RSR
		adc_snap_ram_rsr U_adc_snap_ram_rsr (
		.clka(wr_clk), // input clka
		.ena(wea), // input ena
		.wea(wea), // input  wea
		.addra(wr_addr), // input  addra
		.dina(dina), // input  dina
		.clkb(rd_clk), // input clkb
		.rstb(srst), 
		.addrb(rd_addr), // input  addrb
		.doutb(adc_snap_data) // output  doutb
		);
	`elsif PSR
		adc_snap_ram_psr U_adc_snap_ram_psr (
		.clka(wr_clk), // input clka
		.ena(wea), // input ena
		.wea(wea), // input  wea
		.addra(wr_addr), // input  addra
		.dina(dina), // input  dina
		.clkb(rd_clk), // input clkb
		.rstb(srst), 
		.addrb(rd_addr), // input  addrb
		.doutb(adc_snap_data) // output  doutb
		);
	`endif

	//*************************************//
	//********** simulation only **********//
	//*************************************//
	



endmodule
