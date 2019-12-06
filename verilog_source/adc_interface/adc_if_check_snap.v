`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:33:57 11/11/2018 
// Design Name: 
// Module Name:    adc_if_check_snap 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	完整的adc接口、ramp&sync check和snap;输出数据和snap存储的已经是signed；max和min是按unsigned检测的
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "../include/application_define.v"
module adc_if_check_snap #(
	parameter ARM_BUS_DATA_WIDTH = 16,
	parameter ADC_DATA_WIDTH = 8,
	parameter CNTVALUE_WIDTH = 5
	)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	( 
		bus_clk,		//bus总线		
		main_clk,	//FPGA主时
		main_clk_div2,	//FPG		
		AD_AL_D_P,	
		AD_AL_D_N,	
		AD_AH_D_P,	
		AD_AH_D_N,	
		AD_BL_D_P,	
		AD_BL_D_N,	
		AD_BH_D_P,	
		AD_BH_D_N,	
		AD_CL_D_P,	
		AD_CL_D_N,	
		AD_CH_D_P,	
		AD_CH_D_N,	
		AD_DL_D_P,	
		AD_DL_D_N,	
		AD_DH_D_P,	
		AD_DH_D_N,	
		AD_A_CLK_P,
		AD_A_CLK_N,
		AD_B_CLK_P,
		AD_B_CLK_N,
		AD_C_CLK_P,
		AD_C_CLK_N,
		AD_D_CLK_P,
		AD_D_CLK_N,
		
		idelayctrl_rdy,	
		rst_iserdes_async,	
		rst_iodelay_clk_async,
		rst_iodelay_dat_async,
		rst_idelayctrl_asyn,
		rst_bufr_asyn,
		rst_data_fifo_asyn,
		rst_sync,
		snap_capture_start,
		adc_snap_rst,	
		adc_snap_addr,
				
		
		`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		// RSR数据就是AD_SYN_A、AD_SYN_B、AD_SYN_C、AD_SYN_D	
			ADC_DATA_A,	//按交织后顺序从低到高的ADC同步数据
			ADC_DATA_B,	//按交织后顺序从低到高的ADC同步数据		
			ADC_DATA_C,	//按交织后顺序从低到高的ADC同步数据
			ADC_DATA_D,	//按交织后顺序从低到高的ADC同步数据			
			adc_max_min_A,
			adc_max_min_B,
			adc_max_min_C,
			adc_max_min_D,
		`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
			ADC_DATA_L,	//按交织后顺序从低到高的ADC同步数据
			ADC_DATA_R,	//按交织后顺序从低到高的ADC同步数据
			adc_max_min_L,
			adc_max_min_R,
		`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
			adc_max_min_o,
		`endif
		snap_capture_ready,
		adc_snap_data
	);

	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	localparam        REFCLK_FREQ = 200.0;
	`ifdef RSR
		localparam PARALLEL_PATH_NUM = 4;
	`elsif PSR
		localparam PARALLEL_PATH_NUM = 2;
	`endif	
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//	
	
//	input                                              ADC_SYNC;	//来自BTC
	input                                              bus_clk;		//bus总线时钟
	//***** FPGA主时*****//
	input                                              main_clk;	//FPGA主时
	input                                              main_clk_div2;	//FPGA主时钟，2分频	

	//***** ADC数据 通道A *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_AL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AH_D_N;	
	//***** ADC数据 通道B *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_BL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BH_D_N;	
	//***** ADC数据 通道C *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_CL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CH_D_N;	
	//***** ADC数据 通道D *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_DL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DH_D_N;	
	//***** ADC时钟 通道A *****//
	input                                              AD_A_CLK_P;
	input                                              AD_A_CLK_N;
	//***** ADC时钟 通道B *****//
	input                                              AD_B_CLK_P;
	input                                              AD_B_CLK_N;
	//***** ADC时钟 通道C *****//
	input                                              AD_C_CLK_P;
	input                                              AD_C_CLK_N;
	//***** ADC时钟 通道D *****//
	input                                              AD_D_CLK_P;
	input                                              AD_D_CLK_N;
	//***** 复位信号 *****//
	input                                              rst_iserdes_async;	//控制iserdes异步复位信号
	input                                              rst_iodelay_clk_async;	//控制clk_iodelay异步复位信号
	input                                              rst_iodelay_dat_async;	//控制data_iodelay异步复位信号
	input                                              rst_idelayctrl_asyn;	//控制iodelayctrl的异步复位信
	input                                              rst_bufr_asyn;	//控制bufr的异步复位信
	input                                              rst_data_fifo_asyn; //控制data_sync里fifo的异步复位信
	
	//***** 检测脉冲，周期复位check *****//
	input                                              rst_sync;
	//***** adc_snap_buffer 快拍*****//
	input                                              snap_capture_start;
	input                                              adc_snap_rst;	
	input     [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_addr;
	//*************************************//
	//************ outputs ****************//
	//*************************************//
			
	output                                             idelayctrl_rdy;	//idelayctrl ready信号
	//***** adc_snap_buffer 快拍*****//
	output                                             snap_capture_ready;
	output    [ADC_DATA_WIDTH-1:0]                     adc_snap_data;
	//***** 正确顺序的数据输出，从低到高为数据从先到*****//
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
	// RSR数据就是AD_SYN_A、AD_SYN_B、AD_SYN_C、AD_SYN_D	
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                       ADC_DATA_A;	//按交织后顺序从低到高的ADC同步数据
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                       ADC_DATA_B;	//按交织后顺序从低到高的ADC同步数据		
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                       ADC_DATA_C;	//按交织后顺序从低到高的ADC同步数据
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                       ADC_DATA_D;	//按交织后顺序从低到高的ADC同步数据
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_A;
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_B;
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_C;
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_D;
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE*2-1:0]                     ADC_DATA_L;	//按交织后顺序从低到高的ADC同步数据
		output      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE*2-1:0]                     ADC_DATA_R;	//按交织后顺序从低到高的ADC同步数据
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_L;
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_R;
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
		output      [ADC_DATA_WIDTH*2-1:0]                                                adc_max_min_o;
	`endif
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	//***** iodelay时钟 *****//
	wire                                               refclk;
	

	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_AH;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_AL;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_BH;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_BL;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_CH;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_CL;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_DH;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]   adc_sync_all_bit_o_DL;

	reg       [ADC_DATA_WIDTH-1:0]                     AD_SYN_unsigned_A[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	reg       [ADC_DATA_WIDTH-1:0]                     AD_SYN_unsigned_B[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	reg       [ADC_DATA_WIDTH-1:0]                     AD_SYN_unsigned_C[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	reg       [ADC_DATA_WIDTH-1:0]                     AD_SYN_unsigned_D[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_signed_A[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_signed_B[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_signed_C[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_signed_D[0:PARALLEL_PATH_NUM_PER_CORE-1];	//按多相顺序分接后的ADC同步数据

	reg       [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_sync_all_bit_unsigned_A;	//按多相顺序合并，例如：{A3,A2,A1,A0}
	reg       [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_sync_all_bit_unsigned_B;
	reg       [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_sync_all_bit_unsigned_C;
	reg       [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_sync_all_bit_unsigned_D;
	
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_signed_all_bit_o_A;	//按多相顺序合并，例如：{A3,A2,A1,A0}
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_signed_all_bit_o_B;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_signed_all_bit_o_C;
	wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]   adc_signed_all_bit_o_D;
	
	//***** BTC ARM总线通讯*****//
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 reset;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 state;
	
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_operate;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_state;
	
	//***** ADC MAX *****//
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_A;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_B;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_C;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_D;
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_L;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_R;
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_max_o;
	`endif
	//***** ADC MIN *****//
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_A;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_B;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_C;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_D;
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_L;
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_R;
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
		wire      [ADC_DATA_WIDTH-1:0]                 adc_min_o;
	`endif
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
		
	
	// 分接并行多路数据
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		assign    ADC_DATA_A = adc_signed_all_bit_o_A;
		assign    ADC_DATA_B = adc_signed_all_bit_o_B;
		assign    ADC_DATA_C = adc_signed_all_bit_o_C;
		assign    ADC_DATA_D = adc_signed_all_bit_o_D;		
		assign adc_max_min_A = {adc_max_A,adc_min_A};
		assign adc_max_min_B = {adc_max_B,adc_min_B};
		assign adc_max_min_C = {adc_max_C,adc_min_C};
		assign adc_max_min_D = {adc_max_D,adc_min_D};
	`elsif TWO_CHANNEL_2400M //PSR设计,2.4GHz,双core恢复一路数
		genvar pm;
		generate
		for (pm=0;pm < PARALLEL_PATH_NUM_PER_CORE; pm=pm+1) 
		begin: assign_AD_SYN_signed		
			assign     AD_SYN_signed_A[pm] = adc_signed_all_bit_o_A[((pm+1)*ADC_DATA_WIDTH-1):pm*ADC_DATA_WIDTH];			
			assign     AD_SYN_signed_B[pm] = adc_signed_all_bit_o_B[((pm+1)*ADC_DATA_WIDTH-1):pm*ADC_DATA_WIDTH];
			assign     AD_SYN_signed_C[pm] = adc_signed_all_bit_o_C[((pm+1)*ADC_DATA_WIDTH-1):pm*ADC_DATA_WIDTH];
			assign     AD_SYN_signed_D[pm] = adc_signed_all_bit_o_D[((pm+1)*ADC_DATA_WIDTH-1):pm*ADC_DATA_WIDTH];
		end
		endgenerate
		
		generate
		for (pm=0;pm < PARALLEL_PATH_NUM_PER_CORE; pm=pm+1) 
		begin: assign_ADC_DATA_LR
			assign                  ADC_DATA_L[(pm)*ADC_DATA_WIDTH*2+ADC_DATA_WIDTH-1:pm*ADC_DATA_WIDTH*2] = AD_SYN_signed_A[pm];			
			assign                  ADC_DATA_L[((pm+1)*ADC_DATA_WIDTH*2-1):(pm*ADC_DATA_WIDTH*2+ADC_DATA_WIDTH)] = AD_SYN_signed_B[pm];
			assign                  ADC_DATA_R[(pm)*ADC_DATA_WIDTH*2+ADC_DATA_WIDTH-1:pm*ADC_DATA_WIDTH*2] = AD_SYN_signed_C[pm];				
			assign                  ADC_DATA_R[((pm+1)*ADC_DATA_WIDTH*2-1):(pm*ADC_DATA_WIDTH*2+ADC_DATA_WIDTH)] = AD_SYN_signed_D[pm];
		end
		endgenerate
		assign adc_max_min_L = {adc_max_L,adc_min_L};
		assign adc_max_min_R = {adc_max_R,adc_min_R};
	`elsif ONE_CHANNEL_4800M //PSR设计,4.8GHz,四core恢复一路数
	`endif
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//	
	//按顺序正确排序H和L路数
	genvar m;
	generate
	for (m=0;m < PARALLEL_PATH_NUM; m=m+1) 
	begin: assign_AD_SYN_RSR		
		`ifdef RSR
		always @(posedge main_clk_div2) 
		`elsif PSR
		always @(posedge main_clk) 
		`endif
			begin
				AD_SYN_unsigned_A[m*2] 		<= adc_sync_all_bit_o_AL[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_A[m*2+1] 	<= adc_sync_all_bit_o_AH[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_B[m*2] 		<= adc_sync_all_bit_o_BL[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_B[m*2+1] 	<= adc_sync_all_bit_o_BH[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_C[m*2] 		<= adc_sync_all_bit_o_CL[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_C[m*2+1] 	<= adc_sync_all_bit_o_CH[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_D[m*2] 		<= adc_sync_all_bit_o_DL[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
				AD_SYN_unsigned_D[m*2+1] 	<= adc_sync_all_bit_o_DH[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
			end
	end
	endgenerate
	
	
	//按顺序正确排序，拼接每一路ADC数据为一路宽位数信号
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE; m=m+1) 
	begin: assign_adc_sync_all_bit_o
		`ifdef RSR
		always @(posedge main_clk_div2) 
		`elsif PSR
		always @(posedge main_clk) 
		`endif
			begin
				adc_sync_all_bit_unsigned_A[(m+1)*ADC_DATA_WIDTH-1:m*ADC_DATA_WIDTH] <= AD_SYN_unsigned_A[m];			
				adc_sync_all_bit_unsigned_B[(m+1)*ADC_DATA_WIDTH-1:m*ADC_DATA_WIDTH] <= AD_SYN_unsigned_B[m];
				adc_sync_all_bit_unsigned_C[(m+1)*ADC_DATA_WIDTH-1:m*ADC_DATA_WIDTH] <= AD_SYN_unsigned_C[m];
				adc_sync_all_bit_unsigned_D[(m+1)*ADC_DATA_WIDTH-1:m*ADC_DATA_WIDTH] <= AD_SYN_unsigned_D[m];
			end
	end
	endgenerate
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** iodelay时钟 *****//
	refclk_gen U_refclk_gen (
	.CLK_IN1(main_clk),
	.REFCLK(refclk),	// OUT
	.RESET(1'b0),		// IN
	.LOCKED()		// OUT 该位有效）时，说明时钟输出是正常 
	);
	//***** 四通道ADC时钟和数据接*****//	
	adc_data_interface #(
	.REFCLK_FREQ(REFCLK_FREQ),
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_data_interface (
	.adc_clk_A_p(AD_A_CLK_P), 
	.adc_clk_A_n(AD_A_CLK_N), 
	.adc_in_AH_p(AD_AH_D_P), 
	.adc_in_AH_n(AD_AH_D_N), 
	.adc_in_AL_p(AD_AL_D_P), 
	.adc_in_AL_n(AD_AL_D_N), 
	.adc_clk_B_p(AD_B_CLK_P), 
	.adc_clk_B_n(AD_B_CLK_N), 
	.adc_in_BH_p(AD_BH_D_P), 
	.adc_in_BH_n(AD_BH_D_N), 
	.adc_in_BL_p(AD_BL_D_P), 
	.adc_in_BL_n(AD_BL_D_N), 
	.adc_clk_C_p(AD_C_CLK_P), 
	.adc_clk_C_n(AD_C_CLK_N), 
	.adc_in_CH_p(AD_CH_D_P), 
	.adc_in_CH_n(AD_CH_D_N), 
	.adc_in_CL_p(AD_CL_D_P), 
	.adc_in_CL_n(AD_CL_D_N),  
	.adc_clk_D_p(AD_D_CLK_P), 
	.adc_clk_D_n(AD_D_CLK_N), 
	.adc_in_DH_p(AD_DH_D_P), 
	.adc_in_DH_n(AD_DH_D_N), 
	.adc_in_DL_p(AD_DL_D_P), 
	.adc_in_DL_n(AD_DL_D_N),  
	.refclk(refclk),
	.rst_iserdes_async(rst_iserdes_async),	//内部完成同步处理
	.rst_iodelay_dat_async(rst_iodelay_dat_async),
	.rst_iodelay_clk_async(rst_iodelay_clk_async),
	.rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
	.rst_bufr_asyn(rst_bufr_asyn), 
	.arst_data_sync(rst_data_fifo_asyn),
	`ifdef RSR
		.clk(main_clk_div2), 
	`elsif PSR
		.clk(main_clk), 
	`endif
	.idelayctrl_rdy(idelayctrl_rdy), 
	.adc_sync_all_bit_o_AH(adc_sync_all_bit_o_AH), 
	.adc_sync_all_bit_o_AL(adc_sync_all_bit_o_AL), 
	.adc_sync_all_bit_o_BH(adc_sync_all_bit_o_BH), 
	.adc_sync_all_bit_o_BL(adc_sync_all_bit_o_BL), 
	.adc_sync_all_bit_o_CH(adc_sync_all_bit_o_CH), 
	.adc_sync_all_bit_o_CL(adc_sync_all_bit_o_CL), 
	.adc_sync_all_bit_o_DH(adc_sync_all_bit_o_DH), 
	.adc_sync_all_bit_o_DL(adc_sync_all_bit_o_DL)
	);
	
	//***** 四通道ADC最小值检*****//
	
	adc_min_detect #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_min_detect_4_cores (
    .adc_all_bit_i_A(adc_sync_all_bit_unsigned_A), 
    .adc_all_bit_i_B(adc_sync_all_bit_unsigned_B), 
    .adc_all_bit_i_C(adc_sync_all_bit_unsigned_C), 
    .adc_all_bit_i_D(adc_sync_all_bit_unsigned_D), 
	`ifdef RSR
		.clk(main_clk_div2), 
	`elsif PSR
		.clk(main_clk), 
	`endif 
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		.adc_min_A(adc_min_A),
		.adc_min_B(adc_min_B),
		.adc_min_C(adc_min_C),
		.adc_min_D(adc_min_D),
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
		.adc_min_L(adc_min_L),
		.adc_min_R(adc_min_R),
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
		.adc_min_o(adc_min_o),
	`endif
    .rst(rst_sync)
    );
	
	//***** 四通道ADC最大值检*****//
	adc_max_detect #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_max_detect_4_cores (
    .adc_all_bit_i_A(adc_sync_all_bit_unsigned_A), 
    .adc_all_bit_i_B(adc_sync_all_bit_unsigned_B), 
    .adc_all_bit_i_C(adc_sync_all_bit_unsigned_C), 
    .adc_all_bit_i_D(adc_sync_all_bit_unsigned_D), 
    `ifdef RSR
		.clk(main_clk_div2), 
	`elsif PSR
		.clk(main_clk), 
	`endif 
	`ifdef FOUR_CHANNEL_1200M	//RSR设计,单core恢复一路数
		.adc_max_A(adc_max_A),
		.adc_max_B(adc_max_B),
		.adc_max_C(adc_max_C),
		.adc_max_D(adc_max_D),
	`elsif TWO_CHANNEL_2400M 	//PSR设计,2.4GHz,双core恢复一路数
		.adc_max_L(adc_max_L),
		.adc_max_R(adc_max_R),
	`elsif ONE_CHANNEL_4800M 	//PSR设计,4.8GHz,四core恢复一路数
		.adc_max_o(adc_max_o),
	`endif
    .rst(rst_sync)
    );
	
	//***** 数据符号转换 *****//
	adc_data_conv U_adc_data_conv (
    .adc_unsigned_all_bit_i_A(adc_sync_all_bit_unsigned_A), 
    .adc_unsigned_all_bit_i_B(adc_sync_all_bit_unsigned_B), 
    .adc_unsigned_all_bit_i_C(adc_sync_all_bit_unsigned_C), 
    .adc_unsigned_all_bit_i_D(adc_sync_all_bit_unsigned_D), 
    `ifdef RSR
		.clk(main_clk_div2), 
	`elsif PSR
		.clk(main_clk), 
	`endif 
    .adc_signed_all_bit_o_A(adc_signed_all_bit_o_A), 
    .adc_signed_all_bit_o_B(adc_signed_all_bit_o_B), 
    .adc_signed_all_bit_o_C(adc_signed_all_bit_o_C), 
    .adc_signed_all_bit_o_D(adc_signed_all_bit_o_D)
    );

	//***** ADC数据快拍模块 *****//
	adc_snap_buffer #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)
	)
	U_adc_snap_buffer (
	`ifdef RSR
		.wr_clk(main_clk_div2), 
	`elsif PSR
		.wr_clk(main_clk), 
	`endif 
	.rd_clk(main_clk),
	.srst(adc_snap_rst), 
	.adc_sync_all_bit_i_A(adc_signed_all_bit_o_A), 
	.adc_sync_all_bit_i_B(adc_signed_all_bit_o_B), 
	.adc_sync_all_bit_i_C(adc_signed_all_bit_o_C), 
	.adc_sync_all_bit_i_D(adc_signed_all_bit_o_D), 
	.snap_capture_start(snap_capture_start), 
	.adc_snap_addr(adc_snap_addr), 
	.adc_snap_data(adc_snap_data), 
	.snap_capture_ready(snap_capture_ready)
	);
	
endmodule
