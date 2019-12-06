`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:18:18 10/18/2018 
// Design Name: 
// Module Name:    NCO_MUL_CHANNEL 
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
module NCO_MUL_CHANNEL#(
	parameter DATA_INPUT_WIDTH = 8,
	parameter STEP_WIDTH = 12,
	parameter OUTPUT_WIDTH = 18,	//需要配合NCO_MUL_CHANNEL里的乘法器修改
	parameter CHANNEL_NUM = 8,		//必须2次幂
	parameter ACC_THRESHOLD  = 2400	//相位累加器的溢出上限
)	

	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		clk,
		srst,
		din,
		step_real,		//已经按通道数处理过
		adr_init,	//初相
				
		data_out_i,
		data_out_q
	);
	
	//*************************************//
	//*********** functions *************//
	//*************************************//
	
	function integer clog2b;
	input integer value;
	begin
		if (value==1)
			clog2b = 0;
		else begin
			value = value-1;
			for (clog2b=0;value>0;clog2b=clog2b+1)
				value = value>>1;
		end
	end
	endfunction
	
	//*************************************//
	//*********** localparams *************//
	//*************************************//
	
	localparam ADDR_ACC_WIDTH = STEP_WIDTH;//相位累加器位正弦表的ROM地址位宽——ROM的位宽IP核要手动
	localparam ROM_DATA_WIDTH = 10;		//正弦表的数据位宽
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//

	input                                     clk;
	input                                     srst;
	input     [DATA_INPUT_WIDTH-1:0]          din;
	input     [STEP_WIDTH-1:0]                step_real;		//已经按通道数处理过
	input     [STEP_WIDTH-1:0]                adr_init;	//初相
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output    [OUTPUT_WIDTH-1:0]              data_out_i;
	output    [OUTPUT_WIDTH-1:0]              data_out_q;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	reg       [ADDR_ACC_WIDTH-1:0]            adr_acc_reg;
	wire      [ROM_DATA_WIDTH-1:0]            sin_out;
	wire      [ROM_DATA_WIDTH-1:0]            cos_out;
	wire      [DATA_INPUT_WIDTH-1:0]          din_signed;
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
//	assign   din_signed      = din-(1<<(DATA_INPUT_WIDTH-1));
	assign   din_signed      = din;
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//

	always @(posedge clk)
	begin
		if(srst)
			adr_acc_reg <= adr_init;
		else if ( adr_acc_reg >= (ACC_THRESHOLD-step_real))
			adr_acc_reg <= adr_acc_reg + step_real-ACC_THRESHOLD;
		else 
			adr_acc_reg <= adr_acc_reg  + step_real;
	end

	ROM_cos2400	U_ROM_cos2400
	(
	.clka(clk),
	.addra(adr_acc_reg),
	.douta(cos_out)
	);	

	ROM_sin2400	U_ROM_sin2400
	(
	.clka(clk),
	.addra(adr_acc_reg),
	.douta(sin_out)
	);  

	mul U_mul_i(
	.clk(clk),
	.a(din_signed), // Bus [7 : 0] 
	.b(cos_out), // Bus [9 : 0] 
	.p(data_out_i) // Bus [17 : 0] 
	);
	
	mul U_mul_q(
	.clk(clk),
	.a(din_signed), // Bus [7 : 0] 
	.b(sin_out), // Bus [9 : 0]
	.p(data_out_q) // Bus [17 : 0] 
	);
endmodule
