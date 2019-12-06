`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:09:36 10/16/2016 
// Design Name: 
// Module Name:    adjust_32bit 
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
module adjust_32bit(
	input clk,
	
	input [15:0] scaled_coeff,
	input [31:0] para_in,
	
	output [15:0] para_out
	);
reg [31:0] dout_reg_i;
reg [31:0] dout_reg_i_temp;
	
always @(posedge clk)          
	begin      
	   dout_reg_i_temp<=para_in;	
		dout_reg_i <= dout_reg_i_temp<<scaled_coeff;
	end   
	
assign para_out=dout_reg_i[31:16]; 
//Digitial_Gain_32bit aft_digitial_gain (
//  .clk(clk), // input clk
//  .a(para_in), // input [31 : 0] a
//  .b(scaled_coeff), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(para_out) // output [7 : 0] p
//);
endmodule
