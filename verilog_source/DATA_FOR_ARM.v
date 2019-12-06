`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:59 09/17/2015 
// Design Name: 
// Module Name:    DATA_FOR_ARM 
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
/***********************************思路************************************
思路：刚开始RAM写数据使能，写满后，写使能拉低，data_ready脚输出ready信号，告诉ARM数据已准备好，
ARM检测到该信号后，开始给一个地址读一个数据，当地址给到2047时，恢复写使能
*写数据时应当注意,应当检测到en_sync_in的上升沿，方可开始写入数据，否则可能从数据的中间开始写入
*data_ready信号与写使能接在一起，为高时，表明数据未写完，为低时，表明数据写完
****************************************************************************/
//////////////////////////////////////////////////////////////////////////////////
module DATA_FOR_ARM#(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(
	input clk,
	input rst,
	input [15:0]data_in,
	input en_sync_in,			//必须比数据快一个周期，如果使能信号与数据一起到达，必须在模块内将数据延时一个clk
	output reg data_ready,	//与写使能脚相连
	input [(BITWIDTH+3):0]arm_addr,
	output [15:0]arm_data
    );
reg [(BITWIDTH+3):0]addr_in;//写地址
reg en_sync_in_reg;//en_sync_in的一个clk延时
reg addr_in_en;//写地址使能，该寄存器为1时，写地址才可以累加
//en_sync_in_reg赋值
always @(posedge clk)
	begin
		if(rst)
			en_sync_in_reg <=0;
		else 
			en_sync_in_reg <=en_sync_in;
	end
	//写使能置位时，检测到en_sync_in的上升沿，开启写地址使能；当写地址加到2047时，表明数据写完，此时将关闭写使能
always @(posedge clk)
	begin
		if(rst)
			addr_in_en <=0;
		else if((en_sync_in_reg==0) && (en_sync_in==1) &&(data_ready==1))
			addr_in_en <=1;
		else if(addr_in==(4*FFT_POINT-1))
			addr_in_en <=0;
	end
//当arm传过来的地址等于2047时，表明数据已取完，此时将写使能置位，等待开始下轮存数；下一轮存满后要拉低
always @(posedge clk)
	begin
		if(rst)
			data_ready <=1'b0;
		else if(arm_addr==(4*FFT_POINT-1))
			data_ready <=1'b1;
		else if(addr_in==(4*FFT_POINT-1))
			data_ready <=1'b0;
	end
//addr_in赋值	
always @(posedge clk)
	begin
		if(rst)
			addr_in <=0;
		else if(addr_in_en)
			addr_in<=addr_in+1;
	end
ARM_DATA U10_arm_data (
  .clka(clk), // input clka
  .ena(1'b1), // input ena
  .wea(addr_in_en), // input [0 : 0] wea
  .addra(addr_in), // input [12 : 0] addra
  .dina(data_in), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .addrb(arm_addr), // input [12 : 0] addrb
  .doutb(arm_data) // output [7 : 0] doutb
);

endmodule
