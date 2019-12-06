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
	
	input PPS_IN,		//PPS�ź�
	input RST_SW,		//ϵͳ��λ�����ź�
	input PPS_RST_IN, //PPS��λ�ź�
	
	input ARST,
	output CLK_OUT,	//��ʱ������ź�
	output CLK_30M,	//30Mʱ�����
	output CLK_200M,
	output CLK_150M,
	output RST_OUT		//��λ����ź�
    );
//----------------------ʱ�����-----------------------------------
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
//---------------------��λ�߼����----------------------------------
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
//�����⵽rst�ź������أ������ϵͳ��λ�ź�;���ϵͳ���ڸ�λ״̬�����Ҽ�⵽PPS�����أ����ͷŸ�λ�ź�
always @(posedge CLK_OUT)
	begin
		if((PPS_RST_IN==1)&&(rst_sw_shift==0))
			pps_rst_out<=1'b1;
		else if((pps_rst_out==1)&&(PPS_IN==0)&&(pps_shift==1))
			pps_rst_out<=1'b0;
		else 
			pps_rst_out<=pps_rst_out;
	end	 
//��ͨ��λ�ź�	 
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
//��λ�ź�����ͨ��λ��PPS��λ�������㹹��	
wire         system_rst;
reg          system_rst_reg;

assign system_rst=pps_rst_out|RST_MID|ARST;	
assign RST_OUT = system_rst_reg; 

always @(posedge CLK_OUT)
	system_rst_reg <= system_rst;
	
////��λ�ӵ�ȫ��ʱ�ӣ��Ա�֤�㹻��������
    // BUFG BUFG_RST (
      // .O(RST_OUT), 
      // .I(system_rst)
   // ); 
endmodule
