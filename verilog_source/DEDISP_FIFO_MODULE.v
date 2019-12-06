`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:03:36 10/23/2015 
// Design Name: 
// Module Name:    DEDISP_MODULE 
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
module DEDISP_FIFO_MODULE(
	input rst,
	input clk,
	input [23:0]power_com_in,
	input [39:0]timer_flag,
	input dready,
	input fifo_rd_clk,
	output [15:0]fifo_data_out,
	output fifo_empty
    );
					
reg [23:0]power_com_in_reg;
reg [39:0]timer_flag_reg;
//dready信号延时一个clk，用于检测上升沿
reg dready_reg;
always @(posedge clk)
	begin
		if(rst)
				dready_reg <= 0;
		else
				dready_reg <= dready;
	end
//数据缓存下来
always @(posedge clk)
	begin
		if(rst)
			begin
				power_com_in_reg <= 0;
				timer_flag_reg <= 0;
			end
		else if(dready==1)
			begin
				power_com_in_reg <= power_com_in;
				timer_flag_reg <= timer_flag;
			end
	end
//简易版状态机的状态改变及相应操作.同时帧计数器加1
reg [3:0]cnt_state;
reg fifo_clk;
reg [15:0]data;
reg [10:0]cnt_frame;
always @(posedge clk)
	begin
		if(rst)
			begin
				cnt_state <= 0;
				fifo_clk <= 0;
				data <= 0;
				cnt_frame <= 0;
			end
		else if(dready==1 && dready_reg==0)
			begin
				cnt_state <= 0;
				fifo_clk <= 0;
				data <= 0;
				cnt_frame <= cnt_frame+1;
			end	
		else if(cnt_state==0)
			begin
				data <= 65535;
				fifo_clk <= 0;
				cnt_state <= 1;
			end
		else if(cnt_state==1)
			begin
				data <= 65535;
				if(cnt_frame==0)
					fifo_clk <= 1;
				else
					fifo_clk <= 0;
				cnt_state <= 2;
			end
		else if(cnt_state==2)
			begin
				data <= {8'b0,timer_flag[39:32]};
				fifo_clk <= 0;
				cnt_state <= 3;
			end
		else if(cnt_state==3)
			begin
				data <= {8'b0,timer_flag[39:32]};
				if(cnt_frame==0)
					fifo_clk <= 1;
				else
					fifo_clk <= 0;
				cnt_state <= 4;
			end
		else if(cnt_state==4)
			begin
				data <= timer_flag[31:16];
				fifo_clk <= 0;
				cnt_state <= 5;
			end
		else if(cnt_state==5)
			begin
				data <= timer_flag[31:16];
				if(cnt_frame==0)
					fifo_clk <= 1;
				else
					fifo_clk <= 0;
				cnt_state <= 6;
			end
		else if(cnt_state==6)
			begin
				data <= timer_flag[15:0];
				fifo_clk <= 0;
				cnt_state <= 7;
			end
		else if(cnt_state==7)
			begin
				data <= timer_flag[15:0];
				if(cnt_frame==0)
					fifo_clk <= 1;
				else
					fifo_clk <= 0;
				cnt_state <= 8;
			end
		else if(cnt_state==8)
			begin
				data <= power_com_in[15:0];
				fifo_clk <= 0;
				cnt_state <= 9;
			end
		else if(cnt_state==9)
			begin
				data <= power_com_in[15:0];
				fifo_clk <= 1;
				
				cnt_state <= 10;
			end
		else if(cnt_state==10)
			begin
				data <= 0;
				fifo_clk <= 0;
				cnt_state <= 10;
			end		
	end
	
DEDISP_FIFO de_disp_fifo_data(
  .rst(rst), // input rst
  .wr_clk(fifo_clk), // input wr_clk
  .rd_clk(fifo_rd_clk), // input rd_clk fifo_rd_
  .din(data), // input [23 : 0] din
  .wr_en(1), // input wr_enfifo_en
  .rd_en(1), // input rd_en
  .dout(fifo_data_out), // output [23 : 0] dout
  .full(), // output full
  .empty(fifo_empty) // output empty
);


endmodule
