`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:33 10/16/2016 
// Design Name: 
// Module Name:    Get_Max_32bit 
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
module Get_Max_32bit(
	input clk,
	input rst,
	//input ms_in,
	
	input [31:0]data0,
//	input [31:0]data1,
//	input [31:0]data2,
//	input [31:0]data3,
	
	output [31:0]max
    );
	 
wire ms_in;
ms_gen U_ms_gen(
	.clk(clk),
	.rst(rst),
	.ms_out(ms_in)
	);
	
reg [31:0] max0=0;
//reg [31:0] max1=0;
//reg [31:0] max2=0;
//reg [31:0] max3=0;
reg [31:0] inner_max0=0;
//reg [31:0] inner_max1=0;
//reg [31:0] inner_max2=0;
//reg [31:0] inner_max3=0;
//reg [31:0] max_temp0,max_temp1,max_temp2;

reg ms_in_reg1=0;  
reg ms_in_reg2=0;

 
		
always @(posedge clk)
	begin
		if(rst)
			begin
				ms_in_reg1<=0;   
				ms_in_reg2<=0;
			end
		else
			begin
				ms_in_reg1<=ms_in;   
				ms_in_reg2<=ms_in_reg1;
			end
	end

always @(posedge clk)
	begin
		if(rst)
			begin
				max0<=0;
				inner_max0<=0;
			end
		else if((ms_in_reg2==0) && (ms_in_reg1==1)) 
			begin
				max0 <= inner_max0;                                                                                              		
				inner_max0 <= 0;  
			end
		else if(data0 > inner_max0)
			begin
				inner_max0 <= data0;
				max0<=max0;
			end
		else
			begin
				inner_max0 <= inner_max0;
				max0<=max0;
			end	
	end
assign max = max0;
//always @(posedge clk)
//	begin
//		if(rst)
//			begin
//				max1<=0;
//				inner_max1<=0;
//			end
//		else if((ms_in_reg2==0) && (ms_in_reg1==1)) 
//			begin
//				max1 <= inner_max1;                                                                                              		
//				inner_max1 <= 0;  
//			end
//		else if(data1 > inner_max1)
//			begin
//				inner_max1 <= data1;
//				max1<=max1;
//			end
//		else
//			begin
//				inner_max1 <= inner_max1;
//				max1<=max1;
//			end	
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//			begin
//				max2<=0;
//				inner_max2<=0;
//			end
//		else if((ms_in_reg2==0) && (ms_in_reg1==1)) 
//			begin
//				max2 <= inner_max2;                                                                                              		
//				inner_max2 <= 0;  
//			end
//		else if(data2 > inner_max2)
//			begin
//				inner_max2 <= data2;
//				max2<=max2;
//			end
//		else
//			begin
//				inner_max2 <= inner_max2;
//				max2<=max2;
//			end	
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//			begin
//				max3<=0;
//				inner_max3<=0;
//			end
//		else if((ms_in_reg2==0) && (ms_in_reg1==1)) 
//			begin
//				max3 <= inner_max3;                                                                                              		
//				inner_max3 <= 0;  
//			end
//		else if(data3 > inner_max3)
//			begin
//				inner_max3 <= data3;
//				max3<=max3;
//			end
//		else
//			begin
//				inner_max3 <= inner_max3;
//				max3<=max3;
//			end	
//	end
//------------------------------------------
//always@(posedge clk)
//	begin
//		if (rst)
//			max_temp0<=0;		
//		else if(max0> max1)
//			max_temp0<=max0;
//		else
//			max_temp0<=max1;
//	end
// 
//always@(posedge clk)
//	begin
//		if (rst)
//			max_temp1<=0;		
//		else if( max2> max3)
//			max_temp1<=max2;
//		else
//			max_temp1<=max3;
//	end
// 
// always@(posedge clk)
//begin
//  if (rst)
//	   max_temp2<=0;		
//  else if( max_temp0> max_temp1)
//      max_temp2<=max_temp0;
//  else
//      max_temp2<=max_temp1;
// end
////-------------------------------------------------------	
//assign max = max_temp2;

endmodule

