`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称：CLK_REG_MODULE
// 功能：控制频率合成器？相关引脚映射成寄存器
//////////////////////////////////////////////////////////////////////////////////
module CLK_REG_MODULE(
	input [15:0]CLK_REG,
	input ADF_LD_IN,
	
	output [15:0]CLK_RD_BACK,
	output ADF_CLK_OUT,
	output ADF_DATA_OUT,
	output ADF_LE_OUT
    );
//输出逻辑
assign ADF_CLK_OUT = CLK_REG[0:0];
assign ADF_DATA_OUT = CLK_REG[1:1];
assign ADF_LE_OUT = CLK_REG[2:2];
//输入逻辑
assign CLK_RD_BACK[0:0] = ADF_LD_IN;
assign CLK_RD_BACK[15:1] = 0;
endmodule
