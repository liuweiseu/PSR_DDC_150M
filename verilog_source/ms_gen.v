`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:29:22 12/03/2019 
// Design Name: 
// Module Name:    ms_gen 
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
module ms_gen(
	rst,
	clk,
	ms_out
    );

input rst;
input clk;
output ms_out;

reg [20:0] cnt_frame; //13.98ms on 150MHz
reg ms_inner;
wire rst_ignore;
assign rst_ignore = 0;
always@(posedge clk)
  begin
   if (rst_ignore)
      cnt_frame<=0;			//64'd2
	else
   	cnt_frame<=cnt_frame+1'b1;
	end

always@(posedge clk)
begin
  if (rst_ignore)
     ms_inner  <= 1'b0;
  else if (	cnt_frame == 0)
     ms_inner<=1'b1;
  else if (	cnt_frame == 100)  
     ms_inner <=1'b0;
  else 
     ms_inner <=ms_inner;
 end
 
assign ms_out = ms_inner;

endmodule
