`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:21:31 12/29/2017 
// Design Name: 
// Module Name:    delay_line 
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
module delay_line #(
	parameter DATA_WIDTH = 8,
	parameter PIPELINE_DEPTH = 8
)(
	input	[0:0]				clk,
	input   [0:0]   			nd,
	input	[DATA_WIDTH-1:0]	din,
	output	[DATA_WIDTH-1:0]	q
    );

	reg		[DATA_WIDTH-1:0]	din_reg[PIPELINE_DEPTH-1:0];
	
	reg     [PIPELINE_DEPTH-1:0] j;
	
	initial begin
		for (j=0;j < PIPELINE_DEPTH; j=j+1)
			din_reg[j]=0;
	end
	
	assign  q = din_reg[PIPELINE_DEPTH-1];
	
	always @(posedge clk)
	begin
		if (nd==1'b1)
			din_reg[0] <= din;
		else
			din_reg[0] <= din_reg[0];
	end
	
	genvar i;
	generate
		for (i=1; i < PIPELINE_DEPTH; i=i+1) 
		begin: pipe
			always @(posedge clk)
			begin
				din_reg[i] <= din_reg[i-1];
			end
		end
    endgenerate
endmodule
