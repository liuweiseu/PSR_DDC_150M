`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:02:35 11/07/2018 
// Design Name: 
// Module Name:    adc_sync_check_4_channel 
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
module adc_sync_check_4_channel #(
	parameter ADC_DATA_WIDTH = 8,
	parameter PARALLEL_PATH_NUM = 4		//是一路AH或AL分支的路数
	)	

	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	(
		clk,
		detect_in,
		adc_sync_all_bit_i_A,		//从低位到高位已经按正确的多相顺序排列，如{A4,A3,A2,A1}
		adc_sync_all_bit_i_B,
		adc_sync_all_bit_i_C,
		adc_sync_all_bit_i_D,
		ADC_Is_Sync
	);
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//

	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;	//因为有H和L两路
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                                       clk;
	input                                                       detect_in;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_A;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_B;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_C;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i_D;
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output                                                      ADC_Is_Sync;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	reg                                                         ADC_Is_Sync_detect_reg;
	reg                                                         ADC_Is_Sync_reg;
	reg                                                         detect_reg;
	reg     [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_A[0:PARALLEL_PATH_NUM_PER_CORE-1];
	reg     [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_B[0:PARALLEL_PATH_NUM_PER_CORE-1];
	reg     [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_C[0:PARALLEL_PATH_NUM_PER_CORE-1];
	reg     [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_D[0:PARALLEL_PATH_NUM_PER_CORE-1];
	wire                                                        Is_sync_condition;
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	`ifdef FOUR_CHANNEL_1200M	
		assign Is_sync_condition = (adc_sync_reg_A[0]==adc_sync_reg_B[0]) && (adc_sync_reg_B[0]==adc_sync_reg_C[0]) && (adc_sync_reg_C[0]==adc_sync_reg_D[0]);
	`elsif TWO_CHANNEL_2400M
		assign Is_sync_condition = (adc_sync_reg_A[0]==adc_sync_reg_C[0]) && (adc_sync_reg_B[0]==adc_sync_reg_D[0]) && (adc_sync_reg_A[1]==adc_sync_reg_B[0]);
	`elsif ONE_CHANNEL_4800M
		assign Is_sync_condition = (adc_sync_reg_B[0]==adc_sync_reg_C[0]) && (adc_sync_reg_C[0]==adc_sync_reg_D[0]) && (adc_sync_reg_A[1]==adc_sync_reg_B[0]);
	`endif
	

	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign ADC_Is_Sync = ADC_Is_Sync_reg;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** 数据缓冲 A路 *****//		
	genvar i;
	generate
	for (i=0;i < PARALLEL_PATH_NUM_PER_CORE; i=i+1) 
	begin: assign_adc_sync_reg_A
		always @(posedge clk)
		begin
			adc_sync_reg_A[i] <= adc_sync_all_bit_i_A[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH];
		end	
	end
	endgenerate
	
	//***** 数据缓冲 B路 *****//		
	generate
	for (i=0;i < PARALLEL_PATH_NUM_PER_CORE; i=i+1) 
	begin: assign_adc_sync_reg_B
		always @(posedge clk)
		begin
			adc_sync_reg_B[i] <= adc_sync_all_bit_i_B[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH];
		end	
	end
	endgenerate
	
	//***** 数据缓冲 C路 *****//
	generate
	for (i=0;i < PARALLEL_PATH_NUM_PER_CORE; i=i+1) 
	begin: assign_adc_sync_reg_C
		always @(posedge clk)
		begin
			adc_sync_reg_C[i] <= adc_sync_all_bit_i_C[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH];
		end	
	end
	endgenerate
	
	//***** 数据缓冲 D路 *****//
	generate
	for (i=0;i < PARALLEL_PATH_NUM_PER_CORE; i=i+1) 
	begin: assign_adc_sync_reg_D
		always @(posedge clk)
		begin
			adc_sync_reg_D[i] <= adc_sync_all_bit_i_D[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH];
		end	
	end
	endgenerate
	
	//***** dectec打拍 *****//
	always @(posedge clk)
	begin
		detect_reg <= detect_in;
	end
	
	//***** 检测dectec_in的上升沿来启动一次检测 *****//	
	always @(posedge clk)
	begin
		if ((detect_reg==1'b0) && (detect_in==1'b1))		//检测rising edge
		begin
			ADC_Is_Sync_detect_reg <= 1'b1;		//初始化为高表示对齐，如果不同步，就会被拉低
		end
		else if (Is_sync_condition==1'b1)
				ADC_Is_Sync_detect_reg <= ADC_Is_Sync_detect_reg;	//四通道对齐
			else 
				ADC_Is_Sync_detect_reg <= 1'b0;
	end

	//***** 检测dectec_in的下升沿来输出一次检测结果 *****//	
	always @(posedge clk)
	begin
		if ((detect_reg==1'b1) && (detect_in==1'b0))		//检测falling edge
		begin
			ADC_Is_Sync_reg <= ADC_Is_Sync_detect_reg;
		end
		else
		begin
			ADC_Is_Sync_reg <= ADC_Is_Sync_reg;
		end
	end
	
endmodule
