`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:12 11/06/2018 
// Design Name: 
// Module Name:    adc_data_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	1、完整的ADC接口，包括了IODELAY、跨时钟域和数据有符号数转换
// 					2、按ADC开启1:2DMUX模式设计
//					3、H和L路的每一位都接相同的delay值，输出的CNTVALUEOUT是每一位CNTVALUEOUT相与的结果
//					4、针对不同ADC工作模式，调节了数据的整数时钟延时来确保对齐
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "../include/application_define.v"
 module adc_data_interface #(
	parameter REFCLK_FREQ = 200.0,
	parameter ADC_DATA_WIDTH = 8,
	`include "../include/idelay_value.v"
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	( 
		adc_clk_A_p,
		adc_clk_A_n,
		adc_in_AH_p,
		adc_in_AH_n,
		adc_in_AL_p,
		adc_in_AL_n,
		adc_clk_B_p,
		adc_clk_B_n,
		adc_in_BH_p,
		adc_in_BH_n,
		adc_in_BL_p,
		adc_in_BL_n,
		adc_clk_C_p,
		adc_clk_C_n,
		adc_in_CH_p,
		adc_in_CH_n,
		adc_in_CL_p,
		adc_in_CL_n,
		adc_clk_D_p,
		adc_clk_D_n,
		adc_in_DH_p,
		adc_in_DH_n,
		adc_in_DL_p,
		adc_in_DL_n,
		refclk,
		rst_iserdes_async,	//内部完成同步处理
		rst_iodelay_dat_async,
		rst_iodelay_clk_async,
		rst_idelayctrl_asyn,		
		rst_bufr_asyn,
		arst_data_sync,
		clk,			//FPGA内部主时钟，频率与BUFR分频后一致		
		idelayctrl_rdy,		
		adc_sync_all_bit_o_AH,
		adc_sync_all_bit_o_AL,
		adc_sync_all_bit_o_BH,
		adc_sync_all_bit_o_BL,
		adc_sync_all_bit_o_CH,
		adc_sync_all_bit_o_CL,
		adc_sync_all_bit_o_DH,
		adc_sync_all_bit_o_DL
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

	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                                    adc_clk_A_p;
	input                                                    adc_clk_A_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_AH_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_AH_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_AL_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_AL_n;
	input                                                    adc_clk_B_p;
	input                                                    adc_clk_B_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_BH_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_BH_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_BL_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_BL_n;
	input                                                    adc_clk_C_p;
	input                                                    adc_clk_C_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_CH_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_CH_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_CL_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_CL_n;
	input                                                    adc_clk_D_p;
	input                                                    adc_clk_D_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_DH_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_DH_n;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_DL_p;
	input     [ADC_DATA_WIDTH-1:0]                           adc_in_DL_n;
	input                                                    refclk;
	input                                                    rst_iserdes_async;	//内部完成同步处理
	input                                                    rst_iodelay_dat_async;
	input                                                    rst_iodelay_clk_async;
	
	
	input                                                    rst_idelayctrl_asyn;		
	input                                                    rst_bufr_asyn;
	input                                                    clk;			//FPGA内部主时钟，频率与BUFR分频后一致
	input                                                    arst_data_sync;
	//*************************************//
	//************ outputs ****************//
	//*************************************//
    
	output                                                   idelayctrl_rdy;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_AH;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_AL;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_BH;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_BL;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_CH;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_CL;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_DH;
	output    [ADC_DATA_WIDTH*PARALLEL_PATH_NUM-1:0]         adc_sync_all_bit_o_DL;



	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                               adc_clk_buf_A;
	wire                                               rst_clk_iodelay_sync_A;
	wire                                               rst_iserdes_iodelay_sync_A;
	wire                                               adc_clk_bufio_A;
	wire                                               adc_clk_bufr_A;		
	wire                                               idelayctrl_rdy_A;
	wire                                               adc_clk_buf_B;
	wire                                               rst_iserdes_iodelay_sync_B;
	wire                                               adc_clk_bufio_B;
	wire                                               adc_clk_bufr_B;		
	wire                                               idelayctrl_rdy_B;	
	wire                                               adc_clk_buf_C;
	wire                                               rst_iserdes_iodelay_sync_C;
	wire                                               adc_clk_bufio_C;
	wire                                               adc_clk_bufr_C;		
	wire                                               idelayctrl_rdy_C;
	wire                                               adc_clk_buf_D;
	wire                                               rst_iserdes_iodelay_sync_D;
	wire                                               adc_clk_bufio_D;
	wire                                               adc_clk_bufr_D;		
	wire                                               idelayctrl_rdy_D;
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	assign idelayctrl_rdy = idelayctrl_rdy_A & idelayctrl_rdy_B & idelayctrl_rdy_C & idelayctrl_rdy_D;
		
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** A路 *****//
	adc_data_interface_one_core #(
		.CNTVALUEIN_H(Channel_A_Idelay_Value_H),
		.CNTVALUEIN_L(Channel_A_Idelay_Value_L),
		.CLK_DELAY(Clk_Delay_A)
	)
	u_adc_data_interface_one_core_A (
	.adc_clk_p(adc_clk_A_p), 
	.adc_clk_n(adc_clk_A_n), 
	.adc_in_H_p(adc_in_AH_p), 
	.adc_in_H_n(adc_in_AH_n), 
	.adc_in_L_p(adc_in_AL_p), 
	.adc_in_L_n(adc_in_AL_n), 
	.refclk(refclk), 
	.rst_iserdes_async(rst_iserdes_async),	//内部完成同步处理
	.rst_iodelay_dat_async(rst_iodelay_dat_async),	//内部完成同步处理
	.rst_iodelay_clk_async(rst_iodelay_clk_async),	//内部完成同步处理
	.rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
	.rst_bufr_asyn(rst_bufr_asyn), 
	.arst_data_sync(arst_data_sync),
	.clk(clk), 
	.idelayctrl_rdy(idelayctrl_rdy_A), 
	.adc_sync_all_bit_o_H(adc_sync_all_bit_o_AH), 
	.adc_sync_all_bit_o_L(adc_sync_all_bit_o_AL)
	);
	
	//***** B路 *****//
	adc_data_interface_one_core #(
		.CNTVALUEIN_H(Channel_B_Idelay_Value_H),
		.CNTVALUEIN_L(Channel_B_Idelay_Value_L),
		.CLK_DELAY(Clk_Delay_B)
	)
	u_adc_data_interface_one_core_B (
	.adc_clk_p(adc_clk_B_p), 
	.adc_clk_n(adc_clk_B_n), 
	.adc_in_H_p(adc_in_BH_p), 
	.adc_in_H_n(adc_in_BH_n), 
	.adc_in_L_p(adc_in_BL_p), 
	.adc_in_L_n(adc_in_BL_n),  
	.refclk(refclk),
	.rst_iserdes_async(rst_iserdes_async),	//内部完成同步处理
	.rst_iodelay_dat_async(rst_iodelay_dat_async),	//内部完成同步处理
	.rst_iodelay_clk_async(rst_iodelay_clk_async),	//内部完成同步处理
	.rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
	.rst_bufr_asyn(rst_bufr_asyn), 
	.arst_data_sync(arst_data_sync),
	.clk(clk), 
	.idelayctrl_rdy(idelayctrl_rdy_B), 
	.adc_sync_all_bit_o_H(adc_sync_all_bit_o_BH), 
	.adc_sync_all_bit_o_L(adc_sync_all_bit_o_BL)
	);
	
	//***** C路 *****//
	adc_data_interface_one_core #(
		.CNTVALUEIN_H(Channel_C_Idelay_Value_H),
		.CNTVALUEIN_L(Channel_C_Idelay_Value_L),
		.CLK_DELAY(Clk_Delay_C)
	)
	u_adc_data_interface_one_core_C (
   .adc_clk_p(adc_clk_C_p), 
   .adc_clk_n(adc_clk_C_n), 
   .adc_in_H_p(adc_in_CH_p), 
   .adc_in_H_n(adc_in_CH_n), 
   .adc_in_L_p(adc_in_CL_p), 
   .adc_in_L_n(adc_in_CL_n), 
   .refclk(refclk),
	.rst_iserdes_async(rst_iserdes_async),	//内部完成同步处理
	.rst_iodelay_dat_async(rst_iodelay_dat_async),	//内部完成同步处理
	.rst_iodelay_clk_async(rst_iodelay_clk_async),	//内部完成同步处理
   .rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
   .rst_bufr_asyn(rst_bufr_asyn), 
	.arst_data_sync(arst_data_sync),
   .clk(clk), 
   .idelayctrl_rdy(idelayctrl_rdy_C), 
   .adc_sync_all_bit_o_H(adc_sync_all_bit_o_CH), 
   .adc_sync_all_bit_o_L(adc_sync_all_bit_o_CL)
   );
	
	//***** D路 *****//
	adc_data_interface_one_core #(
		.CNTVALUEIN_H(Channel_D_Idelay_Value_H),
		.CNTVALUEIN_L(Channel_D_Idelay_Value_L),
		.CLK_DELAY(Clk_Delay_D)
	)
	u_adc_data_interface_one_core_D (
   .adc_clk_p(adc_clk_D_p), 
   .adc_clk_n(adc_clk_D_n), 
   .adc_in_H_p(adc_in_DH_p), 
   .adc_in_H_n(adc_in_DH_n),     
	.adc_in_L_p(adc_in_DL_p), 
   .adc_in_L_n(adc_in_DL_n), 
   .refclk(refclk),
	.rst_iserdes_async(rst_iserdes_async),	//内部完成同步处理
	.rst_iodelay_dat_async(rst_iodelay_dat_async),	//内部完成同步处理
	.rst_iodelay_clk_async(rst_iodelay_clk_async),	//内部完成同步处理
   .rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
   .rst_bufr_asyn(rst_bufr_asyn), 
	.arst_data_sync(arst_data_sync),
   .clk(clk), 
   .idelayctrl_rdy(idelayctrl_rdy_D), 
   .adc_sync_all_bit_o_H(adc_sync_all_bit_o_DH), 
   .adc_sync_all_bit_o_L(adc_sync_all_bit_o_DL)
   );
endmodule
