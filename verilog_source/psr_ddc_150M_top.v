`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:47 11/11/2018 
// Design Name: 
// Module Name:    psr_ddc_150M_top 
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
`include "include/application_define.v"
module psr_ddc_150M_top(
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
		clk_p,
		clk_n,
		pps_in,
		BUS_CLK,
		BUS_CSN,
		BUS_OEN,
		BUS_WEN,
		BUS_IRQ,
		BUS_ADDR,
		BUS_DATA,
		LAD_OUT,
		
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
		
		ADC_RSTN,
		ADC_SCLK,
		ADC_CSN,
		ADC_MOSI,
		ADC_MISO,		
		ADC_SYNC_P,
		ADC_SYNC_N,
		ADF_LD,
		ADF_CLK,
		ADF_DATA,
		ADF_LE,
		rgmii_rxd,
		rgmii_rx_ctl,
		rgmii_rxc,  
		phy_resetn,
		rgmii_txd,
		rgmii_tx_ctl,
		rgmii_txc,    
		tx_statistics_s,
		rx_statistics_s,
		serial_response,
		frame_error,
		frame_errorn,
		RST_SW,
		led0,
		led1,
		clk_in
		
    ); 
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	localparam     ADC_DATA_WIDTH = 8;
	localparam     CNTVALUE_WIDTH = 5;
	localparam ARM_BUS_DATA_WIDTH = 16;
	localparam ARM_BUS_ADDR_WIDTH = 20;
	
	localparam   RGMII_DATA_WIDTH = 4;
	
	parameter BITWIDTH = 7;				//2^BITWIDTH = SUB_FFT_POINT
	parameter FFT_POINT =512;			//FFT_POINT = SUB_FFT_POINT*4
	parameter SUB_FFT_POINT = 512;
	`ifdef RSR
		localparam PARALLEL_PATH_NUM = 4;
	`elsif PSR
		localparam PARALLEL_PATH_NUM = 2;
	`endif	
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                              clk_p;	//ⲿʱ룬RSR288MHz
	input                                              clk_n;
	input                                              pps_in;	//PPSλ룬з½	
	input                                              ADC_MISO;	//ADCоƬӿ	
	input                                              ADF_LD;	//ADFʱоƬӿ
	input                                              BUS_CLK;		//ARMߵʱ
	input                                              BUS_CSN;		//ARMߵƬѡ
	input                                              BUS_OEN;		//ARMߵĶʹ
	input                                              BUS_WEN;		//ARMߵдʹ
	input                                              BUS_IRQ;		//ARMߵ

	input     [ARM_BUS_ADDR_WIDTH-1:0]                 BUS_ADDR;	//ARMߵĵַź
	//***** ADC ͨA *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_AL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_AH_D_N;	
	//***** ADC ͨB *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_BL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_BH_D_N;	
	//***** ADC ͨC *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_CL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_CH_D_N;	
	//***** ADC ͨD *****//
	input     [ADC_DATA_WIDTH-1:0]                     AD_DL_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DL_D_N;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DH_D_P;	
	input     [ADC_DATA_WIDTH-1:0]                     AD_DH_D_N;	
	//***** ADCʱ ͨA *****//
	input                                              AD_A_CLK_P;
	input                                              AD_A_CLK_N;
	//***** ADCʱ ͨB *****//
	input                                              AD_B_CLK_P;
	input                                              AD_B_CLK_N;
	//***** ADCʱ ͨC *****//
	input                                              AD_C_CLK_P;
	input                                              AD_C_CLK_N;
	//***** ADCʱ ͨD *****//
	input                                              AD_D_CLK_P;
	input                                              AD_D_CLK_N;

	input                                              RST_SW;
	//***** RGMII MAC Interface *****//
	input                                              clk_in;
	input     [RGMII_DATA_WIDTH-1:0]                   rgmii_rxd;
	input                                              rgmii_rx_ctl;
	input                                              rgmii_rxc;   
	
  	//*************************************//
	//************ outputs ****************//
	//*************************************//
	output                                             ADC_RSTN;	//ADC RSTN
	output                                             ADC_SCLK;	//ADC SCLK
	output                                             ADC_CSN;		//ADC CSN
	output                                             ADC_MOSI;	//ADC MOSI
	output                                             ADC_SYNC_P;	//ADC SYNCADCͬĹؼź
	output                                             ADC_SYNC_N;	
	output                                             ADF_CLK;		//ADF CLK	
	output                                             ADF_DATA;	//ADF DATA	
	output                                             ADF_LE;		//ADF LE	
	//***** RGMII MAC Interface *****//
	output                                             phy_resetn;
	output    [RGMII_DATA_WIDTH-1:0]                   rgmii_txd;
	output                                             rgmii_tx_ctl;
	output                                             rgmii_txc;    
	output                                             tx_statistics_s;
	output                                             rx_statistics_s;
	output                                             serial_response;
	output                                             frame_error;
	output                                             frame_errorn;

	output                                              led0;
	output                                              led1;
	
	output	 [ARM_BUS_DATA_WIDTH-1:0]						LAD_OUT;
	//*************************************//
	//************ inouts *****************//
	//*************************************//
	inout     [ARM_BUS_DATA_WIDTH-1:0]                 BUS_DATA; 	//ARMߵź
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire [ARM_BUS_DATA_WIDTH-1:0]RST_REG;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//

//U0-------------------------ADC&CLK----------------------------------------
wire [15:0]ADC_REG;
wire [15:0]ADC_RD_BACK;
ADC_REG_MODULE U0_ADC_REG (
    .ADC_REG(ADC_REG), 
    .ADC_MISO_IN(ADC_MISO), 
    .ADC_RD_BACK(ADC_RD_BACK), 
    .ADC_SCLK_OUT(ADC_SCLK), 
    .ADC_MOSI_OUT(ADC_MOSI), 
    .ADC_CSN_OUT(ADC_CSN), 
    .ADC_RSTN_OUT(ADC_RSTN), 
    .ADC_SYNC_P(ADC_SYNC_P), 
    .ADC_SYNC_N(ADC_SYNC_N)
    );
wire [15:0]CLK_REG;	
wire [15:0]CLK_RD_BACK; 
CLK_REG_MODULE U0_CLK_REG (
    .CLK_REG(CLK_REG), 
    .ADF_LD_IN(ADF_LD), 
    .CLK_RD_BACK(CLK_RD_BACK), 
    .ADF_CLK_OUT(ADF_CLK), 
    .ADF_DATA_OUT(ADF_DATA), 
    .ADF_LE_OUT(ADF_LE)
    );

//U0-----------------------ʱ&λ߼--------------------------------------
wire clk;
wire pps_out;	
wire clk_30M;
wire clk_150M;
wire PPS_RST_IN;
wire arst;
assign arst = RST_REG[0];
CLK_RESET_INTERFACE U0_CLK_RESET_INTERFACE (
    .CLK_IN_P(clk_p), 
    .CLK_IN_N(clk_n), 
	 
    .PPS_IN(pps_in), 
    .RST_SW(RST_SW), 
	 .ARST(arst),
	 .PPS_RST_IN(PPS_RST_IN),
    .CLK_OUT(clk_300M), 
    .CLK_30M(clk_30M), 
	 .CLK_150M(clk_150M),
    .RST_OUT(pps_out)
    );
	//***** BUSʱ *****//
	wire clk_66M;
	assign clk_66M = BUS_CLK;
//U1-ADCݽӿתģ
//data_out_L1-L8data_out_R1-R8ǰʱȺ˳ȷ

	wire ms_out;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_if_reset;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_if_state;
	//A Channel
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 Delay_ValueA;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayA;
	//B Channel                                   
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 Delay_ValueB;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayB;
	//C Channel                                   
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 Delay_ValueC;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayC;
	//D Channel                                   
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 Delay_ValueD;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayD;
	//CLK                                              
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKAB;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayCLKAB;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKCD;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 realdelayCLKCD;
	
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_operate;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_state;

	`ifdef FOUR_CHANNEL_1200M	//RSR,coreָһ·
	// RSRݾAD_SYN_AAD_SYN_BAD_SYN_CAD_SYN_D			
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                     ADC_DATA_A;	//֯˳ӵ͵ߵADCͬ
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                     ADC_DATA_B;	//֯˳ӵ͵ߵADCͬ
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                     ADC_DATA_C;	//֯˳ӵ͵ߵADCͬ
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]                     ADC_DATA_D;	//֯˳ӵ͵ߵADCͬ	
	`elsif TWO_CHANNEL_2400M 	//PSR,2.4GHz,˫coreָһ·
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE*2-1:0]                   ADC_DATA_L;	//֯˳ӵ͵ߵADCͬ
		(*KEEP = "TRUE"*) wire      [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE*2-1:0]                   ADC_DATA_R;	//֯˳ӵ͵ߵADCͬ
	`endif
	
	wire                                               rst_iserdes_async;	//iserdes첽λź
	wire                                               rst_iodelay_clk_async;	//clk_iodelay첽λź
	wire                                               rst_iodelay_dat_async;	//data_iodelay첽λź
	wire                                               rst_idelayctrl_asyn;	//iodelayctrl첽λź
	wire                                               rst_bufr_asyn;	//bufr첽λź
	wire                                               rst_data_fifo_asyn; //data_syncfifo첽λź
	wire                                               idelayctrl_rdy;	//idelayctrl readyź
	
	//***** adc max&min *****//
	`ifdef FOUR_CHANNEL_1200M	//RSR,coreָһ·
	// RSRݾAD_SYN_AAD_SYN_BAD_SYN_CAD_SYN_D			
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_A;
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_B;
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_C;
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_D;
	`elsif TWO_CHANNEL_2400M 	//PSR,2.4GHz,˫coreָһ·
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_L;
		(*KEEP = "TRUE"*)wire      [ADC_DATA_WIDTH*2-1:0]                     adc_max_min_R;
	`endif
	
	//***** adc_snap_buffer *****//
	wire                                               snap_capture_start;
	wire                                               adc_snap_rst;
	wire                                               snap_capture_ready;
	wire      [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_addr;
	wire      [ADC_DATA_WIDTH-1:0]                     adc_snap_data;
	//***** pps_out ʱ *****//
	wire                                               pps_out_pps_delay_1;
	wire                                               pps_out_pps_delay_2;
	wire                                               pps_out_pps_delay_3;
	wire                                               pps_out_pps_delay_4;
	wire                                               pps_out_pps_delay_5;
	wire                                               pps_out_pps_delay_6;
	wire                                               pps_out_pps_delay_7;
	wire                                               pps_out_pps_delay_8;
	wire                                               pps_out_pps_delay_9;
	wire                                               pps_out_pps_delay_10;
	wire                                               pps_out_pps_delay_11;
//***** ͨADCʱӺݽӿ *****//	
	//***** BTC *****//
	assign         adc_snap_rst = adc_snap_operate[0];
	assign   snap_capture_start = adc_snap_operate[1];
	assign       adc_snap_state = {15'b0 , snap_capture_ready};
	
	//***** reset *****//
	//assign GPS_ARST = reset[0];		//GPSλPPS_RSTģ飩
	//assign MS_ARST = reset[1];		//ָλ
	//assign SELF_ARST = reset[2];	//Լģ鸴λ
	assign rst_iserdes_iodelay_async = adc_if_reset[3]; 	//תλ
	//assign DDC_ARST = reset[4];		//DDCλ
	//assign RAM_ARST = reset[5];		//RAMλ
	assign             rst_bufr_asyn = adc_if_reset[8];//2015-8-4 BY ZTY CLKBuffĸλʱramδʹã˷Щ
	assign        rst_data_fifo_asyn = adc_if_reset[9];		//2017-6-2 ZTY ڸʱFIFO첽λ
	assign       rst_idelayctrl_asyn = adc_if_reset[10];	//2017-6-2 ZTY idelayctrl첽λ
	assign         rst_iserdes_async = adc_if_reset[11]; 		//תλ
	assign     rst_iodelay_clk_async = adc_if_reset[12]; 	//clk_iodelayλ
	assign     rst_iodelay_dat_async = adc_if_reset[13]; 	//dat_iodelayλ
	assign 	  					rst_sync	= adc_if_reset[14];  //actually, this is also a async rst, and let's test it
	//***** reset *****//
	assign  adc_if_state[6:0]  = 7'b0;
	assign adc_if_state[15:12] = 3'b0;
	assign     adc_if_state[7] = 1;
	assign     adc_if_state[8] = 1;
	assign     adc_if_state[9] = 1;
	assign    adc_if_state[10] = 1;
	assign    adc_if_state[11] = 1;	
	//***** ͨADCʱӺݽӿ *****//	
	adc_if_check_snap #(
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH),
	.CNTVALUE_WIDTH(CNTVALUE_WIDTH),
	.ARM_BUS_DATA_WIDTH(ARM_BUS_DATA_WIDTH)
	)
	U1_adc_if_check_snap (
    .bus_clk(clk_66M), 
    .main_clk(clk_300M), 
    .main_clk_div2(clk_150M), 
    .AD_AL_D_P(AD_AL_D_P), 
    .AD_AL_D_N(AD_AL_D_N), 
    .AD_AH_D_P(AD_AH_D_P), 
    .AD_AH_D_N(AD_AH_D_N), 
    .AD_BL_D_P(AD_BL_D_P), 
    .AD_BL_D_N(AD_BL_D_N), 
    .AD_BH_D_P(AD_BH_D_P), 
    .AD_BH_D_N(AD_BH_D_N), 
    .AD_CL_D_P(AD_CL_D_P), 
    .AD_CL_D_N(AD_CL_D_N), 
    .AD_CH_D_P(AD_CH_D_P), 
    .AD_CH_D_N(AD_CH_D_N), 
    .AD_DL_D_P(AD_DL_D_P), 
    .AD_DL_D_N(AD_DL_D_N), 
    .AD_DH_D_P(AD_DH_D_P), 
    .AD_DH_D_N(AD_DH_D_N), 
    .AD_A_CLK_P(AD_A_CLK_P), 
    .AD_A_CLK_N(AD_A_CLK_N), 
    .AD_B_CLK_P(AD_B_CLK_P), 
    .AD_B_CLK_N(AD_B_CLK_N), 
    .AD_C_CLK_P(AD_C_CLK_P), 
    .AD_C_CLK_N(AD_C_CLK_N), 
    .AD_D_CLK_P(AD_D_CLK_P), 
    .AD_D_CLK_N(AD_D_CLK_N),  
    .idelayctrl_rdy(idelayctrl_rdy), 
    .rst_iserdes_async(rst_iserdes_async), 
    .rst_iodelay_clk_async(rst_iodelay_clk_async), 
    .rst_iodelay_dat_async(rst_iodelay_dat_async), 
    .rst_idelayctrl_asyn(rst_idelayctrl_asyn), 
    .rst_bufr_asyn(rst_bufr_asyn), 
    .rst_data_fifo_asyn(rst_data_fifo_asyn), 
    .rst_sync(rst_sync), 
    .snap_capture_start(snap_capture_start), 
    .adc_snap_rst(adc_snap_rst), 
    .adc_snap_addr(adc_snap_addr), 
	`ifdef FOUR_CHANNEL_1200M	//RSR,coreָһ·
	// RSRݾAD_SYN_AAD_SYN_BAD_SYN_CAD_SYN_D	
		.ADC_DATA_A(ADC_DATA_A),	//֯˳ӵ͵ߵADCͬ
		.ADC_DATA_B(ADC_DATA_B),	//֯˳ӵ͵ߵADCͬ		
		.ADC_DATA_C(ADC_DATA_C),	//֯˳ӵ͵ߵADCͬ
		.ADC_DATA_D(ADC_DATA_D),	//֯˳ӵ͵ߵADCͬ
		.adc_max_min_A(adc_max_min_A),
		.adc_max_min_B(adc_max_min_B),
		.adc_max_min_C(adc_max_min_C),
		.adc_max_min_D(adc_max_min_D),
	`elsif TWO_CHANNEL_2400M 	//PSR,2.4GHz,˫coreָһ·
		.ADC_DATA_L(ADC_DATA_L),	//֯˳ӵ͵ߵADCͬ
		.ADC_DATA_R(ADC_DATA_R),	//֯˳ӵ͵ߵADCͬ
		.adc_max_min_L(adc_max_min_L),
		.adc_max_min_R(adc_max_min_R),
	`endif
    .snap_capture_ready(snap_capture_ready), 
    .adc_snap_data(adc_snap_data)
    );
	
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_L[0:PARALLEL_PATH_NUM_PER_CORE*2-1];	//˳ֽӺADCͬ
	wire      [ADC_DATA_WIDTH-1:0]                     AD_SYN_R[0:PARALLEL_PATH_NUM_PER_CORE*2-1];	//˳ֽӺADCͬ
	wire      [ADC_DATA_WIDTH*2-1:0]                   adc_l;	//max&min
	wire      [ADC_DATA_WIDTH*2-1:0]                   adc_r;
	genvar m;
	generate
	for (m=0;m < PARALLEL_PATH_NUM_PER_CORE*2; m=m+1) 
	begin: assign_AD_SYN		
		assign     AD_SYN_L[m] = ADC_DATA_L[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
		assign     AD_SYN_R[m] = ADC_DATA_R[((m+1)*ADC_DATA_WIDTH-1):m*ADC_DATA_WIDTH];
	end
	endgenerate
	
//U1-±Ƶģ
localparam DDC_OUTPUT_WIDTH = 34;
wire [DDC_OUTPUT_WIDTH-1:0]   data_150M_L_i;
wire [DDC_OUTPUT_WIDTH-1:0]   data_150M_L_q;
wire [DDC_OUTPUT_WIDTH-1:0]   data_150M_R_i;
wire [DDC_OUTPUT_WIDTH-1:0]   data_150M_R_q;
wire                          data_valid_L;
wire                          data_valid_R;
wire [15:0]FREQ_STEP;
wire      rst_ddc;
DDC_2400to150 U2_2400to150_L(
		.clk_300M(clk_300M),
		.arst(rst_ddc),	//첽λ
		.din1(AD_SYN_L[0]),	//300MSps
		.din2(AD_SYN_L[1]),
		.din3(AD_SYN_L[2]),
		.din4(AD_SYN_L[3]),
		.din5(AD_SYN_L[4]),
		.din6(AD_SYN_L[5]),
		.din7(AD_SYN_L[6]),
		.din8(AD_SYN_L[7]),
		.step(FREQ_STEP[11:0]),
		
		.data_150M_i(data_150M_L_i),
		.data_150M_q(data_150M_L_q),
		.data_valid(data_valid_L)
	);
	
DDC_2400to150 U2_2400to150_R(
		.clk_300M(clk_300M),
		.arst(rst_ddc),	//첽λ
		.din1(AD_SYN_R[0]),	//300MSps
		.din2(AD_SYN_R[1]),
		.din3(AD_SYN_R[2]),
		.din4(AD_SYN_R[3]),
		.din5(AD_SYN_R[4]),
		.din6(AD_SYN_R[5]),
		.din7(AD_SYN_R[6]),
		.din8(AD_SYN_R[7]),
		.step(FREQ_STEP[11:0]),
		
		.data_150M_i(data_150M_R_i),
		.data_150M_q(data_150M_R_q),
		.data_valid(data_valid_R)
	);
//DDCλģ
localparam FIFO_WIDTH = 23;
localparam DDC_ADJ_WIDTH = 12;
//***** DDCλģ L· *****//
wire    [FIFO_WIDTH-1:0]        data_150M_L_i_round;
wire    [FIFO_WIDTH-1:0]        data_150M_L_q_round;
wire                               ddc_adj_rdy_L;
wire [DDC_ADJ_WIDTH-1:0]           ddc_adj_L;
wire [ARM_BUS_DATA_WIDTH-1:0]           ddc_adj_L_BTC;
wire    [47:0]                        max_ddc_L_btc;
wire    [DDC_OUTPUT_WIDTH-1:0]        max_ddc_L;

assign ddc_adj_L = ddc_adj_L_BTC[DDC_ADJ_WIDTH-1:0];
assign max_ddc_L_btc = {{(48-DDC_OUTPUT_WIDTH){1'b0}},max_ddc_L};

	DDC_Digital_gain #(
	.INPUT_WIDTH(DDC_OUTPUT_WIDTH),
	.OUTPUT_WIDTH(FIFO_WIDTH),
	.ADJ_WIDTH(DDC_ADJ_WIDTH)
	)
	U_DDC_Digital_gain_L (
	.clk(clk_300M), 
	.rst(rst_sync), 
	.adjust(ddc_adj_L), 
	.nd(data_valid_L), 
	.data_150M_i(data_150M_L_i), 
	.data_150M_q(data_150M_L_q), 
	.rdy(ddc_adj_rdy_L), 
	.data_150M_i_round(data_150M_L_i_round), 
	.data_150M_q_round(data_150M_L_q_round), 
	.max(max_ddc_L)
	);
//***** DDCλģ L· *****//
wire [FIFO_WIDTH-1:0] data_150M_R_i_round;
wire [FIFO_WIDTH-1:0] data_150M_R_q_round;
wire                  ddc_adj_rdy_R;
wire [DDC_ADJ_WIDTH-1:0]           ddc_adj_R;
wire [ARM_BUS_DATA_WIDTH-1:0]           ddc_adj_R_BTC;
wire    [47:0]                        max_ddc_R_btc;
wire    [DDC_OUTPUT_WIDTH-1:0]        max_ddc_R;

assign ddc_adj_R = ddc_adj_R_BTC[DDC_ADJ_WIDTH-1:0];
assign max_ddc_R_btc = {{(48-DDC_OUTPUT_WIDTH){1'b0}},max_ddc_R};

	DDC_Digital_gain #(
	.INPUT_WIDTH(DDC_OUTPUT_WIDTH),
	.OUTPUT_WIDTH(FIFO_WIDTH),
	.ADJ_WIDTH(DDC_ADJ_WIDTH)
	)
	U_DDC_Digital_gain_R (
	.clk(clk_300M), 
	.rst(rst_sync), 
	.adjust(ddc_adj_R), 
	.nd(data_valid_R), 
	.data_150M_i(data_150M_R_i), 
	.data_150M_q(data_150M_R_q), 
	.rdy(ddc_adj_rdy_R), 
	.data_150M_i_round(data_150M_R_i_round), 
	.data_150M_q_round(data_150M_R_q_round), 
	.max(max_ddc_R)
	);
	
//fifo300MbpsΪ150MbpsΪ150MHz
wire [FIFO_WIDTH-1:0] data_L_i;
wire [FIFO_WIDTH-1:0] data_L_q;
wire [FIFO_WIDTH-1:0] data_R_i;
wire [FIFO_WIDTH-1:0] data_R_q;
DDC_DATA_FIFO #(
	.DATA_WIDTH(FIFO_WIDTH)
	)U2_ddc_data_fifo (
    .rst(pps_out_pps_delay_11),
    .wr_clk(clk_300M),
    .din_L_i(data_150M_L_i_round), 
    .din_L_q(data_150M_L_q_round), 
    .en_wr_L(ddc_adj_rdy_L), 
    .din_R_i(data_150M_R_i_round), 
    .din_R_q(data_150M_R_q_round), 
    .en_wr_R(ddc_adj_rdy_R), 
    .rd_clk(clk_150M), 
    .dout_L_i(data_L_i), 
    .dout_L_q(data_L_q),
    .dout_R_i(data_R_i), 
    .dout_R_q(data_R_q)
    );
	
//U2-FFTģ
localparam FFT_WIDTH = 23;
(* KEEP = "TRUE" *)wire [FFT_WIDTH-1:0] re0_out_fftl;
(* KEEP = "TRUE" *)wire [FFT_WIDTH-1:0] im0_out_fftl;
(* KEEP = "TRUE" *)wire [FFT_WIDTH-1:0] re0_out_fftr;
(* KEEP = "TRUE" *)wire [FFT_WIDTH-1:0] im0_out_fftr;
wire en_sync_fft;
//wire [(BITWIDTH-1):0]cnt_sync_fft;
wire [(BITWIDTH+1):0]cnt_sync_fft;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_11 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_10), 
.q(pps_out_pps_delay_11)
);
FFT_150M #(
	.DATA_WIDTH(FIFO_WIDTH),
	.FFT_WIDTH(FFT_WIDTH)
)U2_fft_150M (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_11), 
    .data_L_i(data_L_i), 
    .data_L_q(data_L_q), 
    .data_R_i(data_R_i), 
    .data_R_q(data_R_q), 
    .re0_out_fftl(re0_out_fftl), 
    .im0_out_fftl(im0_out_fftl), 
    .re0_out_fftr(re0_out_fftr), 
    .im0_out_fftr(im0_out_fftr),
	 .en_sync_fft(en_sync_fft),
	 .cnt_sync_fft(cnt_sync_fft)
    );
//U2-FREQEQUAƵʾģ	
wire [FFT_WIDTH-1:0] re0_out_l;
wire [FFT_WIDTH-1:0] im0_out_l;
wire [FFT_WIDTH-1:0] re0_out_r;
wire [FFT_WIDTH-1:0] im0_out_r;
wire en_sync_equa;
//wire [(BITWIDTH-1):0]cnt_sync_equa;
wire [(BITWIDTH+1):0] cnt_sync_equa;
wire [15:0]FREQEQUA_RPARAL;
wire [15:0]FREQEQUA_RPARAR;
wire [15:0]FREQEQUA_RADDR;
wire [15:0]FREQEQUA_EN;
wire [15:0]FREQEQUA_WADDR;
wire [15:0]FREQEQUA_WPARA;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_10 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_9), 
.q(pps_out_pps_delay_10)
);
Freq_Equalization #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U2_FREQEQUA_L (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_10), 
    .w_en0(FREQEQUA_EN[0]),  
	 .para_waddr(FREQEQUA_WADDR[(BITWIDTH+1):0]), 
    .para_in(FREQEQUA_WPARA), 
    .r_en0(FREQEQUA_EN[4]), 
	 .para_raddr(FREQEQUA_RADDR[(BITWIDTH+1):0]), 
    .para_out(FREQEQUA_RPARAL), 
    .en_sync_in(en_sync_fft), 
    .cnt_sync_in(cnt_sync_fft), 
    .re_in0(re0_out_fftl), 
    .im_in0(im0_out_fftl), 
    .en_sync_out(en_sync_equa), 
    .cnt_sync_out(cnt_sync_equa), 
    .re_out0(re0_out_l), 
    .im_out0(im0_out_l)
    );
	
Freq_Equalization #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U2_FREQEQUA_R (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_10), 
    .w_en0(FREQEQUA_EN[8]), 
	 .para_waddr(FREQEQUA_WADDR[(BITWIDTH+1):0]), 
    .para_in(FREQEQUA_WPARA), 
    .r_en0(FREQEQUA_EN[12]),  
	 .para_raddr(FREQEQUA_RADDR[(BITWIDTH+1):0]), 
    .para_out(FREQEQUA_RPARAR), 
    .en_sync_in(en_sync_fft), 
    .cnt_sync_in(cnt_sync_fft), 
    .re_in0(re0_out_fftr), 
    .im_in0(im0_out_fftr), 
    .en_sync_out(), 
    .cnt_sync_out(), 
    .re_out0(re0_out_r),  
    .im_out0(im0_out_r)
    );

wire en_sync_out_IQUV;
//wire [(BITWIDTH-1):0]cnt_sync_IQUV;
wire [(BITWIDTH+1):0]cnt_sync_IQUV;
wire [47:0]out_RR0;
wire [47:0]out_LL0;
wire [47:0]out_Re_RL0;
wire [47:0]out_Im_RL0;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_9 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_8), 
.q(pps_out_pps_delay_9)
);
Cal_IQUV_V2 #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U3_Cal_IQUV_V2 (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_9), 
    .en_sync_in(en_sync_equa), 
    .cnt_sync_in(cnt_sync_equa), 
    .re0_L(re0_out_l), 
    .im0_L(im0_out_l),  
    .re0_R(re0_out_r), 
    .im0_R(im0_out_r), 
    .en_sync_out(en_sync_IQUV), 
    .cnt_sync_out(cnt_sync_IQUV), 
    .out_RR0(out_RR0), 
    .out_LL0(out_LL0), 
    .out_Re_RL0(out_Re_RL0), 
    .out_Im_RL0(out_Im_RL0) 
    );
//U4-IQUVһ	
wire en_sync_pre_digital_gain;
wire [(BITWIDTH+1):0]cnt_sync_pre_digital_gain; 
wire [47:0]   MAX_I_PRE;
wire [47:0]   MAX_Q_PRE;
wire [47:0]   MAX_U_PRE;
wire [47:0]   MAX_V_PRE;
wire [15:0]   SCALED_COEFF_PRE_I;
wire [15:0]   SCALED_COEFF_PRE_Q;
wire [15:0]   SCALED_COEFF_PRE_U;
wire [15:0]   SCALED_COEFF_PRE_V;
wire [15:0]   out_I_pre0;
wire [15:0]   out_Q_pre0;
wire [15:0]   out_U_pre0;
wire [15:0]   out_V_pre0;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_8 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_7), 
.q(pps_out_pps_delay_8)
);
Pre_Digital_Gain #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U4_Pre_Digital_Gain (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_8), 
    .ms_in(ms_out), 
    .scaled_coeff_I(SCALED_COEFF_PRE_I), 
	 .scaled_coeff_Q(SCALED_COEFF_PRE_Q), 
	 .scaled_coeff_U(SCALED_COEFF_PRE_U), 
	 .scaled_coeff_V(SCALED_COEFF_PRE_V), 
    .en_sync_in(en_sync_IQUV), 
    .cnt_sync_in(cnt_sync_IQUV), 
    .para_in_I0(out_RR0),  
    .para_in_Q0(out_LL0), 
    .para_in_U0(out_Re_RL0), 
    .para_in_V0(out_Im_RL0), 
    .en_sync_out(en_sync_pre_digital_gain), 
    .cnt_sync_out(cnt_sync_pre_digital_gain), 
    .para_out_I0(out_I_pre0),  
    .para_out_Q0(out_Q_pre0),  
    .para_out_U0(out_U_pre0), 
    .para_out_V0(out_V_pre0), 
    .max_I(MAX_I_PRE), 
    .max_Q(MAX_Q_PRE), 
    .max_U(MAX_U_PRE), 
    .max_V(MAX_V_PRE)
    );
//U5-ۼģ
wire en_sync_Acc_IQUV;
//wire [(BITWIDTH-1):0]cnt_sync_Acc_IQUV;	
wire [(BITWIDTH+1):0]cnt_sync_Acc_IQUV;
wire [31:0]out_I_Acc0;
wire [31:0]out_Q_Acc0;
wire [31:0]out_U_Acc0;
wire [31:0]out_V_Acc0;
wire [15:0]NUM_FRAME;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_7 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_6), 
.q(pps_out_pps_delay_7)
);
Acc_IQUV #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U5_Acc_IQUV (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_7), 
    .num_acc(NUM_FRAME), 
    .en_sync_in(en_sync_pre_digital_gain), 
    .cnt_sync_in(cnt_sync_pre_digital_gain), 
    .para_in_I0(out_I_pre0), 
    .para_in_Q0(out_Q_pre0), 
    .para_in_U0(out_U_pre0),  
    .para_in_V0(out_V_pre0), 
    .en_sync_out(en_sync_Acc_IQUV), 
    .cnt_sync_out(cnt_sync_Acc_IQUV), 
    .para_out_I0(out_I_Acc0), 
    .para_out_Q0(out_Q_Acc0),  
    .para_out_U0(out_U_Acc0),  
    .para_out_V0(out_V_Acc0) 
    );
 
//U6-ڶ
wire                         en_sync_aft_digital_gain;
//wire [(BITWIDTH-1):0]cnt_sync_aft_digital_gain;
wire [(BITWIDTH+1):0]        cnt_sync_aft_digital_gain;
wire [15:0]                  out_I_aft0;
wire [15:0]                  out_Q_aft0;
wire [15:0]                  out_U_aft0;
wire [15:0]                  out_V_aft0;
wire [31:0]                  MAX_I_AFT;
wire [31:0]                  MAX_Q_AFT;
wire [31:0]                  MAX_U_AFT;
wire [31:0]                  MAX_V_AFT;
wire [15:0]                  SCALED_COEFF_AFT_I;
wire [15:0]                  SCALED_COEFF_AFT_Q;
wire [15:0]                  SCALED_COEFF_AFT_U;
wire [15:0]                  SCALED_COEFF_AFT_V;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_6 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_5), 
.q(pps_out_pps_delay_6)
);
Aft_Digital_Gain #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U6_Aft_Digital_Gain (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_6), 
    .ms_in(ms_out), 
    .scaled_coeff_I(SCALED_COEFF_AFT_I), 
	 .scaled_coeff_Q(SCALED_COEFF_AFT_Q), 
	 .scaled_coeff_U(SCALED_COEFF_AFT_U), 
	 .scaled_coeff_V(SCALED_COEFF_AFT_V), 
    .en_sync_in(en_sync_Acc_IQUV), 
    .cnt_sync_in(cnt_sync_Acc_IQUV), 
    .para_in_I0(out_I_Acc0), 
    .para_in_Q0(out_Q_Acc0), 
    .para_in_U0(out_U_Acc0), 
    .para_in_V0(out_V_Acc0), 
    .en_sync_out(en_sync_aft_digital_gain), 
    .cnt_sync_out(cnt_sync_aft_digital_gain), 
    .para_out_I0(out_I_aft0), 
    .para_out_Q0(out_Q_aft0), 
    .para_out_U0(out_U_aft0), 
    .para_out_V0(out_V_aft0), 
    .max_I(MAX_I_AFT), 
    .max_Q(MAX_Q_AFT), 
    .max_U(MAX_U_AFT), 
    .max_V(MAX_V_AFT)
    );
//U7-4·ϳ1·
wire en_sync_data_combine;
wire [(BITWIDTH+1):0]   cnt_sync_data_combine;
wire [15:0]             out_I_comb;
wire [15:0]             out_Q_comb;
wire [15:0]             out_U_comb;
wire [15:0]             out_V_comb;

//assign out_I_comb = out_I_aft0;
//assign out_Q_comb = out_Q_aft0;
//assign out_U_comb = out_U_aft0;
//assign out_V_comb = out_V_aft0;
//assign en_sync_data_combine = en_sync_aft_digital_gain;
//assign cnt_sync_data_combine = cnt_sync_aft_digital_gain;

DELAY_MODULE #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U7_DELAY(
    .clk(clk_150M), 
    //.rst(pps_out), 
    .en_sync_in(en_sync_aft_digital_gain), 
    .cnt_sync_in(cnt_sync_aft_digital_gain), 
    .din0(out_I_aft0), 
    .din1(out_Q_aft0), 
    .din2(out_U_aft0), 
    .din3(out_V_aft0), 
    .en_sync_out(en_sync_data_combine), 
    .cnt_sync_out(cnt_sync_data_combine), 
    .dout0(out_I_comb), 
    .dout1(out_Q_comb), 
    .dout2(out_U_comb), 
    .dout3(out_V_comb)
    );
	 
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_5 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_4), 
.q(pps_out_pps_delay_5)
);
//һѡϵ	 
wire        en_sync_data_adj;
wire [(BITWIDTH+1):0] cnt_sync_data_adj;
wire [15:0]    para_adj_I;
wire [15:0]    para_adj_Q;
wire [15:0]    para_adj_U;
wire [15:0]    para_adj_V;
wire [15:0]    out_I;
wire [15:0]    out_Q;
wire [15:0]    out_U;
wire [15:0]    out_V;
PRECISION_ADJ  #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U8_Precision_adj(
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_5), 
    .en_sync_in(en_sync_data_combine), 
    .cnt_sync_in(cnt_sync_data_combine), 
    .para_in_I(out_I_comb), 
    .para_in_Q(out_Q_comb), 
    .para_in_U(out_U_comb), 
    .para_in_V(out_V_comb), 
    .para_adj_I(para_adj_I), 
    .para_adj_Q(para_adj_Q), 
    .para_adj_U(para_adj_U), 
    .para_adj_V(para_adj_V), 
    .en_sync_out(en_sync_data_adj), 
    .cnt_sync_out(cnt_sync_data_adj), 
    .para_out_I(out_I), 
    .para_out_Q(out_Q), 
    .para_out_U(out_U), 
    .para_out_V(out_V)
    );
	
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_4 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_3), 
.q(pps_out_pps_delay_4)
);
//U9-IQUV 4·ݺϳ1·
wire en_sync_data_combine_all;
wire [(BITWIDTH+3):0]cnt_sync_data_combine_all;
wire [15:0]out_all;
Data_Combine #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U9_Data_Combine (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_4), 
    .en_sync_in(en_sync_data_adj), 
    .cnt_sync_in(cnt_sync_data_adj), 
    .para_in0(out_I), 
    .para_in1(out_Q), 
    .para_in2(out_U), 
    .para_in3(out_V), 
    .en_sync_out(en_sync_data_combine_all), 
    .cnt_sync_out(cnt_sync_data_combine_all), 
    .para_out(out_all)
    );
//U9-
wire en_sync_data_comb_RL;
wire [(BITWIDTH+2):0]cnt_sync_data_comb_RL;
wire [15:0]Power_RL;
Data_Combine_RL #(
	 .BITWIDTH(BITWIDTH),//BITWIDTH
	 .FFT_POINT(FFT_POINT),//FFT_POINT
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U9_Data_Combine_RL(
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_4), 
    .en_sync_in(en_sync_data_adj), 
    .cnt_sync_in(cnt_sync_data_adj), 
    .para_in0(out_I), 
    .para_in1(out_Q), 
    .en_sync_out(en_sync_data_comb_RL), 
    .cnt_sync_out(cnt_sync_data_comb_RL), 
    .para_out(Power_RL)
    );
//U9-
wire [15:0]PowerOut;
wire en_sync_PowerOut;
wire [(BITWIDTH+1):0]cnt_sync_PowerOut;
Cal_Power #(
	 .BITWIDTH(BITWIDTH),//BITWIDTH
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U9_Cal_Power(
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_4), 
    .en_sync_in(en_sync_data_adj), 
    .cnt_sync_in(cnt_sync_data_adj), 
    .PowerIn_R(out_I), 
    .PowerIn_L(out_Q), 
    .en_sync_out(en_sync_PowerOut), 
    .cnt_sync_out(cnt_sync_PowerOut), 
    .PowerOut(PowerOut)
    );
//U10-ctrlĴģ
wire [15:0]CTRL;
wire rgmii_ctrl;
wire [1:0]sel_ctrl;
CTRL_MODULE U10(
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_4), 
    .ctrl(CTRL), 
    .rgmii_ctrl(rgmii_ctrl)
    );
//ģʽĴ
wire [1:0]width_mode;	//λѡ---0:16bit18bitreserved
wire [2:0]cal_mode;		//ģʽѡ---0ӣ1Һ󣩣2IQUVģʽ
wire [7:0]package_len;  //----λͼģʽ
wire [15:0]MODE_SEL;
MODE_REG U10_1 (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_4), 
    .mode(MODE_SEL), 
    .width_mode(width_mode), 
    .cal_mode(cal_mode), 
    .package_len(package_len)
    );
//U11-ѡ

delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_3 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_2), 
.q(pps_out_pps_delay_3)
);
wire en_sync_sel;
wire [(BITWIDTH+3):0]cnt_sync_sel;
wire [15:0]data_out;	 
Data_out_Sel #(
	 .BITWIDTH(BITWIDTH), //BITWIDTH
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U11_Data_out_Sel (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_3), 
    .sel(cal_mode[1:0]), 
    .en_sync_in_Power(en_sync_PowerOut), 
    .cnt_sync_in_Power(cnt_sync_PowerOut), 
    .data_in_Power(PowerOut), 
	 
    .en_sync_in_RL(en_sync_data_comb_RL), 
    .cnt_sync_in_RL(cnt_sync_data_comb_RL), 
    .data_in_RL(Power_RL), 
	 
    .en_sync_in_IQUV(en_sync_data_combine_all), 
    .cnt_sync_in_IQUV(cnt_sync_data_combine_all), 
    .data_in_IQUV(out_all), 
	 
    .en_sync_out(en_sync_sel), 
    .cnt_sync_out(cnt_sync_sel), 
    .data_out(data_out)
    );
//U8-ɫɢģ
wire [15:0]             para;												//arm˼õɫɢ
wire [(BITWIDTH+1):0]   para_addr;										//para ramĵַpara ramڴ洢ɫɢ
wire                    dready;													//ɫɢģ׼źţźΪʱһ֡ɫɢѾɣarmȡݣȻһarm_ackźźdreadyź
wire [23:0]             power_com_out;									//ɫɢ
wire [39:0]             timer_flag;										//ʱϢڸBTCģ飬ARMͨϢ֪ɫɢĲӦһ֡ݵ
wire                    arm_en;
wire [(BITWIDTH+1):0]   para_raddr;
wire [15:0]             para_out;
//delay for timing
reg en_sync_PowerOut_reg;
reg [7:0] PowerOut_reg;
always @(posedge clk_150M)
	begin
		if(pps_out_pps_delay_3)
			begin
				en_sync_PowerOut_reg <= 0;
				PowerOut_reg <= 0;
			end
		else
			begin
				en_sync_PowerOut_reg <= en_sync_PowerOut;
				PowerOut_reg <= PowerOut;
			end
	end
de_dispersion #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U8_de_disp(
	.clk(clk_150M),
	.rst(pps_out_pps_delay_3),
	.power_com(PowerOut[15:8]),								//cnt_sync_out[7:0]
	.para(para),
	.para_addr(para_addr),
	.en_in_sync(en_sync_PowerOut),
	.power_com_out(power_com_out),
	.dready(dready),
	.arm_ack(0),												  //arm_ack
	.time_output(timer_flag),
	.arm_en(arm_en),
	.para_raddr(para_raddr),
	.para_out(para_out)
);
wire [15:0]fifo_data_out;
wire fifo_empty;
wire fifo_rd_clk;
DEDISP_FIFO_MODULE U8_de_disp_fifo(
	.rst(pps_out_pps_delay_3),
	.clk(clk_150M),
	.power_com_in(power_com_out),
	.timer_flag(timer_flag),
	.dready(dready),
	.fifo_rd_clk(fifo_rd_clk),
	.fifo_data_out(fifo_data_out),
	.fifo_empty(fifo_empty)
    );
//IQUV4·ź
wire arm_data_ready;
wire [(BITWIDTH+3):0]arm_addr;
wire [15:0]arm_data;
wire [31:0] ms_cnt;
DATA_FOR_ARM #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U11_data_for_arm (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_3), 
    .data_in(out_all), 
    .en_sync_in(en_sync_data_combine_all), 
    .data_ready(arm_data_ready), 
    .arm_addr(arm_addr[(BITWIDTH+3):0]), 
    .arm_data(arm_data)
    );
//U6ģ//////////////////////////////////////////////////////////////////////////////////
wire [47:0]SRC_ADDR;
wire [47:0]DEST_ADDR;
wire [31:0]pps_detect_cnt;
//UDPûɶӵBTC
wire [31:0]SRC_IP;
wire [31:0]DEST_IP;
wire [15:0]SRC_PORT;
wire [15:0]DEST_PORT;
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_2 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out_pps_delay_1), 
.q(pps_out_pps_delay_2)
);

rgmii_example_design #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)U12(
    .clk_in(clk_in), 
    .phy_resetn(phy_resetn), 
    .rgmii_txd(rgmii_txd), 
    .rgmii_tx_ctl(rgmii_tx_ctl), 
    .rgmii_txc(rgmii_txc), 
    .rgmii_rxd(rgmii_rxd), 
    .rgmii_rx_ctl(rgmii_rx_ctl), 
    .rgmii_rxc(rgmii_rxc),  
    .tx_statistics_s(tx_statistics_s), 
    .rx_statistics_s(rx_statistics_s), 
    .serial_response(serial_response), 
    .frame_error(frame_error), 
    .frame_errorn(frame_errorn),
	 .rst(pps_out_pps_delay_2), 
    .clk(clk_150M), 
    .en_sync_in(en_sync_sel), 
    .cnt_sync_in(cnt_sync_sel[5:0]), //(BITWIDTH+1) //ǵСƵͨΪ64ֽڣｫһݲɶС64ֽڴȥ
    .power_com(data_out), 
    .RST_66M(pps_out_pps_delay_2), 
	 .mode_sel({8'b0,package_len}),
	 .rgmii_ctrl(rgmii_ctrl),
	 .width_ctrl(width_mode),
	 .SRC_ADDR(SRC_ADDR),
	 .DEST_ADDR(DEST_ADDR),
	 .PPS_DETECT_CNT(pps_detect_cnt),
	 //UDPûɶ
	 .SRC_IP(SRC_IP),
    .DEST_IP(DEST_IP),
    .SRC_PORT(SRC_PORT),
    .DEST_PORT(DEST_PORT)
    ); 
	
//U13-ϵͳģ飬鿴¶ȵѹ״̬
wire [15:0] sm_addr;			
wire [15:0] sm_data;	
SYS_MON U13 (																				
	.DADDR_IN(sm_addr[6:0]),
	.DCLK_IN(clk_30M),
	.DEN_IN(1'b1),
	.DI_IN(16'b0),
	.DWE_IN(1'b0),
	.RESET_IN(pps_out_pps_delay_1),
	.DO_OUT(sm_data)
	);
	
//U14-ߴģ飬FPGAARMͨ	
BTC  #(
	.BITWIDTH(BITWIDTH),
 	.ARM_BUS_DATA_WIDTH(ARM_BUS_DATA_WIDTH),
	.ARM_BUS_ADDR_WIDTH(ARM_BUS_ADDR_WIDTH),
	.CNTVALUE_WIDTH(CNTVALUE_WIDTH),
	.ADC_DATA_WIDTH(ADC_DATA_WIDTH)	
 )U14_BTC(
    .clk(clk_66M), 
    .csn(BUS_CSN), 
    .oen(BUS_OEN), 
    .wen(BUS_WEN), 
    .irq(BUS_IRQ), 
    .addr(BUS_ADDR), 
    .data(BUS_DATA), 
    .lad_out(LAD_OUT), 
    .NUM_FRAME(NUM_FRAME),
         
	.ADC_L(adc_max_min_L), 
	.ADC_R(adc_max_min_R),
	
	.MAX_I_PRE(MAX_I_PRE),
	.MAX_Q_PRE(MAX_Q_PRE),
	.MAX_U_PRE(MAX_U_PRE),
	.MAX_V_PRE(MAX_V_PRE),
	.MAX_I_AFT(MAX_I_AFT),
	.MAX_Q_AFT(MAX_Q_AFT),
	.MAX_U_AFT(MAX_U_AFT),
	.MAX_V_AFT(MAX_V_AFT),
	.SCALED_COEFF_PRE_I(SCALED_COEFF_PRE_I),
	.SCALED_COEFF_PRE_Q(SCALED_COEFF_PRE_Q),
	.SCALED_COEFF_PRE_U(SCALED_COEFF_PRE_U),
	.SCALED_COEFF_PRE_V(SCALED_COEFF_PRE_V),
	.SCALED_COEFF_AFT_I(SCALED_COEFF_AFT_I),
	.SCALED_COEFF_AFT_Q(SCALED_COEFF_AFT_Q),
	.SCALED_COEFF_AFT_U(SCALED_COEFF_AFT_U),
	.SCALED_COEFF_AFT_V(SCALED_COEFF_AFT_V),
 
	.MODE_SEL(MODE_SEL),                                      
	.sm_addr(sm_addr),
	.sm_data(sm_data),
	.PPS_RST_IN(PPS_RST_IN),
	
	.CTRL(CTRL),
	
	.ARM_DATA_READY(arm_data_ready),
	.ARM_ADDR(arm_addr),
	.ARM_DATA(arm_data),
	.PARA(para),
	.PARA_ADDR(para_addr),
	.ARM_ACK(fifo_rd_clk),
	.DREADY(fifo_empty),
	.POWER_COM_OUT(fifo_data_out),
	.ARM_EN(arm_en),
	.PARA_RADDR(para_raddr),
	.PARA_OUT(para_out),
	
	.FREQEQUA_EN(FREQEQUA_EN),
	.FREQEQUA_WADDR(FREQEQUA_WADDR),
	.FREQEQUA_WPARA(FREQEQUA_WPARA),
	.FREQEQUA_RADDR(FREQEQUA_RADDR),
	.FREQEQUA_RPARAL(FREQEQUA_RPARAL),
	.FREQEQUA_RPARAR(FREQEQUA_RPARAR),
	
	.PARA_ADJ_I(para_adj_I),
	.PARA_ADJ_Q(para_adj_Q),
	.PARA_ADJ_U(para_adj_U),
	.PARA_ADJ_V(para_adj_V),
	
	.SRC_ADDR(SRC_ADDR),
	.DEST_ADDR(DEST_ADDR),
	//UDPûɶ
	.SRC_IP(SRC_IP),
   .DEST_IP(DEST_IP),
   .SRC_PORT(SRC_PORT),
   .DEST_PORT(DEST_PORT),
	
	//IODELAY
	.adc_if_reset(adc_if_reset), 
   .adc_if_state(adc_if_state), 
	.adc_snap_state(adc_snap_state), 
   .adc_snap_addr(adc_snap_addr), 
   .adc_snap_operate(adc_snap_operate), 
   .adc_snap_data(adc_snap_data), 
	.ADC_SYNC_STATE(ADC_SYNC_STATE),
	.RST_REG(RST_REG),
	.ADC_REG(ADC_REG),
	.CLK_REG(CLK_REG),
	.ADC_RD_BACK(ADC_RD_BACK),
	.CLK_RD_BACK(CLK_RD_BACK),
	.FREQ_STEP(FREQ_STEP),
	.ddc_adj_L(ddc_adj_L_BTC),
	.ddc_adj_R(ddc_adj_R_BTC),
	.rst_ddc(rst_ddc),
	.max_ddc_L(max_ddc_L_btc),
	.max_ddc_R(max_ddc_R_btc)
    );

//U15-ģ
//-------------------------------------------------------------------------need;modified on 20131229
LED U15_LED(
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_1), 
    .LED0(led0), 
    .LED1(led1)
    );
	 
//-------------------------------------------------------------------------need;modified on 20131229
delay_line #(
.DATA_WIDTH(1),
.PIPELINE_DEPTH(1)
)
U_delay_line_pps_out_pps_delay_1 (
.clk(clk_150M),
.nd(1'b1), 
.din(pps_out), 
.q(pps_out_pps_delay_1)
);
	
PPS_DETECT U16_PPS_DETECT (
    .clk(clk_150M), 
    .rst(pps_out_pps_delay_1), 
    .pps_in(pps_in), 
    .cnt(pps_detect_cnt)
    );
	
endmodule
