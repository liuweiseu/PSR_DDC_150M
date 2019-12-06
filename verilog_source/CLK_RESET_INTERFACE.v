`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:15 04/23/2017 
// Design Name: 
// Module Name:    CLK_RESET_INTERFACE 
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
module CLK_RESET_INTERFACE(
	input CLK_IN_P,
	input CLK_IN_N,
	
	input PPS_IN,		//PPS信号
	input RST_SW,		//系统复位输入信号
	input PPS_RST_IN, //PPS复位信号
	
	input ARST,
	output CLK_OUT,	//主时钟输出信号
	output CLK_30M,	//30M时钟输出
	output CLK_200M,
	output CLK_150M,
	output RST_OUT		//复位输出信号
    );
//----------------------时钟输出-----------------------------------
wire locked_out;
wire locked_out1;	
sys_clk_300M U0	
   (
    .CLK_IN1_P(CLK_IN_P),    
    .CLK_IN1_N(CLK_IN_N),    
    .CLK_200M(CLK_200M),    	
    .CLK_30M(CLK_30M), 
	 .CLK_300M(CLK_OUT),
	 .CLK_150M(CLK_150M)
	 );  
//wire locked_out2;
//sys_clk_200M U1	
//   (
//    .CLK_IN1_P(CLK_IN_P),    
//    .CLK_IN1_N(CLK_IN_N),    
//    .CLK_OUT1(CLK_200M), 
//    .LOCKED(locked_out2)
//	 );      

//assign locked_out = locked_out1 & locked_out2;
//---------------------复位逻辑设计----------------------------------
reg pps_rst_out;

wire pps_shift;
wire rst_sw_shift;
   SRL16E #(
      .INIT(16'h0000) 	// Initial Value of Shift Register
   ) SRL16E_PPS (
      .Q(pps_shift),    // SRL data output
      .A0(1'b1),     		// Select[0] input
      .A1(1'b0),     		// Select[1] input
      .A2(1'b0),     		// Select[2] input
      .A3(1'b0),    			// Select[3] input
      .CE(1'b1),    			// Clock enable input
      .CLK(CLK_OUT),   	// Clock input
      .D(PPS_IN)        // SRL data input
   );
	
   SRL16E #(
      .INIT(16'h0000) 	// Initial Value of Shift Register
   ) SRL16E_pps_rst (
      .Q(rst_sw_shift), // SRL data output
      .A0(1'b1),     		// Select[0] input
      .A1(1'b0),     		// Select[1] input
      .A2(1'b0),     		// Select[2] input
      .A3(1'b0),     		// Select[3] input
      .CE(1'b1),    			// Clock enable input
      .CLK(CLK_OUT),  	// Clock input
      .D(PPS_RST_IN)    // SRL data input
   );
//如果检测到rst信号上升沿，则给出系统复位信号;如果系统处于复位状态，并且检测到PPS上升沿，则释放复位信号
always @(posedge CLK_OUT)
	begin
		if((PPS_RST_IN==1)&&(rst_sw_shift==0))
			pps_rst_out<=1'b1;
		else if((pps_rst_out==1)&&(PPS_IN==0)&&(pps_shift==1))
			pps_rst_out<=1'b0;
		else 
			pps_rst_out<=pps_rst_out;
	end	 
//普通复位信号	 
reg rst_r1;
reg RST_MID;
wire RST_SW_t;
assign RST_SW_t = RST_SW && locked_out;
	always @(posedge CLK_OUT or posedge RST_SW_t)
    if (RST_SW_t)
        rst_r1<=1'b1;
    else 
        rst_r1<= 1'b0;
   always @(posedge CLK_OUT or posedge RST_SW_t)
     if (RST_SW_t)
			RST_MID<=1'b1;
     else	  
			RST_MID<=rst_r1;
//复位信号由普通复位与PPS复位作或运算构成	
wire         system_rst;
reg          system_rst_reg;

assign system_rst=pps_rst_out|RST_MID|ARST;	
assign RST_OUT = system_rst_reg; 

always @(posedge CLK_OUT)
	system_rst_reg <= system_rst;
	
////复位接到全局时钟，以保证足够的驱动力
    // BUFG BUFG_RST (
      // .O(RST_OUT), 
      // .I(system_rst)
   // ); 
endmodule
