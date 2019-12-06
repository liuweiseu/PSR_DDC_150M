`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:58:47 11/22/2013 
// Design Name: 
// Module Name:    adjust 
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
//该模块对数据延时2个clk输出
module adjust_48bit(
	input clk,
	input rst,
	
	input [15:0] scaled_coeff,
	input [47:0] para_in,
	
	output [15:0] para_out
	);
reg [47:0] dout_reg_i;
reg [47:0] dout_reg_i_temp;
	
always @(posedge clk)          
	begin     
		if(rst)
			begin
				dout_reg_i_temp<=0;	
				dout_reg_i <= 0;
			end
		else
			begin
				dout_reg_i_temp<=para_in;	
				dout_reg_i <= (dout_reg_i_temp<<scaled_coeff);
			end
	end   

assign para_out=dout_reg_i[47:32]; 

//Digital_Gain Pre_Digitial_Gain (
//  .clk(clk), // input clk
//  .a(para_in), // input [47 : 0] a
//  .b(scaled_coeff), // input [15 : 0] b
//  .sclr(rst), // input sclr
//  .p(para_out) // output [15 : 0] p
//);

endmodule
