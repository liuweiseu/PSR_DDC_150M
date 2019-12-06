`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		ZJW
// 
// Create Date:    21:57:12 17/06/2014 
// Design Name: 
// Module Name:    BTC 
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
module BTC #(
	parameter BITWIDTH = 9,
    parameter ARM_BUS_DATA_WIDTH = 16,
	parameter ARM_BUS_ADDR_WIDTH = 20,
	parameter     CNTVALUE_WIDTH = 5,
	parameter     ADC_DATA_WIDTH = 8)
(
	input clk,
	input csn,
	input oen,
	input wen,
	input irq,

	input [ARM_BUS_ADDR_WIDTH-1:0] addr,
	inout [ARM_BUS_DATA_WIDTH-1:0] data,

	output reg [ARM_BUS_DATA_WIDTH-1:0] sm_addr,
	input [ARM_BUS_DATA_WIDTH-1:0] sm_data,
	
	input [47:0]MAX_I_PRE,
	input [47:0]MAX_Q_PRE,
	input [47:0]MAX_U_PRE,
	input [47:0]MAX_V_PRE,
	input [31:0]MAX_I_AFT,
	input [31:0]MAX_Q_AFT,
	input [31:0]MAX_U_AFT,
	input [31:0]MAX_V_AFT,
	
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_PRE_I,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_PRE_Q,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_PRE_U,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_PRE_V,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_AFT_I,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_AFT_Q,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_AFT_U,
	output reg[ARM_BUS_DATA_WIDTH-1:0]SCALED_COEFF_AFT_V,
	
	output reg [ARM_BUS_DATA_WIDTH-1:0] lad_out,
	output reg [ARM_BUS_DATA_WIDTH-1:0] NUM_FRAME,           
	input [ARM_BUS_DATA_WIDTH-1:0] ADC_L,ADC_R,
	
	output reg [ARM_BUS_DATA_WIDTH-1:0]MODE_SEL,
	output reg PPS_RST_IN,

	output reg [ARM_BUS_DATA_WIDTH-1:0]CTRL,
	
	input ARM_DATA_READY,
	output reg [(BITWIDTH+3):0]ARM_ADDR,
	input [ARM_BUS_DATA_WIDTH-1:0]ARM_DATA,
	output reg [ARM_BUS_DATA_WIDTH-1:0]PARA,
	output reg [(BITWIDTH+1):0]PARA_ADDR,
	output reg ARM_ACK,
	input DREADY,
	input [ARM_BUS_DATA_WIDTH-1:0]POWER_COM_OUT,
//	input [39:0]TIMER_FLAG,
	output reg ARM_EN,
	output reg [(BITWIDTH+1):0]PARA_RADDR,
	input [ARM_BUS_DATA_WIDTH-1:0]PARA_OUT,
	
	output reg [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_EN,
	output reg [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_WADDR,
	output reg [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_WPARA,
	output reg [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_RADDR,
	input [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_RPARAL,
	input [ARM_BUS_DATA_WIDTH-1:0]FREQEQUA_RPARAR,
	
	output reg [ARM_BUS_DATA_WIDTH-1:0]PARA_ADJ_I,
	output reg [ARM_BUS_DATA_WIDTH-1:0]PARA_ADJ_Q,
	output reg [ARM_BUS_DATA_WIDTH-1:0]PARA_ADJ_U,
	output reg [ARM_BUS_DATA_WIDTH-1:0]PARA_ADJ_V,
	
	output reg [47:0]SRC_ADDR=48'h5a0102030405,
	output reg [47:0]DEST_ADDR=48'h00e04c68d2e6,
	//UDPûɶĬϳʼֵ
	output reg [31:0]SRC_IP=32'hc0a802f7,
	output reg [31:0]DEST_IP=32'hc0a80201,
	output reg [15:0]SRC_PORT=16'h0017,
	output reg [15:0]DEST_PORT=16'h0022,

	
   //IODELAY
	input [ARM_BUS_DATA_WIDTH-1:0] adc_if_state,
	input [ARM_BUS_DATA_WIDTH-1:0] adc_snap_state,
	input [ADC_DATA_WIDTH-1:0]     adc_snap_data,
	output reg [ARM_BUS_DATA_WIDTH-1:0] adc_if_reset,
	output reg [ARM_BUS_DATA_WIDTH-1:0] adc_snap_operate,
	output reg [ARM_BUS_DATA_WIDTH-1:0] adc_snap_addr,
	//ͬ
	input [ARM_BUS_DATA_WIDTH-1:0]ADC_SYNC_STATE,
	
	output reg [ARM_BUS_DATA_WIDTH-1:0]RST_REG,
	
	input [ARM_BUS_DATA_WIDTH-1:0]ADC_RD_BACK,
	input [ARM_BUS_DATA_WIDTH-1:0]CLK_RD_BACK,
	output reg[ARM_BUS_DATA_WIDTH-1:0]ADC_REG,
	output reg[ARM_BUS_DATA_WIDTH-1:0]CLK_REG,
	
	//DDC
	input     [47:0]                              max_ddc_L,
	input     [47:0]                              max_ddc_R,
	output reg [ARM_BUS_DATA_WIDTH-1:0]              FREQ_STEP,
	output reg [ARM_BUS_DATA_WIDTH-1:0]              ddc_adj_L,
	output reg [ARM_BUS_DATA_WIDTH-1:0]              ddc_adj_R,
	output reg                                        rst_ddc
	);
	//жclock_lockedϵͳʱӲʱdataΪ裬
	//⵱ûʱʱĴΪ0ʱdataARM
	
	reg [15:0] data_reg;
	assign data = data_reg;
	
	always @(csn or oen or lad_out  or addr[19])//or ram_data
	begin
		if(csn||oen)
			data_reg <= 16'bz;
		else if(addr[19])
			data_reg <= lad_out;
//		else if(addr[1])
//			data_reg <=16'bz ;//ram_data[31:16]
		else
			data_reg <=16'bz ;//ram_data[15:0]
	end

	//ʱͬź
//	always @(posedge clk)
//	begin
////		rst_arm <= rst_sw;  //modified by wxh ,0311
//		if(addr[19]==1'b0)
//			ram_addr <= addr[18:2];			//[17:2]
//		else
//			ram_addr <= ram_addr;
//	end
	
	always @(posedge clk)
	begin
		if(~csn)//Ƭѡ
		begin
			if(~oen)//ʹ
			begin
				if(addr[19])
				begin
					case(addr[18:1])//жһλֱӰ16λַ㣬ַû
					0:lad_out<=NUM_FRAME;
					5:lad_out<=ADC_L;     
					6:lad_out<=ADC_R;
					8:lad_out<=sm_data;
					9:lad_out<=sm_addr; 
					15:lad_out<={15'b0,ARM_DATA_READY};
					16:begin
						lad_out<=ARM_ADDR;
						//ARM_ADDR_reg   <=       ARM_ADDR_reg+1'b1;
					   end
					17:lad_out<=ARM_DATA;
					19:lad_out<={15'b0,DREADY};
					20:lad_out<=POWER_COM_OUT;
					25:lad_out<=PARA_OUT;
					
					26:lad_out<=SRC_ADDR[15:0];
					27:lad_out<=SRC_ADDR[31:16];
					28:lad_out<=SRC_ADDR[47:32];
				
					29:lad_out<=DEST_ADDR[15:0];
					30:lad_out<=DEST_ADDR[31:16];
					31:lad_out<=DEST_ADDR[47:32];
				
					32:lad_out<=CTRL;
					
					33:lad_out<=MAX_I_PRE[15:0];
					34:lad_out<=MAX_I_PRE[31:16];
					35:lad_out<=MAX_I_PRE[47:32];
					36:lad_out<=MAX_I_AFT[15:0];
					37:lad_out<=MAX_I_AFT[31:16];
					39:lad_out<=SCALED_COEFF_PRE_I;
					40:lad_out<=SCALED_COEFF_AFT_I;
					41:lad_out<=MAX_Q_PRE[15:0];
					42:lad_out<=MAX_Q_PRE[31:16];
					43:lad_out<=MAX_Q_PRE[47:32];
					44:lad_out<=MAX_Q_AFT[15:0];
					45:lad_out<=MAX_Q_AFT[31:16];
					47:lad_out<=SCALED_COEFF_PRE_Q;
					48:lad_out<=SCALED_COEFF_AFT_Q;
					49:lad_out<=MAX_U_PRE[15:0];
					50:lad_out<=MAX_U_PRE[31:16];
					51:lad_out<=MAX_U_PRE[47:32];
					52:lad_out<=MAX_U_AFT[15:0];
					53:lad_out<=MAX_U_AFT[31:16];
					55:lad_out<=SCALED_COEFF_PRE_U;
					56:lad_out<=SCALED_COEFF_AFT_U;
					57:lad_out<=MAX_V_PRE[15:0];
					58:lad_out<=MAX_V_PRE[31:16];
					59:lad_out<=MAX_V_PRE[47:32];
					60:lad_out<=MAX_V_AFT[15:0];
					61:lad_out<=MAX_V_AFT[31:16];
					63:lad_out<=SCALED_COEFF_PRE_V;
					64:lad_out<=SCALED_COEFF_AFT_V;
					65:lad_out<=MODE_SEL;
					
					66:begin
						lad_out<=FREQEQUA_RPARAL;
						//FREQEQUA_RADDR<=FREQEQUA_RADDR+1;
						end
					67:begin
						lad_out<=FREQEQUA_RPARAR;
						//FREQEQUA_RADDR<=FREQEQUA_RADDR+1;
						end
					68:lad_out<=FREQEQUA_RADDR;
					69:lad_out<=FREQEQUA_EN;
					70:lad_out<=FREQEQUA_WADDR;
					71:begin
						lad_out<=FREQEQUA_WPARA;
						//FREQEQUA_WADDR<=FREQEQUA_WADDR+1;
						end
					
					72:lad_out<=PARA_ADJ_I;
					73:lad_out<=PARA_ADJ_Q;
					74:lad_out<=PARA_ADJ_U;
					75:lad_out<=PARA_ADJ_V;
					
				//	76:lad_out<=realdelayA;
				//	77:lad_out<=realdelayB;
				//	78:lad_out<=realdelayC;
				//	79:lad_out<=realdelayD;
					
				//	80:lad_out<=delay_valueA;
				//	81:lad_out<=delay_valueB;
				//	82:lad_out<=delay_valueC;
				//	83:lad_out<=delay_valueD;
					
					84:lad_out<=ADC_SYNC_STATE;
					
					85:lad_out<=RST_REG;
					
				//	86:lad_out<=CAPTURE_OPERATE;
				//	87:lad_out<=CAPTURE_STATE;
				//	88:lad_out<=CAPTURE_ADDR;
				//	89:begin
				//		lad_out<={8'b0,CAPTURE_DATA};
				//		CAPTURE_ADDR <= CAPTURE_ADDR+1;
				//		end
				
					//UDPûɶ
					90:lad_out<=SRC_IP[15:0];
					91:lad_out<=SRC_IP[31:16];
					92:lad_out<=DEST_IP[15:0];
					93:lad_out<=DEST_IP[31:16];
					94:lad_out<=SRC_PORT[15:0];
					95:lad_out<=DEST_PORT[15:0];
					
					//DDC
					100:lad_out<=FREQ_STEP;
					101:lad_out<=ddc_adj_L;
					102:lad_out<=ddc_adj_R;
					103:lad_out<={15'b0,rst_ddc};
					104:lad_out   <=    max_ddc_L[15:0];
					105:lad_out   <=    max_ddc_L[31:16];
					106:lad_out   <=    max_ddc_L[47:32];
					107:lad_out   <=    max_ddc_R[15:0];
					108:lad_out   <=    max_ddc_R[31:16];
					109:lad_out   <=    max_ddc_R[47:32];
					
					1024:lad_out <= ADC_REG;
					1025:lad_out <= ADC_RD_BACK;
					1026:lad_out <= CLK_REG;
					1027:lad_out <= CLK_RD_BACK;
					
				   2048:lad_out <= adc_if_reset;
					2049:lad_out <= adc_if_state;
//					2050:lad_out <= realdelayA;
//					2051:lad_out <= realdelayB;
//					2052:lad_out <= realdelayC;
//					2053:lad_out <= realdelayD;
//					2054:lad_out <= realdelayCLKAB;
//					2055:lad_out <= realdelayCLKCD;
					2056:lad_out <= adc_snap_operate;
					2057:lad_out <= adc_snap_addr;
					2058:lad_out <={{(ARM_BUS_DATA_WIDTH-ADC_DATA_WIDTH){1'b0}},adc_snap_data};
					2059:lad_out <=adc_snap_state;
					
					default:lad_out<=16'b0;
					endcase
				end
			end
			else if((~wen)&&addr[19])//дʹ
			begin
				case(addr[18:1])
				0:NUM_FRAME<=data;
				9:sm_addr<=data;
				12:PPS_RST_IN<=data[0:0];
				16:ARM_ADDR<=data[(BITWIDTH+3):0];
				17:PARA<=data[15:0];
				18:PARA_ADDR<=data[10:0];
				19:ARM_ACK<=data[0:0];
				20:ARM_EN<=data[0:0];
				21:PARA_RADDR<=data[10:0];
				
				22:SRC_ADDR[15:0]<=data;
				23:SRC_ADDR[31:16]<=data;
				24:SRC_ADDR[47:32]<=data;
				
				25:DEST_ADDR[15:0]<=data;
				26:DEST_ADDR[31:16]<=data;
				27:DEST_ADDR[47:32]<=data;
				
				32:CTRL<=data;
				
				39:SCALED_COEFF_PRE_I<=data;
				40:SCALED_COEFF_AFT_I<=data;
				47:SCALED_COEFF_PRE_Q<=data;
				48:SCALED_COEFF_AFT_Q<=data;
				55:SCALED_COEFF_PRE_U<=data;
				56:SCALED_COEFF_AFT_U<=data;
				63:SCALED_COEFF_PRE_V<=data;
				64:SCALED_COEFF_AFT_V<=data;
				65:MODE_SEL<=data;
				
				68:FREQEQUA_RADDR<=data;
				69:FREQEQUA_EN<=data;
				70:FREQEQUA_WADDR<=data;
				71:FREQEQUA_WPARA<=data;
				
				72:PARA_ADJ_I<=data;
				73:PARA_ADJ_Q<=data;
				74:PARA_ADJ_U<=data;
				75:PARA_ADJ_V<=data;
				
			//	80:delay_valueA<=data;
			//	81:delay_valueB<=data;
			//	82:delay_valueC<=data;
			//	83:delay_valueD<=data;
				
				85:RST_REG<=data;
				
			//	86:CAPTURE_OPERATE<=data;
			//	88:CAPTURE_ADDR<=data;
			
				90:SRC_IP[15:0]<=data;
				91:SRC_IP[31:16]<=data;
				92:DEST_IP[15:0]<=data;
				93:DEST_IP[31:16]<=data;
				94:SRC_PORT[15:0]<=data;
				95:DEST_PORT[15:0]<=data;
				
				100: FREQ_STEP <= data;
				101: ddc_adj_L <= data;
				102: ddc_adj_R <= data;
				103: rst_ddc <= data[0];
				
				1024:ADC_REG <= data;
				1026:CLK_REG <= data;
				
				2048:adc_if_reset<=data;
//				2050:delay_valueA<=data;
//				2051:delay_valueB<=data;
//				2052:delay_valueC<=data;
//				2053:delay_valueD<=data;
//				2054:delay_valueCLKAB<=data;
//				2055:delay_valueCLKCD<=data;
				2056:adc_snap_operate<=data;
				2057:adc_snap_addr<=data;
				endcase
			end
			else//ûжд
				lad_out<=16'b0;
		end
		else//ûƬѡ
			lad_out<=16'b0;
	end
endmodule
