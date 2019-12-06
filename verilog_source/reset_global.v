`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MYF
// 
// Create Date:    10:46:15 12/21/2013 
// Design Name: 
// Module Name:    reset_global 
// Project Name: 	�첽��λͬ���ͷ� ����ģ��
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
    input clk,		//ͬ��ʱ��
    input rst_asyn,	//�첽��λ����
    output reg rst_out	//ͬ����λ���
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
