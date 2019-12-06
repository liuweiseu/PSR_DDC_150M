`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:00 12/01/2019 
// Design Name: 
// Module Name:    delay_one_cycle 
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
module delay_one_cycle #(
	parameter ADC_DATA_WIDTH = 8
)
	//*************************************//
	//************ Ports ******************//
	//*************************************//
(
	clk,
	rst,
	din,
	dout
);
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
	input																clk;
	input 															rst;
	input		[PARALLEL_PATH_NUM*ADC_DATA_WIDTH-1 : 0]	din;
	//*************************************//
	//************ outputs ****************//
	//*************************************//
	output	[PARALLEL_PATH_NUM*ADC_DATA_WIDTH-1 : 0]	dout;

genvar j;
generate
for (j=0;j < (PARALLEL_PATH_NUM*ADC_DATA_WIDTH); j=j+1) 
	   FDRE #( //FDRE 
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) U_FDRE (
      .Q(dout[j]),      // 1-bit Data output
      .C(clk),      // 1-bit Clock input
      .CE(1),    // 1-bit Clock enable input
      .R(rst),      // 1-bit Synchronous reset input
      .D(din[j])       // 1-bit Data input
   );
endgenerate

endmodule
