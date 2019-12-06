`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:41 10/18/2018 
// Design Name: 
// Module Name:    DDC_2400to150 
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
module DDC_2400to150(
		clk_300M,
		arst,	//同步复位
		din1,	//300MSps
		din2,
		din3,
		din4,
		din5,
		din6,
		din7,
		din8,
		step,
		
		data_150M_i,
		data_150M_q,
		data_valid
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
	localparam DATA_INPUT_WIDTH = 8;	//ADC输入位宽
	localparam CHANNEL_NUM = 8;	//并行输入的通道数（经过IDDR或ISERDES的路数）
	localparam STEP_WIDTH = 12;	//相位/地址的位宽
	localparam ACC_THRESHOLD = 2400;	//相位累加器的溢出上限
	localparam DDC_OUTPUT_WIDTH = 34;	//DDC最终输出的位宽
	localparam OUTPUT_WIDTH = 18;
	localparam FIR_INPUT_WIDTH = 18;
	localparam FIR_OUTPUT_WIDTH = 31;	//FIR输出的位宽，有符号
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	input                                     clk_300M;
	input                                     arst;	//同步复位信号，设置step之后必须复位
	input   [DATA_INPUT_WIDTH-1:0]            din1;	//300MSps的数据，8路来自两个ADC核
	input   [DATA_INPUT_WIDTH-1:0]            din2;
	input   [DATA_INPUT_WIDTH-1:0]            din3;
	input   [DATA_INPUT_WIDTH-1:0]            din4;
	input   [DATA_INPUT_WIDTH-1:0]            din5;
	input   [DATA_INPUT_WIDTH-1:0]            din6;
	input   [DATA_INPUT_WIDTH-1:0]            din7;
	input   [DATA_INPUT_WIDTH-1:0]            din8;
	input   [STEP_WIDTH-1:0]                  step;
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	output                                    data_valid;		//与150M数据同步的数据有效信号
	output  [DDC_OUTPUT_WIDTH-1:0]            data_150M_i;
	output  [DDC_OUTPUT_WIDTH-1:0]            data_150M_q;

	//*************************************//
	//************ internal ***************//
	//*************************************//	
	
	wire      [OUTPUT_WIDTH-1:0]     mix_out_i_array[0:CHANNEL_NUM-1];
	wire      [OUTPUT_WIDTH-1:0]     mix_out_q_array[0:CHANNEL_NUM-1];
	
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_1i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_1q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_2i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_2q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_3i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_3q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_4i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_4q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_5i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_5q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_6i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_6q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_7i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_7q;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_8i;
	wire [FIR_OUTPUT_WIDTH-1:0] firout_150M_8q;

	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_1i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_1q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_2i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_2q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_3i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_3q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_4i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_4q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_5i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_5q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_6i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_6q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_7i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_7q; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_8i; 
	wire [FIR_INPUT_WIDTH-1:0] mixout_150M_8q;
	wire rdy1,rdy2,rdy3,rdy4,rdy5,rdy6,rdy7,rdy8;
	wire                       srst;
	
	
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//


	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	assign data_valid = rdy1;
		
	assign mixout_150M_1i = {mix_out_i_array[0]};
	assign mixout_150M_2i = {mix_out_i_array[1]};
	assign mixout_150M_3i = {mix_out_i_array[2]};
	assign mixout_150M_4i = {mix_out_i_array[3]};
	assign mixout_150M_5i = {mix_out_i_array[4]};
	assign mixout_150M_6i = {mix_out_i_array[5]};
	assign mixout_150M_7i = {mix_out_i_array[6]};
	assign mixout_150M_8i = {mix_out_i_array[7]};
	
	assign mixout_150M_1q = {mix_out_q_array[0]};
	assign mixout_150M_2q = {mix_out_q_array[1]};
	assign mixout_150M_3q = {mix_out_q_array[2]};
	assign mixout_150M_4q = {mix_out_q_array[3]};
	assign mixout_150M_5q = {mix_out_q_array[4]};
	assign mixout_150M_6q = {mix_out_q_array[5]};
	assign mixout_150M_7q = {mix_out_q_array[6]};
	assign mixout_150M_8q = {mix_out_q_array[7]};
	
   	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//

	reset_global U_rst_ddc (
    .clk(clk_300M), 
    .rst_asyn(arst), 
    .rst_out(srst)
    );
	
	nco_2400M #(
	.DATA_INPUT_WIDTH(DATA_INPUT_WIDTH),
	.STEP_WIDTH(STEP_WIDTH),
	.OUTPUT_WIDTH(OUTPUT_WIDTH),	//需要配合NCO_MUL_CHANNEL里的乘法器修改
	.CHANNEL_NUM(CHANNEL_NUM),		//必须是2次幂
	.ACC_THRESHOLD(ACC_THRESHOLD)	//相位累加器的溢出上限
	)
	U_nco_2400M(
		.clk(clk_300M),
		.srst(srst),
		.din1(din1),
		.din2(din2),
		.din3(din3),
		.din4(din4),
		.din5(din5),
		.din6(din6),
		.din7(din7),
		.din8(din8),		
		.step(step),
		
		.mix_out_1i(mix_out_i_array[0]),
		.mix_out_1q(mix_out_q_array[0]),
		.mix_out_2i(mix_out_i_array[1]),
		.mix_out_2q(mix_out_q_array[1]),
		.mix_out_3i(mix_out_i_array[2]),
		.mix_out_3q(mix_out_q_array[2]),
		.mix_out_4i(mix_out_i_array[3]),
		.mix_out_4q(mix_out_q_array[3]),
		.mix_out_5i(mix_out_i_array[4]),
		.mix_out_5q(mix_out_q_array[4]),
		.mix_out_6i(mix_out_i_array[5]),
		.mix_out_6q(mix_out_q_array[5]),
		.mix_out_7i(mix_out_i_array[6]),
		.mix_out_7q(mix_out_q_array[6]),
		.mix_out_8i(mix_out_i_array[7]),
		.mix_out_8q(mix_out_q_array[7])
	);
	//.CLKDV(clk_300M),
	//.rst_in(syn_rst), 
	//.L0(L0), 
	//.H0(H0),
	//.L1(L1), 
	//.H1(H1),
	//.L2(L2), 
	//.H2(H2),
	//.L3(L3),
	//.H3(H3), 
	//.step(step),
	//.mix_out_1i(mixout_150M_1i), 
	//.mix_out_1q(mixout_150M_1q), 
	//.mix_out_2i(mixout_150M_2i), 
	//.mix_out_2q(mixout_150M_2q), 
	//.mix_out_3i(mixout_150M_3i), 
	//.mix_out_3q(mixout_150M_3q), 
	//.mix_out_4i(mixout_150M_4i), 
	//.mix_out_4q(mixout_150M_4q), 
	//.mix_out_5i(mixout_150M_5i), 
	//.mix_out_5q(mixout_150M_5q), 
	//.mix_out_6i(mixout_150M_6i), 
	//.mix_out_6q(mixout_150M_6q), 
	//.mix_out_7i(mixout_150M_7i), 
	//.mix_out_7q(mixout_150M_7q), 
	//.mix_out_8i(mixout_150M_8i), 
	//.mix_out_8q(mixout_150M_8q)
	//);

	fir8_72M U_fir1 (
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy1),		//宽度是一个288M时钟周期
	.din_1(mixout_150M_1i), // Bus [17 : 0] 
	.din_2(mixout_150M_1q), // Bus [17 : 0] 
	.dout_1(firout_150M_1i), // Bus [27 : 0] 
	.dout_2(firout_150M_1q) // Bus [27 : 0] 
	);

	fir7_72M U_fir2 (
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy2),
	.din_1(mixout_150M_2i), // Bus [17 : 0] 
	.din_2(mixout_150M_2q), // Bus [17 : 0] 
	.dout_1(firout_150M_2i), // Bus [27 : 0] 
	.dout_2(firout_150M_2q) // Bus [27 : 0] 
	);

	fir6_72M U_fir3 (
	.clk(clk_300M),
	.rfd(),	
	.rdy(rdy3),
	.din_1(mixout_150M_3i), // Bus [17 : 0] 
	.din_2(mixout_150M_3q), // Bus [17 : 0] 
	.dout_1(firout_150M_3i), // Bus [27 : 0] 
	.dout_2(firout_150M_3q) // Bus [27 : 0] 
	);

	fir5_72M U_fir4 (
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy4),	 
	.din_1(mixout_150M_4i), // Bus [17 : 0] 
	.din_2(mixout_150M_4q), // Bus [17 : 0] 
	.dout_1(firout_150M_4i), // Bus [27 : 0] 
	.dout_2(firout_150M_4q) // Bus [27 : 0]
	);

	fir4_72M U_fir5 (
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy5),
	.din_1(mixout_150M_5i), // Bus [17 : 0] 
	.din_2(mixout_150M_5q), // Bus [17 : 0] 
	.dout_1(firout_150M_5i), // Bus [27 : 0] 
	.dout_2(firout_150M_5q) // Bus [27 : 0] 
	);

	fir3_72M U_fir6 (
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy6),
	.din_1(mixout_150M_6i), // Bus [17 : 0] 
	.din_2(mixout_150M_6q), // Bus [17 : 0]
	.dout_1(firout_150M_6i), // Bus [27 : 0] 
	.dout_2(firout_150M_6q) // Bus [27 : 0]
	);

	fir2_72M U_fir7(
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy7),
	.din_1(mixout_150M_7i), // Bus [17 : 0] 
	.din_2(mixout_150M_7q), // Bus [17 : 0]	
	.dout_1(firout_150M_7i), // Bus [27 : 0] 
	.dout_2(firout_150M_7q) // Bus [27 : 0] 
	);

	fir1_72M U_fir8(
	.clk(clk_300M),
	.rfd(),
	.rdy(rdy8),
	.din_1(mixout_150M_8i), // Bus [17 : 0] 
	.din_2(mixout_150M_8q), // Bus [17 : 0]
	.dout_1(firout_150M_8i), // Bus [27 : 0] 
	.dout_2(firout_150M_8q) // Bus [27 : 0] 
	);

	Adder #(
	.INPUT_WIDTH(FIR_OUTPUT_WIDTH),
	.DDC_OUTPUT_WIDTH(DDC_OUTPUT_WIDTH)
	)
	U_adder (
	.firout_150M_1i(firout_150M_1i), 
	.firout_150M_1q(firout_150M_1q), 
	.firout_150M_2i(firout_150M_2i), 
	.firout_150M_2q(firout_150M_2q), 
	.firout_150M_3i(firout_150M_3i), 
	.firout_150M_3q(firout_150M_3q), 
	.firout_150M_4i(firout_150M_4i), 
	.firout_150M_4q(firout_150M_4q), 
	.firout_150M_5i(firout_150M_5i), 
	.firout_150M_5q(firout_150M_5q), 
	.firout_150M_6i(firout_150M_6i), 
	.firout_150M_6q(firout_150M_6q), 
	.firout_150M_7i(firout_150M_7i), 
	.firout_150M_7q(firout_150M_7q), 
	.firout_150M_8i(firout_150M_8i), 
	.firout_150M_8q(firout_150M_8q), 
	.clk(clk_300M),
	/*.clk_div2(clk_150M),	
	.rdy1(rdy1),
	.rdy2(rdy2),
	.rdy3(rdy3),
	.rdy4(rdy4),
	.rdy5(rdy5),
	.rdy6(rdy6),
	.rdy7(rdy7),
	.rdy8(rdy8),*/
	//.sclr(syn_rst),
	.data_150M_i(data_150M_i), 
	.data_150M_q(data_150M_q)
	);
	
	integer fir_150M_outfile1;
	integer fir_150M_outfile2;
	integer fir_150M_outfile3;
	integer fir_150M_outfile4;
	integer fir_150M_outfile5;
	integer fir_150M_outfile6;
	integer fir_150M_outfile7;
	integer fir_150M_outfile8;

	initial 
	begin
		fir_150M_outfile1 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out1.txt");
		if (!fir_150M_outfile1)
			$display("fail to openfir_out1.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy1)
			$fdisplay(fir_150M_outfile1,"%d %d",$signed(firout_150M_1i),$signed(firout_150M_1q));
	end
	
	initial 
	begin
		fir_150M_outfile2 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out2.txt");
		if (!fir_150M_outfile2)
			$display("fail to openfir_out2.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy2)
			$fdisplay(fir_150M_outfile2,"%d %d",$signed(firout_150M_2i),$signed(firout_150M_2q));
	end
	
	initial 
	begin
		fir_150M_outfile3 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out3.txt");
		if (!fir_150M_outfile3)
			$display("fail to openfir_out3.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy3)
			$fdisplay(fir_150M_outfile3,"%d %d",$signed(firout_150M_3i),$signed(firout_150M_3q));
	end
	
	initial 
	begin
		fir_150M_outfile4 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out4.txt");
		if (!fir_150M_outfile4)
			$display("fail to openfir_out4.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy4)
			$fdisplay(fir_150M_outfile4,"%d %d",$signed(firout_150M_4i),$signed(firout_150M_4q));
	end
	
	initial 
	begin
		fir_150M_outfile5 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out5.txt");
		if (!fir_150M_outfile5)
			$display("fail to openfir_out5.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy5)
			$fdisplay(fir_150M_outfile5,"%d %d",$signed(firout_150M_5i),$signed(firout_150M_5q));
	end
	
	initial 
	begin
		fir_150M_outfile6 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out6.txt");
		if (!fir_150M_outfile6)
			$display("fail to openfir_out6.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy6)
			$fdisplay(fir_150M_outfile6,"%d %d",$signed(firout_150M_6i),$signed(firout_150M_6q));
	end
	
	initial 
	begin
		fir_150M_outfile7 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out7.txt");
		if (!fir_150M_outfile7)
			$display("fail to openfir_out7.txt");
	end
		
	always @(posedge clk_300M)
	begin
		if (rdy7)
			$fdisplay(fir_150M_outfile7,"%d %d",$signed(firout_150M_7i),$signed(firout_150M_7q));
	end
	
	initial 
	begin
		fir_150M_outfile8 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/fir_out8.txt");
		if (!fir_150M_outfile8)
			$display("fail to openfir_out8.txt");
	end
		
	always @(posedge clk_300M)
	begin	
		if (rdy8)
			$fdisplay(fir_150M_outfile8,"%d %d",$signed(firout_150M_8i),$signed(firout_150M_8q));
	end

endmodule
