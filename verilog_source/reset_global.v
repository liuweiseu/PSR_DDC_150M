`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MYF
// 
// Create Date:    10:46:15 12/21/2013 
// Design Name: 
// Module Name:    reset_global 
// Project Name: 	异步复位同步释放 顶层模块
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
module reset_global(
    input clk,		//同步时钟
    input rst_asyn,	//异步复位输入
    output reg rst_out	//同步复位输出
    );
	
	reg [1:0] rff;
	/*			//2015-7-17 BY ZTY
	always @ (posedge clk , posedge rst_asyn)
	begin	
	if (rst_asyn) 
		{rst_out,rff}<= 2'b11;	
	else 
		{rst_out,rff} <={rff,1'b0};
	end
	*/
	//2015-7-17 BY ZTY
	always @ (posedge clk or posedge rst_asyn)
	begin	
	if (rst_asyn) 
		rff<= {1'b1,1'b1};	
	else
		rff<={rff[0],1'b0};
	end
	
	always @ (posedge clk)
	begin	
		rst_out<= rff[1];
	end
endmodule
