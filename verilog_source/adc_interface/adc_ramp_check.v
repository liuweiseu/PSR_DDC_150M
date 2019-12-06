`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2017-7-19 10:43:45
// Design Name: 
// Module Name:    adc_ramp_check 
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
module adc_ramp_check #(
	parameter ADC_DATA_WIDTH = 8,
	parameter PARALLEL_PATH_NUM = 4		//һ·AHAL֧·
	)	
	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	
	(
		clk,
		detect_in,
		adc_sync_all_bit_i,		//ӵλλѾȷĶ˳У{A4,A3,A2,A1}
		ADC_Is_Ramp
	);
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	localparam PARALLEL_PATH_NUM_PER_CORE = PARALLEL_PATH_NUM*2;	//ΪHL·
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                                       clk;
	input                                                       detect_in;
	input   [ADC_DATA_WIDTH*PARALLEL_PATH_NUM_PER_CORE-1:0]     adc_sync_all_bit_i;
	
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	
	output                                                      ADC_Is_Ramp;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	reg                                                         ADC_Is_Ramp_detect_reg;
	reg                                                         ADC_Is_Ramp_reg;
	reg                                                         detect_reg;
	reg     [ADC_DATA_WIDTH-1:0]                                adc_sync_reg[0:PARALLEL_PATH_NUM_PER_CORE-1];
	//wire    [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_plus1[0:PARALLEL_PATH_NUM_PER_CORE-2];	//дĺôȷ˼ӷλᱨwarning
	//wire    [PARALLEL_PATH_NUM_PER_CORE-2:0]                    neighbour_bit_is_ramp_all;
	reg    [ADC_DATA_WIDTH-1:0]                                adc_sync_reg_plus1[0:PARALLEL_PATH_NUM_PER_CORE-2];	//дĺôȷ˼ӷλᱨwarning
	reg    [PARALLEL_PATH_NUM_PER_CORE-2:0]                    neighbour_bit_is_ramp_all;
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	genvar j;
	generate
		for (j=0;j < PARALLEL_PATH_NUM_PER_CORE-1; j=j+1) 
		begin: assign_adc_sync_reg_plus1
			//assign adc_sync_reg_plus1[j] = adc_sync_reg[j]+1'b1;
			always @(posedge clk)
				adc_sync_reg_plus1[j] <= adc_sync_reg[j]+1'b1;
		end
	endgenerate
	
	
	genvar k;
	generate
		for (k=0;k < PARALLEL_PATH_NUM_PER_CORE-1; k=k+1) 
		begin: assign_neighbour_bit_is_ramp
			//assign neighbour_bit_is_ramp_all[k] = (adc_sync_reg[k+1]==adc_sync_reg_plus1[k]);
			always @(posedge clk)
				neighbour_bit_is_ramp_all[k] <= (adc_sync_reg[k+1]==adc_sync_reg_plus1[k]);
		end
	endgenerate
	
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign ADC_Is_Ramp = ADC_Is_Ramp_reg;
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	
	//***** ݻ *****//		
	genvar i;
	generate
	for (i=0;i < PARALLEL_PATH_NUM_PER_CORE; i=i+1) 
	begin: assign_adc_sync_reg
		always @(posedge clk)
		begin
			adc_sync_reg[i] <= adc_sync_all_bit_i[((i+1)*ADC_DATA_WIDTH-1):i*ADC_DATA_WIDTH];
		end	
	end
	endgenerate
	
	//***** dectec *****//
	always @(posedge clk)
	begin
		detect_reg <= detect_in;
	end
	
	//***** dectec_inһμ *****//	
	always @(posedge clk)
	begin
		if ((detect_reg==1'b0) && (detect_in==1'b1))		//rising edge
		begin
			ADC_Is_Ramp_detect_reg <= 1'b1;		//ʼΪ߱ʾ룬룬ͻᱻ
		end
		else if (neighbour_bit_is_ramp_all=={(PARALLEL_PATH_NUM_PER_CORE-1){1'b1}})
				ADC_Is_Ramp_detect_reg <= ADC_Is_Ramp_detect_reg;	//ͨ룬
			else 
				ADC_Is_Ramp_detect_reg <= 1'b0;
	end

	//***** dectec_inһμ *****//	
	always @(posedge clk)
	begin
		if ((detect_reg==1'b1) && (detect_in==1'b0))		//falling edge
		begin
			ADC_Is_Ramp_reg <= ADC_Is_Ramp_detect_reg;
		end
		else
		begin
			ADC_Is_Ramp_reg <= ADC_Is_Ramp_reg;
		end
	end
	
endmodule
