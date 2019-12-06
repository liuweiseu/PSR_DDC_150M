`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:49:05 04/25/2017 
// Design Name: 
// Module Name:    LED 
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
module LED(
	input clk,
	input rst,
	
	output reg LED0,
	output reg LED1
    );

	 reg  [28:0] LED_CNT0;
	 reg  [28:0] LED_CNT1;
	 
	 always @(posedge clk)		
	 begin
		if(rst)
		begin
			LED_CNT0<=29'd0;
			LED0<=1'b0;
		end
		else if(LED_CNT0==29'd150000000)
		begin
			LED0<=~LED0;
			LED_CNT0<=29'd0;
		end
		else
			LED_CNT0<=LED_CNT0+29'd1;
	 end
	 
	 always @(posedge clk)		
	 begin
		if(rst)
		begin
			LED_CNT1<=29'd0;
			LED1<=1'b1;
		end
		else if(LED_CNT1==29'd150000000)
		begin
			LED1<=~LED1;
			LED_CNT1<=29'd0;
		end
			else 
			LED_CNT1<=LED_CNT1+29'd1;
	 end
endmodule
