`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:25:50 11/30/2019 
// Design Name: 
// Module Name:    adc_sync 
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
module adc_sync #(
		parameter DATA_WIDTH = 8
)(
	clk, // input clk
	rst, // input rst
	din, // input  din
	dout // output  dout
    );
//*************************************//
//************ inputs *****************//
//*************************************//
	input 							clk;
	input 							rst;
	input [DATA_WIDTH-1 : 0]	din;
//*************************************//
//************ outputs ****************//
//*************************************//
	output [DATA_WIDTH-1 : 0]	dout;
	
genvar j;
generate
for (j=0;j < DATA_WIDTH; j=j+1) 
	   FDRE #(
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
