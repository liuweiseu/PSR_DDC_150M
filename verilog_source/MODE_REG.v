`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:25 07/28/2017 
// Design Name: 
// Module Name:    MODE_REG 
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
module MODE_REG(
	input clk,
	input rst,
	input [15:0]mode,
	output reg[1:0]width_mode,
	output reg[2:0]cal_mode,
	output reg[7:0]package_len
    );

always @(posedge clk)
			begin
				width_mode<=mode[12:11];
				cal_mode<=mode[10:8];
				package_len<=mode[7:0];
			end
endmodule
