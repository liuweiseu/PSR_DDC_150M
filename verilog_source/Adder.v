`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:	WXQ
// 
// Create Date:    20:47:37 05/23/2012 
// Design Name: 
// Module Name:    Adder 
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
module Adder#(
	parameter DDC_OUTPUT_WIDTH = 34,
	parameter INPUT_WIDTH = 31
	)(
    input [INPUT_WIDTH-1:0] firout_150M_1i,
    input [INPUT_WIDTH-1:0] firout_150M_1q,
    input [INPUT_WIDTH-1:0] firout_150M_2i,
    input [INPUT_WIDTH-1:0] firout_150M_2q,
    input [INPUT_WIDTH-1:0] firout_150M_3i,
    input [INPUT_WIDTH-1:0] firout_150M_3q,
    input [INPUT_WIDTH-1:0] firout_150M_4i,
    input [INPUT_WIDTH-1:0] firout_150M_4q,
    input [INPUT_WIDTH-1:0] firout_150M_5i,
    input [INPUT_WIDTH-1:0] firout_150M_5q,
    input [INPUT_WIDTH-1:0] firout_150M_6i,
    input [INPUT_WIDTH-1:0] firout_150M_6q,
    input [INPUT_WIDTH-1:0] firout_150M_7i,
    input [INPUT_WIDTH-1:0] firout_150M_7q,
    input [INPUT_WIDTH-1:0] firout_150M_8i,
    input [INPUT_WIDTH-1:0] firout_150M_8q,
    input clk,
	 //input sclr,	//2015-9-3 BY ZTY
    output [DDC_OUTPUT_WIDTH-1:0] data_150M_i,
    output [DDC_OUTPUT_WIDTH-1:0] data_150M_q
    );
	
	wire [INPUT_WIDTH:0] firout_150M_12i;
	wire [INPUT_WIDTH:0] firout_150M_34i;
	wire [INPUT_WIDTH:0] firout_150M_56i;
	wire [INPUT_WIDTH:0] firout_150M_78i;
	
	wire [INPUT_WIDTH+1:0] firout_150M_1234i;
	wire [INPUT_WIDTH+1:0] firout_150M_5678i;
	
	wire [INPUT_WIDTH+2:0] firout_150M_i;
	
	wire [INPUT_WIDTH:0] firout_150M_12q;
	wire [INPUT_WIDTH:0] firout_150M_34q;
	wire [INPUT_WIDTH:0] firout_150M_56q;
	wire [INPUT_WIDTH:0] firout_150M_78q;
	
	wire [INPUT_WIDTH+1:0] firout_150M_1234q;
	wire [INPUT_WIDTH+1:0] firout_150M_5678q;
	
	wire [INPUT_WIDTH+2:0] firout_150M_q;
	
	assign data_150M_i = firout_150M_i[INPUT_WIDTH+2:INPUT_WIDTH+3-DDC_OUTPUT_WIDTH];
	assign data_150M_q = firout_150M_q[INPUT_WIDTH+2:INPUT_WIDTH+3-DDC_OUTPUT_WIDTH];

	Adder2 adder12 (
		.a(firout_150M_1i), // Bus [27 : 0] 
		.b(firout_150M_2i), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_12i)); // Bus [28 : 0] 
	Adder2 adder34 (
		.a(firout_150M_3i), // Bus [27 : 0] 
		.b(firout_150M_4i), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_34i)); // Bus [28 : 0] 	
	Adder2 adder56 (
		.a(firout_150M_5i), // Bus [27 : 0] 
		.b(firout_150M_6i), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_56i)); // Bus [28 : 0] 
	Adder2 adder78 (
		.a(firout_150M_7i), // Bus [27 : 0] 
		.b(firout_150M_8i), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_78i)); // Bus [28 : 0]
	Adder3 adder1234 (
		.a(firout_150M_12i), // Bus [28 : 0] 
		.b(firout_150M_34i), // Bus [28 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_1234i)); // Bus [29 : 0]  	
	Adder3 adder5678 (
		.a(firout_150M_56i), // Bus [28 : 0] 
		.b(firout_150M_78i), // Bus [28 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_5678i)); // Bus [29 : 0] 	
	Adder4 adder12345678 (
		.a(firout_150M_1234i), // Bus [29 : 0] 
		.b(firout_150M_5678i), // Bus [29 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_i)); // Bus [30 : 0]		
		
	Adder2 adder12q (
		.a(firout_150M_1q), // Bus [27 : 0] 
		.b(firout_150M_2q), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_12q)); // Bus [28 : 0] 
	Adder2 adder34q (
		.a(firout_150M_3q), // Bus [27 : 0] 
		.b(firout_150M_4q), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_34q)); // Bus [28 : 0] 	
	Adder2 adder56q (
		.a(firout_150M_5q), // Bus [27 : 0] 
		.b(firout_150M_6q), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_56q)); // Bus [28 : 0] 
	Adder2 adder78q (
		.a(firout_150M_7q), // Bus [27 : 0] 
		.b(firout_150M_8q), // Bus [27 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_78q)); // Bus [28 : 0]
	Adder3 adder1234q (
		.a(firout_150M_12q), // Bus [28 : 0] 
		.b(firout_150M_34q), // Bus [28 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_1234q)); // Bus [29 : 0]  	
	Adder3 adder5678q (
		.a(firout_150M_56q), // Bus [28 : 0] 
		.b(firout_150M_78q), // Bus [28 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_5678q)); // Bus [29 : 0] 	
	Adder4 adder12345678q (
		.a(firout_150M_1234q), // Bus [29 : 0] 
		.b(firout_150M_5678q), // Bus [29 : 0] 
		.clk(clk),
		//.sclr(sclr), 
		.s(firout_150M_q)); // Bus [30 : 0]		
		
		
	integer ddc_150_outfile;
	initial 
	begin
	ddc_150_outfile = $fopen("E:/6-RSR-1G/8-liuwei/PSR_RGMII_V2.7.4.1-150MBW-512_V1.4/tb_rzlt/adder_150_iq.txt");
	if (!ddc_150_outfile)
		$display("fail to open adder_150_iq.txt");
	end
	
	always @(posedge clk)
	begin
		$fdisplay(ddc_150_outfile,"%d %d",$signed(data_150M_i),$signed(data_150M_q));
	end
endmodule
