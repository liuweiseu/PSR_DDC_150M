`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:09 05/15/2017 
// Design Name: 
// Module Name:    Cal_Power 
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
module Cal_Power #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	
	input en_sync_in,
	input [(BITWIDTH+1):0]cnt_sync_in,

	
	input [15:0]PowerIn_R,
	input [15:0]PowerIn_L,
	
	output reg en_sync_out,
	output reg [(BITWIDTH+1):0]cnt_sync_out,
	
	output [15:0]PowerOut
    );

Power_Adder Power_Adder (
  .a(PowerIn_R), // input [7 : 0] a
  .b(PowerIn_L), // input [7 : 0] b
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .s(PowerOut) // output [7 : 0] s
);

always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_out<=0;
				cnt_sync_out<=0;
			end
		else
			begin
				en_sync_out<=en_sync_in;
				cnt_sync_out<=cnt_sync_in;
			end
	end
endmodule
