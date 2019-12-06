`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:44 07/26/2017 
// Design Name: 
// Module Name:    WIDTH_SEL 
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
 module WIDTH_SEL(
	input clk,
	input rst,
	
	input en_sync_in,
	input [5:0]cnt_sync_in, //[10:0]
	input [15:0]data_in,
	
	input [1:0]width_sel,		//位宽选择
	
	output reg en_sync_out,
	output reg [4:0]cnt_sync_out, //[7:0]
	output reg [15:0]data_out
    );
//做一个1bit计数器，当计数为1时，将输入数据缓存下来
reg cnt;
always @(posedge clk)
	begin
		if(rst)
			cnt<=0;
		else if(en_sync_in==1)
			cnt<=cnt+1;
		else
			cnt<=0;
	end
	
reg [15:0]data_temp;
always @(posedge clk)
	begin
		if(cnt==0)
			data_temp<=data_in;	
	end
reg en_sync_temp;	
reg [7:0]cnt_sync_temp;
always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_out<=0;
				cnt_sync_out<=0;
				en_sync_temp<=0;
				cnt_sync_temp<=0;
				data_out<=0;
			end
		else if(width_sel==1)
			begin
				en_sync_temp<=en_sync_in;
				cnt_sync_temp<=cnt_sync_in[4:0];//[7:0]
				en_sync_out<=en_sync_temp;
				cnt_sync_out<=cnt_sync_temp;
				data_out<=data_in;
			end
		else if(width_sel==0)
			begin
				if(cnt==1)
					begin
						en_sync_temp<=en_sync_in;
						cnt_sync_temp<=cnt_sync_in[5:1]; //[8:1]
						en_sync_out<=en_sync_temp;
						cnt_sync_out<=cnt_sync_temp;
						data_out<={data_temp[15:8],data_in[15:8]};
					end
				else
					begin
						en_sync_temp<=en_sync_temp;
						cnt_sync_temp<=cnt_sync_temp;
						en_sync_out<=en_sync_out;
						cnt_sync_out<=cnt_sync_out;
					end
			end
	end
endmodule

