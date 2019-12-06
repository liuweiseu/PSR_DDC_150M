`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:45:26 11/12/2018 
// Design Name: 
// Module Name:    adc_min_one_core 
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
module adc_min_one_core #(
	parameter ADC_DATA_WIDTH = 8
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_all_bit_i_one_core,
		clk,
		rst,
		adc_min_o_one_core
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
	localparam MAX_INIT = (1'b1<<ADC_DATA_WIDTH)-1;
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_all_bit_i_one_core;
	input                                                       clk;		
	input                                                       rst;

	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output   [ADC_DATA_WIDTH-1:0]                               adc_min_o_one_core;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire     [ADC_DATA_WIDTH-1:0]                               adc_path_reg[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	reg      [ADC_DATA_WIDTH-1:0]                               path_min_reg[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire																			detect_in;
	wire                                                        detect_in_reg;
	`ifdef RSR
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv3[0:3];
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv2[0:1];
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv1;
	`elsif PSR
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv2[0:1];
		reg		[ADC_DATA_WIDTH-1:0]									  comparator_lv2_reg[0:1];
		reg      [ADC_DATA_WIDTH-1:0]                           comparator_lv1;
		reg 																	  comp_1v2_mid[1:0];
		reg 																	  comp_1v1_mid;
	`endif
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign adc_min_o_one_core = comparator_lv1;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	genvar m;
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_path_		
		assign     adc_path[m] = adc_all_bit_i_one_core[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
	end
	endgenerate
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	ms_gen U_ms_gen(
	.clk(clk),
	.rst(rst),
	.ms_out(detect_in)
	);
	//***** detect_in打拍 *****//
	delay_line #(
	.DATA_WIDTH(1),
	.PIPELINE_DEPTH(1) 
	)
	U_delay_line_detect_in (
	.clk(clk), 
	.nd(1'b1), 
	.din(detect_in), 
	.q(detect_in_reg)
	);
	//***** 输入缓冲 *****//
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
    
	//***** 取detec_in上升沿 *****//
	generate
		for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1)
		begin: assign_path_min_reg
			always @(posedge clk)
			begin
				if (detect_in==1'b1 && detect_in_reg==1'b0)
				begin
					path_min_reg[m] <= MAX_INIT;	//复位为最大值
				end
			else begin
					path_min_reg[m] <= (adc_path_reg[m]<path_min_reg[m])?adc_path_reg[m]:path_min_reg[m];	//如果新数据大就更新
				end
			end
		end
	endgenerate
	
	//***** 多层比较器pipeline *****//
	`ifdef RSR
		generate
			for (m=0;m < 4; m=m+1)
			begin: assign_comparator_lv3
				always @(posedge clk)
				begin
					comparator_lv3[m] <= (path_min_reg[2*m+1]<path_min_reg[2*m])?path_min_reg[2*m+1]:path_min_reg[2*m];
				end
			end
		endgenerate
		generate
			for (m=0;m < 2; m=m+1)
			begin: assign_comparator_lv2
				always @(posedge clk)
				begin
					comparator_lv2[m] <= (comparator_lv3[2*m+1]<comparator_lv3[2*m])?comparator_lv3[2*m+1]:comparator_lv3[2*m];
				end
			end
		endgenerate
		always @(posedge clk)
			comparator_lv1 <= (comparator_lv2[1]<comparator_lv2[0])?comparator_lv2[1]:comparator_lv2[0];
	`elsif PSR
		generate
			for (m=0;m < 2; m=m+1)
			begin: assign_comparator_lv2
				always @(posedge clk)
					begin
						if(path_min_reg[2*m+1]<path_min_reg[2*m])
							comp_1v2_mid[m] <= 1;
						else
							comp_1v2_mid[m] <= 0;
					end
				always @(posedge clk)
					begin
						if(comp_1v2_mid[m]==1)
							comparator_lv2[m] <= path_min_reg[2*m+1];
						else
							comparator_lv2[m] <= path_min_reg[2*m];
					end
			end
		endgenerate
		always @(posedge clk)
			begin
				if(comparator_lv2[1]<comparator_lv2[0])
					comp_1v1_mid <= 1;
				else
					comp_1v1_mid <= 0;
			end
		always @(posedge clk)
			begin
				comparator_lv2_reg[0] <= comparator_lv2[0];
				comparator_lv2_reg[1] <= comparator_lv2[1];
			end
		always @(posedge clk)
			begin
				if(comp_1v1_mid == 1)
					comparator_lv1 <= comparator_lv2_reg[1];
				else
					comparator_lv1 <= comparator_lv2_reg[0];
			end
	`endif
endmodule

