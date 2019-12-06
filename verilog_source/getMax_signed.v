`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:52 11/20/2018 
// Design Name: 
// Module Name:    getMax_signed 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: detec_in上升沿将检测结果打到max锁存；下降沿时复位内部寄存器
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module getMax_signed #(
	parameter INPUT_WIDTH = 16
)
(
	//*************************************//
	//************* ports *****************//
	//*************************************//
		clk,
		rst,	//幅度检测脉冲，要求宽度尽可能窄且与clk同步
		nd,
		data_in,
		max
	);
	
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                     clk;
	input   [INPUT_WIDTH-1:0]                 data_in;	
	input                                     nd;
	input                                     rst;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	output  [INPUT_WIDTH-1:0]                 max;

	//*************************************//
	//************ internal ***************//
	//*************************************//	
	
	wire    [INPUT_WIDTH-1:0]                 data_in_reg;
	reg     [INPUT_WIDTH-2:0]                 data_neg_reg;	
	reg     [INPUT_WIDTH-1:0]                 data_neg_reg_plus;	
	reg     [INPUT_WIDTH-1:0]                 abs_reg;
	reg     [INPUT_WIDTH-1:0]                 abs_reg_delay;
	
	wire 													detect_in;
	wire                                      detect_in_reg;
	wire                                      detect_in_pos_edge;
	wire                                      detect_in_neg_edge;
	
	reg     [INPUT_WIDTH-1:0]                 max_internal_reg;
	reg     [INPUT_WIDTH-1:0]                 max_reg;
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//

	assign detect_in_pos_edge = (~detect_in_reg) & detect_in;	//上升沿
	assign detect_in_neg_edge = (detect_in_reg) & (~detect_in);	//下升沿
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign max = max_reg;
	
   	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	ms_gen U_ms_gen(
	.clk(clk),
	.rst(rst),
	.ms_out(detect_in)
	);
	//***** 输入缓冲 *****//
	delay_line #(
	.DATA_WIDTH(INPUT_WIDTH),
	.PIPELINE_DEPTH(1)
	)
	U_delay_line_data (
	.clk(clk),
	.nd(nd), 
	.din(data_in), 
	.q(data_in_reg)
	);
	
	//***** 取绝对值 *****//
	always @(posedge clk)
	begin
		if (data_in_reg[INPUT_WIDTH-1]==1'b1)	//负数
		begin
			data_neg_reg <= ~(data_in_reg[INPUT_WIDTH-2:0]);
			data_neg_reg_plus <= data_neg_reg+1'b1;
			abs_reg <= {1'b0,data_neg_reg_plus[INPUT_WIDTH-2:0]};
		end
		else
			abs_reg <= data_in_reg;
	end

	//***** 取detect_in打拍 *****//
	delay_line #(
	.DATA_WIDTH(1),
	.PIPELINE_DEPTH(1)
	)
	U_delay_line_detect_in (
	.clk(clk),
	.nd(1'b1), 
	.din(detect_in), 
	.q(detect_in_reg)
	);
	//***** 记录检测周期内最大值 *****//
	reg max_internal_flag;
	always @(posedge clk)
		begin
			if(abs_reg>max_internal_reg)
				max_internal_flag <= 1;
			else
				max_internal_flag <= 0;
		end
		
	always @(posedge clk)
		begin
			abs_reg_delay <= abs_reg;
		end
		
	always @(posedge clk)
	begin
		if(detect_in_neg_edge==1'b1)	//下降沿时复位内部寄存器
			begin
				max_internal_reg <= 0;
			end
		else if (max_internal_flag == 1)
				max_internal_reg <= abs_reg_delay;
		else
			max_internal_reg <= max_internal_reg;
	end

	//***** 更新输出 *****//
	always @(posedge clk)
	begin
		if(detect_in_pos_edge==1'b1)	//上升沿输出
			max_reg <= max_internal_reg;
		else
			max_reg <= max_reg;
	end

endmodule

