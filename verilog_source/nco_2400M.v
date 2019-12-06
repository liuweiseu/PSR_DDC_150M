`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:40 10/18/2018 
// Design Name: 
// Module Name:    nco_2400M 
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

module nco_2400M #(
	parameter DATA_INPUT_WIDTH = 8,
	parameter STEP_WIDTH = 12,
	parameter OUTPUT_WIDTH = 18,	//需要配合NCO_MUL_CHANNEL里的乘法器修改
	parameter CHANNEL_NUM = 8,		//必须是2次幂
	parameter ACC_THRESHOLD = 2400	//相位累加器的溢出上限
)	
	//*************************************//
	//************ Ports ******************//
	//*************************************//
	(
		clk,
		srst,
		din1,
		din2,
		din3,
		din4,
		din5,
		din6,
		din7,
		din8,
		step,
		
		mix_out_1i,
		mix_out_1q,
		mix_out_2i,
		mix_out_2q,
		mix_out_3i,
		mix_out_3q,
		mix_out_4i,
		mix_out_4q,
		mix_out_5i,
		mix_out_5q,
		mix_out_6i,
		mix_out_6q,
		mix_out_7i,
		mix_out_7q,
		mix_out_8i,
		mix_out_8q
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
	
	
	//*************************************//
	//************ inputs *****************//
	//*************************************//
	
	input                                     clk;
	input                                     srst;
	input     [DATA_INPUT_WIDTH-1:0]          din1;
	input     [DATA_INPUT_WIDTH-1:0]          din2;
	input     [DATA_INPUT_WIDTH-1:0]          din3;
	input     [DATA_INPUT_WIDTH-1:0]          din4;
	input     [DATA_INPUT_WIDTH-1:0]          din5;
	input     [DATA_INPUT_WIDTH-1:0]          din6;
	input     [DATA_INPUT_WIDTH-1:0]          din7;
	input     [DATA_INPUT_WIDTH-1:0]          din8;
	input     [STEP_WIDTH-1:0]                step;		//step值即为对应的NCO频率，单位MHz
	
	//*************************************//
	//************ outputs ****************//	
	//*************************************//
	
	output    [OUTPUT_WIDTH-1:0]              mix_out_1i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_1q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_2i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_2q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_3i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_3q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_4i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_4q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_5i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_5q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_6i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_6q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_7i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_7q;
	output    [OUTPUT_WIDTH-1:0]              mix_out_8i;
	output    [OUTPUT_WIDTH-1:0]              mix_out_8q;

	//*************************************//
	//************ internal ***************//
	//*************************************//
	
	wire      [STEP_WIDTH:0]                adr_init[0:CHANNEL_NUM-1];		//每个通道的初相，扩展1位防止计算时溢出
	wire      [DATA_INPUT_WIDTH-1:0]        din_array[0:CHANNEL_NUM-1];
	wire      [OUTPUT_WIDTH-1:0]            mix_out_i_array[0:CHANNEL_NUM-1];
	wire      [OUTPUT_WIDTH-1:0]            mix_out_q_array[0:CHANNEL_NUM-1];
	//wire      [STEP_WIDTH-1:0]                adr_init2;
	//wire      [STEP_WIDTH-1:0]                adr_init3;
	//wire      [STEP_WIDTH-1:0]                adr_init4;
	//wire      [STEP_WIDTH-1:0]                adr_init5;
	//wire      [STEP_WIDTH-1:0]                adr_init6;
	//wire      [STEP_WIDTH-1:0]                adr_init7;
	//wire      [STEP_WIDTH-1:0]                adr_init8;
	wire      [STEP_WIDTH+clog2b(CHANNEL_NUM)-1:0]            adr_step_extend; //多相计算时实际每次累加是step*channel数
	wire      [STEP_WIDTH+clog2b(CHANNEL_NUM)-1:0]            adr_step_real_extend;
	wire      [STEP_WIDTH-1:0]                                adr_step_real;
	
	
	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	assign mix_out_1i = mix_out_i_array[0];
	assign mix_out_2i = mix_out_i_array[1];
	assign mix_out_3i = mix_out_i_array[2];
	assign mix_out_4i = mix_out_i_array[3];
	assign mix_out_5i = mix_out_i_array[4];
	assign mix_out_6i = mix_out_i_array[5];
	assign mix_out_7i = mix_out_i_array[6];
	assign mix_out_8i = mix_out_i_array[7];
	
	assign mix_out_1q = mix_out_q_array[0];
	assign mix_out_2q = mix_out_q_array[1];
	assign mix_out_3q = mix_out_q_array[2];
	assign mix_out_4q = mix_out_q_array[3];
	assign mix_out_5q = mix_out_q_array[4];
	assign mix_out_6q = mix_out_q_array[5];
	assign mix_out_7q = mix_out_q_array[6];
	assign mix_out_8q = mix_out_q_array[7];
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	assign din_array[0] = din1;
	assign din_array[1] = din2;
	assign din_array[2] = din3;
	assign din_array[3] = din4;
	assign din_array[4] = din5;
	assign din_array[5] = din6;
	assign din_array[6] = din7;
	assign din_array[7] = din8;
	

	//每个通道的初相，因为是多相结构所以都要错开一个CLK的值
   assign adr_init[0] = 0;
   
   genvar i;
   generate
      for (i=1;i < CHANNEL_NUM; i=i+1) 
      begin: init_adr
         assign adr_init[i] = ((adr_init[i-1]+step)>ACC_THRESHOLD)?(adr_init[i-1]+step-ACC_THRESHOLD):(adr_init[i-1]+step);
      end
   endgenerate
		

	//*************************************//
	//*********** assign outputs **********//
	//*************************************//
	
	//*************************************//
	//*********** assign internals ********//
	//*************************************//
	
	assign   adr_step_extend = step<<clog2b(CHANNEL_NUM);
	assign   adr_step_real_extend   = (adr_step_extend>ACC_THRESHOLD)?(adr_step_extend-ACC_THRESHOLD):adr_step_extend;
	assign   adr_step_real   = adr_step_real_extend[STEP_WIDTH-1:0];
	
	//*************************************//
	//****** Instantiate the modules ******//
	//*************************************//
	generate
	for (i=0;i < CHANNEL_NUM; i=i+1) 
	begin: inst_nco
		NCO_MUL_CHANNEL u_NCO_MUL_CHANNEL (
		.clk(clk), 
		.srst(srst),
		.din(din_array[i]), 
		.step_real(adr_step_real), 
		.adr_init(adr_init[i][STEP_WIDTH-1:0]), 
		.data_out_i(mix_out_i_array[i]),
		.data_out_q(mix_out_q_array[i])
		);
	end
	endgenerate

	
	integer mix_2400_outfile1;
	integer mix_2400_outfile2;
	integer mix_2400_outfile3;
	integer mix_2400_outfile4;
	integer mix_2400_outfile5;
	integer mix_2400_outfile6;
	integer mix_2400_outfile7;
	integer mix_2400_outfile8;

	initial 
	begin
		mix_2400_outfile1 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out1.txt");
		if (!mix_2400_outfile1)
			$display("fail to openmix_out1.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile1,"%d %d",$signed(mix_out_i_array[0]),$signed(mix_out_q_array[0]));
	end
	
	initial 
	begin
		mix_2400_outfile2 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out2.txt");
		if (!mix_2400_outfile2)
			$display("fail to openmix_out2.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile2,"%d %d",$signed(mix_out_i_array[1]),$signed(mix_out_q_array[1]));
	end
	
	initial 
	begin
		mix_2400_outfile3 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out3.txt");
		if (!mix_2400_outfile3)
			$display("fail to openmix_out3.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile3,"%d %d",$signed(mix_out_i_array[2]),$signed(mix_out_q_array[2]));
	end
	
	initial 
	begin
		mix_2400_outfile4 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out4.txt");
		if (!mix_2400_outfile4)
			$display("fail to openmix_out4.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile4,"%d %d",$signed(mix_out_i_array[3]),$signed(mix_out_q_array[3]));
	end
	
	initial 
	begin
		mix_2400_outfile5 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out5.txt");
		if (!mix_2400_outfile5)
			$display("fail to openmix_out5.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile5,"%d %d",$signed(mix_out_i_array[4]),$signed(mix_out_q_array[4]));
	end
	
	initial 
	begin
		mix_2400_outfile6 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out6.txt");
		if (!mix_2400_outfile6)
			$display("fail to openmix_out6.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile6,"%d %d",$signed(mix_out_i_array[5]),$signed(mix_out_q_array[5]));
	end
	
	initial 
	begin
		mix_2400_outfile7 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out7.txt");
		if (!mix_2400_outfile7)
			$display("fail to openmix_out7.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile7,"%d %d",$signed(mix_out_i_array[6]),$signed(mix_out_q_array[6]));
	end
	
	initial 
	begin
		mix_2400_outfile8 = $fopen("E:/6-RSR-1G/1-ISEProjects/7-PSR/PSR_DDC_150_V1.3.1/tb_rzlt/mix_out8.txt");
		if (!mix_2400_outfile8)
			$display("fail to openmix_out8.txt");
	end
		
	always @(posedge clk)
	begin
		$fdisplay(mix_2400_outfile8,"%d %d",$signed(mix_out_i_array[7]),$signed(mix_out_q_array[7]));
	end
	

endmodule

