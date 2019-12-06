`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:11 11/20/2018 
// Design Name: 
// Module Name:    xm0bus_sram_interface 
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
module xm0bus_sram_interface #(
	`ifdef RSR
	`elsif PSR //PSR设计;2.4GHz;双core恢复一路数据	
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512,
	`endif
	parameter ARM_BUS_DATA_WIDTH = 16,
	parameter ARM_BUS_ADDR_WIDTH = 20,
	parameter     CNTVALUE_WIDTH = 5,
	parameter     ADC_DATA_WIDTH = 8
	)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		bus_clk,
		bus_csn,
		bus_oen,
		bus_wen,
		bus_irq,
		bus_addr,
		bus_data,
		
		adc_if_reset,
		adc_if_state,
		realdelayA,
		realdelayB,
		realdelayC,
		realdelayD,
		realdelayCLKAB,
		realdelayCLKCD,
		delay_valueA,
		delay_valueB,
		delay_valueC,
		delay_valueD,
		delay_valueCLKAB,
		delay_valueCLKCD,
		`ifdef FOUR_CHANNEL_1200M
			adc_max_min_A,
			adc_max_min_B,
			adc_max_min_C,
			adc_max_min_D,
		`elsif TWO_CHANNEL_2400M
			adc_max_min_L,
			adc_max_min_R,
		`endif
		ADC_CLK,
		ADC_MOSI,
		ADC_CSN,
		ADC_RSTN,
		ADC_SYNC,
		ADC_MISO,
		
		ADF_CLK,
		ADF_DATA,
		ADF_LE,
		ADF_LD,
		
		`ifdef RSR
		`elsif PSR
			MAX_I_PRE,
			MAX_Q_PRE,
			MAX_U_PRE,
			MAX_V_PRE,
			
			MAX_I_AFT,
			MAX_Q_AFT,
			MAX_U_AFT,
			MAX_V_AFT,
			
			ARM_DATA_READY,
			ARM_DATA,
			DREADY,
			POWER_COM_OUT,
			PARA_OUT,
			FREQEQUA_RPARAL,
			FREQEQUA_RPARAR,
			
			SCALED_COEFF_PRE_I,
			SCALED_COEFF_PRE_Q,
			SCALED_COEFF_PRE_U,
			SCALED_COEFF_PRE_V,
			
			SCALED_COEFF_AFT_I,
			SCALED_COEFF_AFT_Q,
			SCALED_COEFF_AFT_U,
			SCALED_COEFF_AFT_V,
			
			NUM_FRAME,          
			
			MODE_SEL,
			PPS_RST_IN,
			
			CTRL,
			ARM_ADDR,
			PARA,
			PARA_ADDR,
			ARM_ACK,
			ARM_EN,
			PARA_RADDR,
			
			FREQEQUA_EN,
			FREQEQUA_WADDR,
			FREQEQUA_WPARA,
			FREQEQUA_RADDR,
			
			PARA_ADJ_I,
			PARA_ADJ_Q,
			PARA_ADJ_U,
			PARA_ADJ_V,
			
			RST_REG,			
			
			FREQ_STEP,
			ddc_adj_L,
			ddc_adj_R,
			rst_ddc,
			max_ddc_L,
			max_ddc_R,
		`endif		
		adc_snap_state,
		adc_snap_addr,
		adc_snap_operate,
		adc_snap_data,
		
		sm_addr,
		sm_data,
		
		SRC_ADDR,
		DEST_ADDR
	);
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	input                                              bus_clk;
	input                                              bus_csn;
	input                                              bus_oen;
	input                                              bus_wen;
	input                                              bus_irq;
	input     [ARM_BUS_ADDR_WIDTH-1:0]                 bus_addr;
	
	
	input     [ARM_BUS_DATA_WIDTH-1:0]                 adc_if_state;
	
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayA;
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayB;
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayC;
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayD;
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayCLKAB;
	input     [ARM_BUS_DATA_WIDTH-1:0]                 realdelayCLKCD;
	
	input     [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_state;
	input     [ADC_DATA_WIDTH-1:0]                     adc_snap_data;
	
	input                                              ADC_MISO;	
	input                                              ADF_LD;
	
	input     [ARM_BUS_DATA_WIDTH-1:0]                 sm_data;
	
	`ifdef FOUR_CHANNEL_1200M
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_A;
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_B;
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_C;
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_D;
	`elsif TWO_CHANNEL_2400M
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_L;
		input    [ARM_BUS_DATA_WIDTH-1:0]             adc_max_min_R;
	`endif
	
	`ifdef RSR
	`elsif PSR
		input     [47:0]                              MAX_I_PRE;
		input     [47:0]                              MAX_Q_PRE;
		input     [47:0]                              MAX_U_PRE;
		input     [47:0]                              MAX_V_PRE;
		
		input     [31:0]                              MAX_I_AFT;
		input     [31:0]                              MAX_Q_AFT;
		input     [31:0]                              MAX_U_AFT;
		input     [31:0]                              MAX_V_AFT;
		
		input                                         ARM_DATA_READY;
		input     [ARM_BUS_DATA_WIDTH-1:0]            ARM_DATA;
		input                                         DREADY;
		input     [ARM_BUS_DATA_WIDTH-1:0]            POWER_COM_OUT;
		input     [ARM_BUS_DATA_WIDTH-1:0]            PARA_OUT;
		input     [ARM_BUS_DATA_WIDTH-1:0]            FREQEQUA_RPARAL;
		input     [ARM_BUS_DATA_WIDTH-1:0]            FREQEQUA_RPARAR;
		input     [47:0]                              max_ddc_L;
		input     [47:0]                              max_ddc_R;
	`endif
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueA;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueB;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueC;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueD;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKAB;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKCD;
	output                                             ADC_CLK;
	output                                             ADC_MOSI;
	output                                             ADC_CSN;
	output                                             ADC_RSTN;
	output                                             ADC_SYNC;

	output                                             ADF_CLK;
	output                                             ADF_DATA;
	output                                             ADF_LE;
	
	output    [ARM_BUS_DATA_WIDTH-1:0]                 adc_if_reset;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_operate;
	output    [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_addr;
	
	output    [ARM_BUS_DATA_WIDTH-1:0]                 sm_addr;
		
	output    [47:0]                                   SRC_ADDR;
	output    [47:0]                                   DEST_ADDR;
	
	`ifdef RSR
	`elsif PSR
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_I;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_Q;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_U;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_V;
		
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_I;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_Q;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_U;
		output [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_V;
		
		output [ARM_BUS_DATA_WIDTH-1:0]                NUM_FRAME;           
		
		output [ARM_BUS_DATA_WIDTH-1:0]                MODE_SEL;
		output                                         PPS_RST_IN;
                                                       
		output [ARM_BUS_DATA_WIDTH-1:0]                CTRL;
		output [(BITWIDTH+3):0]                        ARM_ADDR;
		output [ARM_BUS_DATA_WIDTH-1:0]                PARA;
		output [(BITWIDTH+1):0]                        PARA_ADDR;
		output                                         ARM_ACK;
		output                                         ARM_EN;
		output [(BITWIDTH+1):0]                        PARA_RADDR;
		
		output [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_EN;
		output [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_WADDR;
		output [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_WPARA;
		output [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_RADDR;
		
		output [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_I;
		output [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_Q;
		output [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_U;
		output [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_V;
		
		output [ARM_BUS_DATA_WIDTH-1:0]                RST_REG;			
		//DDC
		output [ARM_BUS_DATA_WIDTH-1:0]              FREQ_STEP;
		output [ARM_BUS_DATA_WIDTH-1:0]              ddc_adj_L;
		output [ARM_BUS_DATA_WIDTH-1:0]              ddc_adj_R;
		output                                         rst_ddc;
		
	`endif
	//*************************************//
	//************ inout ****************//
	//*************************************//	
	
	inout     [ARM_BUS_DATA_WIDTH-1:0]                 bus_data;
	
	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire                                               BUS_CSN_BUF;
	wire                                               BUS_OEN_BUF;
	wire                                               BUS_WEN_BUF;
	wire                                               BUS_IRQ_BUF;
	wire      [ARM_BUS_ADDR_WIDTH-1:0]                 BUS_ADDR_BUF;
	wire                                               T;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 bus_data_out;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 bus_data_out_page0;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 bus_data_out_page1;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 bus_data_out_page2;
	//reg       [ARM_BUS_DATA_WIDTH-1:0]                 bus_data_out_page3;
	
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueA_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueB_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueC_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueD_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKAB_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 delay_valueCLKCD_reg;
	
	reg                                                ADC_CLK_reg;
	reg                                                ADC_MOSI_reg;
	reg                                                ADC_CSN_reg;
	reg                                                ADC_RSTN_reg;
	reg                                                ADC_SYNC_reg;
	
	reg                                                ADF_CLK_reg;
	reg                                                ADF_DATA_reg;
	reg                                                ADF_LE_reg;
	
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 adc_if_reset_reg;
	
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_operate_reg;
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 adc_snap_addr_reg;
	
	reg       [ARM_BUS_DATA_WIDTH-1:0]                 sm_addr_reg;
	reg       [47:0]                                   SRC_ADDR_reg;
    reg       [47:0]                                   DEST_ADDR_reg;
	
	`ifdef RSR
	`elsif PSR
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_I_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_Q_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_U_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_PRE_V_reg;
		
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_I_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_Q_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_U_reg;
		reg  [ARM_BUS_DATA_WIDTH-1:0]                SCALED_COEFF_AFT_V_reg;
		
		reg  [ARM_BUS_DATA_WIDTH-1:0]                NUM_FRAME_reg;
		
		reg  [ARM_BUS_DATA_WIDTH-1:0]                MODE_SEL_reg;
		reg                                          PPS_RST_IN_reg;
		
		reg  [ARM_BUS_DATA_WIDTH-1:0]                CTRL_reg;
		reg [(BITWIDTH+3):0]                        ARM_ADDR_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                PARA_reg;
		reg [(BITWIDTH+1):0]                        PARA_ADDR_reg;
		reg                                         ARM_ACK_reg;
		reg                                         ARM_EN_reg;
		reg [(BITWIDTH+1):0]                        PARA_RADDR_reg;
		
		reg [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_EN_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_WADDR_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_WPARA_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                FREQEQUA_RADDR_reg;
		
		reg [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_I_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_Q_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_U_reg;
		reg [ARM_BUS_DATA_WIDTH-1:0]                PARA_ADJ_V_reg;
		
		reg [ARM_BUS_DATA_WIDTH-1:0]                RST_REG_reg;
		
		reg [ARM_BUS_DATA_WIDTH-1-1:0]              FREQ_STEP_reg;
		reg [ARM_BUS_DATA_WIDTH-1-1:0]              ddc_adj_L_reg;
		reg [ARM_BUS_DATA_WIDTH-1-1:0]              ddc_adj_R_reg;
		reg                                         rst_ddc_reg;
		
	`endif
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign      delay_valueA = delay_valueA_reg;
	assign      delay_valueB = delay_valueB_reg;
	assign      delay_valueC = delay_valueC_reg;
	assign      delay_valueD = delay_valueD_reg;
	assign  delay_valueCLKAB = delay_valueCLKAB_reg;
	assign  delay_valueCLKCD = delay_valueCLKCD_reg;
	
	assign           ADC_CLK = ADC_CLK_reg;
	assign          ADC_MOSI = ADC_MOSI_reg;
	assign           ADC_CSN = ADC_CSN_reg;
	assign          ADC_RSTN = ADC_RSTN_reg;
	assign          ADC_SYNC = ADC_SYNC_reg;
	
	assign           ADF_CLK = ADF_CLK_reg;
	assign          ADF_DATA = ADF_DATA_reg;
	assign            ADF_LE = ADF_LE_reg;
	
	assign      adc_if_reset = adc_if_reset_reg;
	
	assign     adc_snap_addr = adc_snap_addr_reg;
	assign  adc_snap_operate = adc_snap_operate_reg;
	
	assign           sm_addr = sm_addr_reg;
	
	assign          SRC_ADDR = SRC_ADDR_reg;
	assign         DEST_ADDR = DEST_ADDR_reg;
	
	assign          bus_data = T?bus_data_out:16'dz;
	
	`ifdef RSR
	`elsif PSR
		assign SCALED_COEFF_PRE_I = SCALED_COEFF_PRE_I_reg;
		assign SCALED_COEFF_PRE_Q = SCALED_COEFF_PRE_Q_reg;
		assign SCALED_COEFF_PRE_U = SCALED_COEFF_PRE_U_reg;
		assign SCALED_COEFF_PRE_V = SCALED_COEFF_PRE_V_reg;
		
		assign SCALED_COEFF_AFT_I = SCALED_COEFF_AFT_I_reg;
		assign SCALED_COEFF_AFT_Q = SCALED_COEFF_AFT_Q_reg;
		assign SCALED_COEFF_AFT_U = SCALED_COEFF_AFT_U_reg;
		assign SCALED_COEFF_AFT_V = SCALED_COEFF_AFT_V_reg;
		
		assign          NUM_FRAME = NUM_FRAME_reg;
		
		assign           MODE_SEL = MODE_SEL_reg;
		assign         PPS_RST_IN = PPS_RST_IN_reg;
		
		assign              CTRL  = CTRL_reg;
		assign           ARM_ADDR = ARM_ADDR_reg;
		assign               PARA = PARA_reg;
		assign          PARA_ADDR = PARA_ADDR_reg;
		assign            ARM_ACK = ARM_ACK_reg;
		assign             ARM_EN = ARM_EN_reg;
		assign         PARA_RADDR = PARA_RADDR_reg;
		
		assign        FREQEQUA_EN = FREQEQUA_EN_reg;
		assign     FREQEQUA_WADDR = FREQEQUA_WADDR_reg;
		assign     FREQEQUA_WPARA = FREQEQUA_WPARA_reg;
		assign     FREQEQUA_RADDR = FREQEQUA_RADDR_reg;
		
		assign         PARA_ADJ_I = PARA_ADJ_I_reg;
		assign         PARA_ADJ_Q = PARA_ADJ_Q_reg;
		assign         PARA_ADJ_U = PARA_ADJ_U_reg;
		assign         PARA_ADJ_V = PARA_ADJ_V_reg;
		        
		assign            RST_REG = RST_REG_reg;
		        
		assign          FREQ_STEP = FREQ_STEP_reg;
		assign          ddc_adj_L = ddc_adj_L_reg;
		assign          ddc_adj_R = ddc_adj_R_reg;
		assign            rst_ddc = rst_ddc_reg;
	`endif
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	assign T = (~BUS_CSN_BUF) & (~BUS_OEN_BUF);
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** 总线接口IBUFs *****//
	IBUF #(
	.IBUF_LOW_PWR("TRUE"),  // Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards 
	.IOSTANDARD("DEFAULT")  // Specify the input I/O standard
	)IBUF_BUS_CSN (
	.O(BUS_CSN_BUF),     // Buffer output
	.I(bus_csn)      // Buffer input (connect directly to top-level port)
	);
	
	IBUF #(
	.IBUF_LOW_PWR("TRUE"),  // Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards 
	.IOSTANDARD("DEFAULT")  // Specify the input I/O standard
	)IBUF_BUS_OEN (
	.O(BUS_OEN_BUF),     // Buffer output
	.I(bus_oen)      // Buffer input (connect directly to top-level port)
	);
	
	IBUF #(
	.IBUF_LOW_PWR("TRUE"),  // Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards 
	.IOSTANDARD("DEFAULT")  // Specify the input I/O standard
	)IBUF_BUS_WEN (
	.O(BUS_WEN_BUF),     // Buffer output
	.I(bus_wen)      // Buffer input (connect directly to top-level port)
	);
	
	IBUF #(
	.IBUF_LOW_PWR("TRUE"),  // Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards 
	.IOSTANDARD("DEFAULT")  // Specify the input I/O standard
	)IBUF_BUS_IRQ (
	.O(BUS_IRQ_BUF),     // Buffer output
	.I(bus_irq)      // Buffer input (connect directly to top-level port)
	);

	genvar i;
	generate
	for (i=0; i < ARM_BUS_ADDR_WIDTH; i=i+1) 
	begin: INST_IBUF_ADDR 
		IBUF #(
		.IBUF_LOW_PWR("TRUE"),  // Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards 
		.IOSTANDARD("DEFAULT")  // Specify the input I/O standard
		)IBUF_BUS_ADDR (
		.O(BUS_ADDR_BUF[i]),     // Buffer output
		.I(bus_addr[i])      // Buffer input (connect directly to top-level port)
		);
	end
	endgenerate	
	
	//***** 分页输出MUXOUT *****//
	always @(*)
	begin
		if(~BUS_CSN_BUF && BUS_ADDR_BUF[ARM_BUS_ADDR_WIDTH-1])
		begin
			case (BUS_ADDR_BUF[12:11])
				2'b00:	bus_data_out <= bus_data_out_page0;
				2'b01:	bus_data_out <= bus_data_out_page1;
				2'b10:	bus_data_out <= bus_data_out_page2;
				2'b11:	bus_data_out <= bus_data_out_page0;
				default:	bus_data_out   <=    bus_data_out;
			endcase
		end
	end
	
	//***** 应用寄存器，分页0 *****//
	`ifdef RSR
	`elsif PSR
		always @(posedge bus_clk)
		begin
			if(~BUS_CSN_BUF && BUS_ADDR_BUF[ARM_BUS_ADDR_WIDTH-1] && BUS_ADDR_BUF[12:11]==2'b00)//片选 & 分页，按1024,2048对应[11]和[10]
			begin
				if(~BUS_OEN_BUF)//读使能
				begin
					case(BUS_ADDR_BUF[10:1])//不判断最后一位，避免奇数地址没有输出
						10'd0:    bus_data_out_page0   <=       NUM_FRAME;
						
						10'd5:    bus_data_out_page0   <=       adc_max_min_L;
						10'd6:    bus_data_out_page0   <=       adc_max_min_R;
						
						10'd8:    bus_data_out_page0   <=       sm_data;
						10'd9:    bus_data_out_page0   <=       sm_addr_reg; 
						
						10'd15:   bus_data_out_page0   <=       {15'b0,ARM_DATA_READY};
						10'd16:   bus_data_out_page0   <=       ARM_ADDR_reg;
						10'd17:   begin
										bus_data_out_page0   <=       ARM_DATA;
										//ARM_ADDR_reg   <=       ARM_ADDR_reg+1'b1;
								end
								
						10'd19:   bus_data_out_page0   <=       {15'b0,DREADY};
						10'd20:   bus_data_out_page0   <=       POWER_COM_OUT;
						
						10'd25:   bus_data_out_page0   <=       PARA_OUT;
						10'd26:   bus_data_out_page0   <=       SRC_ADDR_reg[15:0];
						10'd27:   bus_data_out_page0   <=       SRC_ADDR_reg[31:16];
						10'd28:   bus_data_out_page0   <=       SRC_ADDR_reg[47:32];
						10'd29:   bus_data_out_page0   <=       DEST_ADDR_reg[15:0];
						10'd30:   bus_data_out_page0   <=       DEST_ADDR_reg[31:16];
						10'd31:   bus_data_out_page0   <=       DEST_ADDR_reg[47:32];
						10'd32:   bus_data_out_page0   <=       CTRL_reg;
						10'd33:   bus_data_out_page0   <=       MAX_I_PRE[15:0];
						10'd34:   bus_data_out_page0   <=       MAX_I_PRE[31:16];
						10'd35:   bus_data_out_page0   <=       MAX_I_PRE[47:32];
						10'd36:   bus_data_out_page0   <=       MAX_I_AFT[15:0];
						10'd37:   bus_data_out_page0   <=       MAX_I_AFT[31:16];
						10'd39:   bus_data_out_page0   <=       SCALED_COEFF_PRE_I_reg;
						10'd40:   bus_data_out_page0   <=       SCALED_COEFF_AFT_I_reg;
						10'd41:   bus_data_out_page0   <=       MAX_Q_PRE[15:0];
						10'd42:   bus_data_out_page0   <=       MAX_Q_PRE[31:16];
						10'd43:   bus_data_out_page0   <=       MAX_Q_PRE[47:32];
						10'd44:   bus_data_out_page0   <=       MAX_Q_AFT[15:0];
						10'd45:   bus_data_out_page0   <=       MAX_Q_AFT[31:16];
						10'd47:   bus_data_out_page0   <=       SCALED_COEFF_PRE_Q_reg;
						10'd48:   bus_data_out_page0   <=       SCALED_COEFF_AFT_Q_reg;
						10'd49:   bus_data_out_page0   <=       MAX_U_PRE[15:0];
						10'd50:   bus_data_out_page0   <=       MAX_U_PRE[31:16];
						10'd51:   bus_data_out_page0   <=       MAX_U_PRE[47:32];
						10'd52:   bus_data_out_page0   <=       MAX_U_AFT[15:0];
						10'd53:   bus_data_out_page0   <=       MAX_U_AFT[31:16];
						10'd55:   bus_data_out_page0   <=       SCALED_COEFF_PRE_U_reg;
						10'd56:   bus_data_out_page0   <=       SCALED_COEFF_AFT_U_reg;
						10'd57:   bus_data_out_page0   <=       MAX_V_PRE[15:0];
						10'd58:   bus_data_out_page0   <=       MAX_V_PRE[31:16];
						10'd59:   bus_data_out_page0   <=       MAX_V_PRE[47:32];
						10'd60:   bus_data_out_page0   <=       MAX_V_AFT[15:0];
						10'd61:   bus_data_out_page0   <=       MAX_V_AFT[31:16];
						10'd63:   bus_data_out_page0   <=       SCALED_COEFF_PRE_V_reg;
						10'd64:   bus_data_out_page0   <=       SCALED_COEFF_AFT_V_reg;
						10'd65:   bus_data_out_page0   <=       MODE_SEL_reg;					
						10'd66:	begin
								bus_data_out_page0   <=       FREQEQUA_RPARAL;
								//FREQEQUA_RADDR_reg <=       FREQEQUA_RADDR_reg+1;
								end
						10'd67:begin
								bus_data_out_page0   <=       FREQEQUA_RPARAR;
								//FREQEQUA_RADDR_reg <=   FREQEQUA_RADDR_reg+1;
								end
						10'd68:   bus_data_out_page0   <=       FREQEQUA_RADDR_reg;
						10'd69:   bus_data_out_page0   <=       FREQEQUA_EN_reg;
						10'd70:   bus_data_out_page0   <=       FREQEQUA_WADDR_reg;
						10'd71:begin
								bus_data_out_page0   <=       FREQEQUA_WPARA_reg;
								//FREQEQUA_WADDR_reg <=       FREQEQUA_WADDR_reg+1;
								end
						10'd72:   bus_data_out_page0   <=       PARA_ADJ_I;
						10'd73:   bus_data_out_page0   <=       PARA_ADJ_Q;
						10'd74:   bus_data_out_page0   <=       PARA_ADJ_U;
						10'd75:   bus_data_out_page0   <=       PARA_ADJ_V;
						
						
						10'd85:   bus_data_out_page0   <=       RST_REG_reg;
						
						10'd90:   bus_data_out_page0   <=   {FREQ_STEP_reg};
						10'd91:   bus_data_out_page0   <=   {ddc_adj_L_reg};
						10'd92:   bus_data_out_page0   <=   {ddc_adj_R_reg};
						10'd93:   bus_data_out_page0   <=   {15'b0,rst_ddc_reg};
						10'd94:   bus_data_out_page0   <=    max_ddc_L[15:0];
						10'd95:   bus_data_out_page0   <=    max_ddc_L[31:16];
						10'd96:   bus_data_out_page0   <=    max_ddc_L[47:32];
						10'd97:   bus_data_out_page0   <=    max_ddc_R[15:0];
						10'd98:   bus_data_out_page0   <=    max_ddc_R[31:16];
						10'd99:   bus_data_out_page0   <=    max_ddc_R[47:32];
						default:	bus_data_out_page0   <=    bus_data_out_page0;
					endcase
				end
				else if((~BUS_WEN_BUF))//写使能
				begin
					case(BUS_ADDR_BUF[10:1])
					10'd0:     NUM_FRAME_reg              <=  bus_data;
					
					10'd9:    sm_addr_reg               <=    bus_data;				
					
					10'd12:    PPS_RST_IN_reg  <=  bus_data[0:0];
					
					10'd16:    ARM_ADDR_reg   <=  bus_data[(BITWIDTH+3):0];
					10'd17:    PARA_reg           <=  bus_data[15:0];
					10'd18:    PARA_ADDR_reg      <=  bus_data[10:0];
					10'd19:    ARM_ACK_reg        <=  bus_data[0:0];
					10'd20:    ARM_EN_reg         <=  bus_data[0:0];
					10'd21:    PARA_RADDR_reg     <=  bus_data[10:0];
					10'd22:    SRC_ADDR_reg[15:0]<=bus_data;
					10'd23:    SRC_ADDR_reg[31:16]<=bus_data;
					10'd24:    SRC_ADDR_reg[47:32]<=bus_data;
					10'd25:    DEST_ADDR_reg[15:0]<=bus_data;
					10'd26:    DEST_ADDR_reg[31:16]<=bus_data;
					10'd27:    DEST_ADDR_reg[47:32]<=bus_data;
					//只读9'd25:   bus_data_out_page0   <=       PARA_OUT;		
					10'd32:    CTRL_reg                   <=  bus_data;
					//38:lad_out<=MAX_I_AFT[47:32];
					10'd39:    SCALED_COEFF_PRE_I_reg     <=  bus_data;
					10'd40:    SCALED_COEFF_AFT_I_reg     <=  bus_data;
					
					10'd47:    SCALED_COEFF_PRE_Q_reg     <=  bus_data;
					10'd48:    SCALED_COEFF_AFT_Q_reg     <=  bus_data;
					
					10'd55:    SCALED_COEFF_PRE_U_reg     <=  bus_data;
					10'd56:    SCALED_COEFF_AFT_U_reg     <=  bus_data;
					
					10'd63:    SCALED_COEFF_PRE_V_reg     <=  bus_data;
					10'd64:    SCALED_COEFF_AFT_V_reg     <=  bus_data;
					10'd65:    MODE_SEL_reg               <=  bus_data;
					
					10'd68:    FREQEQUA_RADDR_reg         <=  bus_data;
					10'd69:    FREQEQUA_EN_reg            <=  bus_data;
					10'd70:    FREQEQUA_WADDR_reg         <=  bus_data;
					10'd71:    FREQEQUA_WPARA_reg         <=  bus_data;
					10'd72:    PARA_ADJ_I_reg             <=  bus_data;
					10'd73:    PARA_ADJ_Q_reg             <=  bus_data;
					10'd74:    PARA_ADJ_U_reg             <=  bus_data;
					10'd75:    PARA_ADJ_V_reg             <=  bus_data;
					
					10'd85:    RST_REG_reg                <=  bus_data;
					
					10'd90:    FREQ_STEP_reg   <=   bus_data;
					10'd91:    ddc_adj_L_reg   <=   bus_data;
					10'd92:    ddc_adj_R_reg   <=   bus_data;
					10'd93:    rst_ddc_reg     <=   bus_data[0];

					endcase
				end
				else//没有读写
					begin
						SRC_ADDR_reg  <= SRC_ADDR_reg;
						SRC_ADDR_reg  <= SRC_ADDR_reg;
						SRC_ADDR_reg  <= SRC_ADDR_reg;
						DEST_ADDR_reg <= DEST_ADDR_reg;
						DEST_ADDR_reg <= DEST_ADDR_reg;
						DEST_ADDR_reg <= DEST_ADDR_reg;						
						SCALED_COEFF_PRE_I_reg  <=SCALED_COEFF_PRE_I_reg;
						SCALED_COEFF_PRE_Q_reg  <=SCALED_COEFF_PRE_Q_reg;
						SCALED_COEFF_PRE_U_reg  <=SCALED_COEFF_PRE_U_reg;
						SCALED_COEFF_PRE_V_reg  <=SCALED_COEFF_PRE_V_reg;
						SCALED_COEFF_AFT_I_reg  <=SCALED_COEFF_AFT_I_reg;
						SCALED_COEFF_AFT_Q_reg  <=SCALED_COEFF_AFT_Q_reg;
						SCALED_COEFF_AFT_U_reg  <=SCALED_COEFF_AFT_U_reg;
						SCALED_COEFF_AFT_V_reg  <=SCALED_COEFF_AFT_V_reg;
						NUM_FRAME_reg           <=  NUM_FRAME_reg;
						MODE_SEL_reg            <=  MODE_SEL_reg;
						PPS_RST_IN_reg          <=  PPS_RST_IN_reg;
						CTRL_reg                <=  CTRL_reg;
						ARM_ADDR_reg            <=  ARM_ADDR_reg;
						PARA_reg                <=  PARA_reg;
						PARA_ADDR_reg           <=  PARA_ADDR_reg;
						ARM_ACK_reg             <=  ARM_ACK_reg;
						ARM_EN_reg              <=  ARM_EN_reg;
						PARA_RADDR_reg          <=  PARA_RADDR_reg;
						FREQEQUA_EN_reg         <=  FREQEQUA_EN_reg;
						FREQEQUA_WADDR_reg      <=  FREQEQUA_WADDR_reg;
						FREQEQUA_WPARA_reg      <=  FREQEQUA_WPARA_reg;
						FREQEQUA_RADDR_reg      <=  FREQEQUA_RADDR_reg;
						PARA_ADJ_I_reg          <=  PARA_ADJ_I_reg;
						PARA_ADJ_Q_reg          <=  PARA_ADJ_Q_reg;
						PARA_ADJ_U_reg          <=  PARA_ADJ_U_reg;
						PARA_ADJ_V_reg          <=  PARA_ADJ_V_reg;
						RST_REG_reg             <=  RST_REG_reg;
						FREQ_STEP_reg           <=  FREQ_STEP_reg;
						ddc_adj_L_reg           <=  ddc_adj_L_reg;
						ddc_adj_R_reg           <=  ddc_adj_R_reg;
						rst_ddc_reg             <=  rst_ddc_reg;
					end
			end
		end
	`endif

	//***** 芯片配置 *****//
	always @(posedge bus_clk)
	begin
		if(~BUS_CSN_BUF && BUS_ADDR_BUF[ARM_BUS_ADDR_WIDTH-1]&& BUS_ADDR_BUF[12:11]==2'b01)//片选 & 分页，1024开始
		begin
			if(~BUS_OEN_BUF)//读使能
			begin
				case(BUS_ADDR_BUF[9:1])//不判断最后一位，避免奇数地址没有输出
					10'd0:/*1024*/	bus_data_out_page1   <=    {11'd0,ADC_SYNC_reg,ADC_RSTN_reg,ADC_CSN_reg,ADC_MOSI_reg,ADC_CLK_reg};
					10'd1:/*1025*/	bus_data_out_page1   <=    {15'd0,ADC_MISO};//实际读的信号					
					10'd2:/*1026*/	bus_data_out_page1   <=    {13'd0,ADF_LE_reg,ADF_DATA_reg,ADF_CLK_reg};
					10'd3:/*1027*/	bus_data_out_page1   <=    {15'd0,ADF_LD};//实际读的信号
				default:
						bus_data_out_page1 <= bus_data_out_page1;
				endcase
			end
			else if((~BUS_WEN_BUF))//写使能
			begin
				case(BUS_ADDR_BUF[10:1])
					10'd0:/*1024*/	{ADC_SYNC_reg,ADC_RSTN_reg,ADC_CSN_reg,ADC_MOSI_reg,ADC_CLK_reg} <= bus_data[4:0]; 
					
					10'd2:/*1026*/	{ADF_LE_reg,ADF_DATA_reg,ADF_CLK_reg} <= bus_data[2:0];					
				endcase
			end
			else begin
				bus_data_out_page1 <= bus_data_out_page1;
				ADC_SYNC_reg          <= ADC_SYNC_reg;
				ADC_RSTN_reg          <= ADC_RSTN_reg;
				ADC_CSN_reg           <= ADC_CSN_reg;
				ADC_MOSI_reg          <= ADC_MOSI_reg;
				ADC_CLK_reg           <= ADC_CLK_reg;
				ADF_LE_reg            <= ADF_LE_reg;
				ADF_DATA_reg          <= ADF_DATA_reg;
				ADF_CLK_reg           <= ADF_CLK_reg;
			end
		end
	end
	
	//***** 通用adc接口 *****//
	always @(posedge bus_clk)
	begin
		if(~BUS_CSN_BUF && BUS_ADDR_BUF[ARM_BUS_ADDR_WIDTH-1]&& BUS_ADDR_BUF[12:11]==2'b10)//片选 & 分页，2048开始		begin
		begin
			if(~BUS_OEN_BUF)//读使能
			begin
				case(BUS_ADDR_BUF[10:1])//不判断最后一位，避免奇数地址没有输出
				10'd0:  /*2048*/	bus_data_out_page2   <=    adc_if_reset_reg;
				10'd1:  /*2049*/	bus_data_out_page2   <=    adc_if_state;
				10'd2:  /*2050*/	bus_data_out_page2   <=    realdelayA;
				10'd3:  /*2051*/	bus_data_out_page2   <=    realdelayB;
				10'd4:  /*2052*/	bus_data_out_page2   <=    realdelayC;
				10'd5:  /*2053*/	bus_data_out_page2   <=    realdelayD;
				10'd6:  /*2054*/	bus_data_out_page2   <=    realdelayCLKAB;
				10'd7:  /*2055*/	bus_data_out_page2   <=    realdelayCLKCD;
				10'd8:  /*2056*/	bus_data_out_page2   <=    adc_snap_operate_reg;
				10'd9:  /*2057*/	bus_data_out_page2   <=    adc_snap_addr_reg;
				10'd10: /*2058*/	bus_data_out_page2   <=    {{(ARM_BUS_DATA_WIDTH-ADC_DATA_WIDTH){1'b0}},adc_snap_data};
				10'd11: /*2059*/	bus_data_out_page2   <=    adc_snap_state;
				default:
						bus_data_out_page2 <= bus_data_out_page2;
				endcase
			end
			else if((~BUS_WEN_BUF))//写使能
			begin
				case(BUS_ADDR_BUF[10:1])
					10'd0:  /*2048*/	adc_if_reset_reg            <= bus_data;
					
					10'd2:  /*2050*/	delay_valueA_reg            <= bus_data;
					10'd3:  /*2051*/	delay_valueB_reg            <= bus_data;
					10'd4:  /*2052*/	delay_valueC_reg            <= bus_data;
					10'd5:  /*2053*/	delay_valueD_reg            <= bus_data;
					10'd6:  /*2054*/	delay_valueCLKAB_reg        <= bus_data;
					10'd7:  /*2055*/	delay_valueCLKCD_reg        <= bus_data;
					10'd8:  /*2056*/	adc_snap_operate_reg        <= bus_data;	
					10'd9:  /*2057*/ adc_snap_addr_reg           <= bus_data;
				endcase
			end
			else begin
					bus_data_out_page2 <= bus_data_out_page2;
					adc_if_reset_reg      <= adc_if_reset_reg;
					delay_valueA_reg      <= delay_valueA_reg;
					delay_valueB_reg      <= delay_valueB_reg;
					delay_valueC_reg      <= delay_valueC_reg;
					delay_valueD_reg      <= delay_valueD_reg;
					delay_valueCLKAB_reg  <= delay_valueCLKAB_reg;
					delay_valueCLKCD_reg  <= delay_valueCLKCD_reg;
					adc_snap_operate_reg  <= adc_snap_operate_reg;
					adc_snap_addr_reg     <= adc_snap_addr_reg;
			end
		end
	end

endmodule
