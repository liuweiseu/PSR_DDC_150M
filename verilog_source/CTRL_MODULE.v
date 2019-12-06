`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:05:46 02/26/2017 
// Design Name: 
// Module Name:    CTRL_MODULE 
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
module CTRL_MODULE(
	input clk,
	input rst,
	input [15:0]ctrl,
	output reg rgmii_ctrl
    );
always @(posedge clk)
			begin
				rgmii_ctrl<=ctrl[0:0];
			end
endmodule
