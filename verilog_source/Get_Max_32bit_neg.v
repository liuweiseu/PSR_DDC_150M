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
module Get_Max_32bit_neg(
	input clk,
	input rst,
	input ms_in,
	
	input [31:0]data0,
//	input [31:0]data1,
//	input [31:0]data2,
//	input [31:0]data3,
	
	output [31:0]max
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

reg [31:0]data0_temp;//,data1_temp,data2_temp,data3_temp;
//ȡ����ֵ
always @(posedge clk)
	begin
		if(rst)
			data0_temp<=0;
		else if(data0[31])
			data0_temp<={1'b0,~(data0[30:0])};
		else
			data0_temp<=data0;
	end

//always @(posedge clk)
//	begin
//		if(rst)
//			data1_temp<=0;
//		else if(data1[31])
//			data1_temp<={1'b0,~(data1[30:0])};
//		else
//			data1_temp<=data1;
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//			data2_temp<=0;
//		else if(data2[31])
//			data2_temp<={1'b0,~(data2[30:0])};
//		else
//			data2_temp<=data2;
//	end
//	
//always @(posedge clk)
//	begin
//		if(rst)
//			data3_temp<=0;
//		else if(data3[31])
//			data3_temp<={1'b0,~(data3[30:0])};
//		else
//			data3_temp<=data3;
//	end



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
		else if(data0_temp > inner_max0)
			begin
				inner_max0 <= data0_temp;
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
//		else if(data1_temp > inner_max1)
//			begin
//				inner_max1 <= data1_temp;
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
//		else if(data2_temp > inner_max2)
//			begin
//				inner_max2 <= data2_temp;
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
//		else if(data3_temp > inner_max3)
//			begin
//				inner_max3 <= data3_temp;
//				max3<=max3;
//			end
//		else
//			begin
//				inner_max3 <= inner_max3;
//				max3<=max3;
//			end	
//	end
////------------------------------------------
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

