////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: Power_Adder.v
// /___/   /\     Timestamp: Sun Nov 04 21:21:29 2018
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/Power_Adder.ngc E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/Power_Adder.v 
// Device	: 6vlx240tff1156-1
// Input file	: E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/Power_Adder.ngc
// Output file	: E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/Power_Adder.v
// # of Modules	: 1
// Design Name	: Power_Adder
// Xilinx        : D:\Xilinx\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module Power_Adder (
  clk, sclr, a, b, s
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input sclr;
  input [15 : 0] a;
  input [15 : 0] b;
  output [15 : 0] s;
  
  // synthesis translate_off
  
  wire \blk00000001/sig00000062 ;
  wire \blk00000001/sig00000061 ;
  wire \blk00000001/sig00000060 ;
  wire \blk00000001/sig0000005f ;
  wire \blk00000001/sig0000005e ;
  wire \blk00000001/sig0000005d ;
  wire \blk00000001/sig0000005c ;
  wire \blk00000001/sig0000005b ;
  wire \blk00000001/sig0000005a ;
  wire \blk00000001/sig00000059 ;
  wire \blk00000001/sig00000058 ;
  wire \blk00000001/sig00000057 ;
  wire \blk00000001/sig00000056 ;
  wire \blk00000001/sig00000055 ;
  wire \blk00000001/sig00000054 ;
  wire \blk00000001/sig00000053 ;
  wire \blk00000001/sig00000052 ;
  wire \blk00000001/sig00000051 ;
  wire \blk00000001/sig00000050 ;
  wire \blk00000001/sig0000004f ;
  wire \blk00000001/sig0000004e ;
  wire \blk00000001/sig0000004d ;
  wire \blk00000001/sig0000004c ;
  wire \blk00000001/sig0000004b ;
  wire \blk00000001/sig0000004a ;
  wire \blk00000001/sig00000049 ;
  wire \blk00000001/sig00000048 ;
  wire \blk00000001/sig00000047 ;
  wire \blk00000001/sig00000046 ;
  wire \blk00000001/sig00000045 ;
  wire \blk00000001/sig00000044 ;
  wire \blk00000001/sig00000043 ;
  wire \blk00000001/sig00000042 ;
  wire \blk00000001/sig00000041 ;
  wire \blk00000001/sig00000040 ;
  wire \blk00000001/sig0000003f ;
  wire \blk00000001/sig0000003e ;
  wire \blk00000001/sig0000003d ;
  wire \blk00000001/sig0000003c ;
  wire \blk00000001/sig0000003b ;
  wire \blk00000001/sig0000003a ;
  wire \blk00000001/sig00000039 ;
  wire \blk00000001/sig00000038 ;
  wire \blk00000001/sig00000037 ;
  wire \blk00000001/sig00000036 ;
  wire \blk00000001/sig00000035 ;
  wire \blk00000001/sig00000034 ;
  wire \blk00000001/sig00000033 ;
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000041  (
    .I0(a[15]),
    .I1(b[15]),
    .O(\blk00000001/sig00000052 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000040  (
    .I0(a[14]),
    .I1(b[14]),
    .O(\blk00000001/sig00000044 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003f  (
    .I0(a[13]),
    .I1(b[13]),
    .O(\blk00000001/sig00000045 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003e  (
    .I0(a[12]),
    .I1(b[12]),
    .O(\blk00000001/sig00000046 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003d  (
    .I0(a[11]),
    .I1(b[11]),
    .O(\blk00000001/sig00000047 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003c  (
    .I0(a[10]),
    .I1(b[10]),
    .O(\blk00000001/sig00000048 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003b  (
    .I0(a[9]),
    .I1(b[9]),
    .O(\blk00000001/sig00000049 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000003a  (
    .I0(a[8]),
    .I1(b[8]),
    .O(\blk00000001/sig0000004a )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000039  (
    .I0(a[7]),
    .I1(b[7]),
    .O(\blk00000001/sig0000004b )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000038  (
    .I0(a[6]),
    .I1(b[6]),
    .O(\blk00000001/sig0000004c )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000037  (
    .I0(a[5]),
    .I1(b[5]),
    .O(\blk00000001/sig0000004d )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000036  (
    .I0(a[4]),
    .I1(b[4]),
    .O(\blk00000001/sig0000004e )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000035  (
    .I0(a[3]),
    .I1(b[3]),
    .O(\blk00000001/sig0000004f )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000034  (
    .I0(a[2]),
    .I1(b[2]),
    .O(\blk00000001/sig00000050 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000033  (
    .I0(a[1]),
    .I1(b[1]),
    .O(\blk00000001/sig00000051 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000032  (
    .I0(a[0]),
    .I1(b[0]),
    .O(\blk00000001/sig00000053 )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000031  (
    .C(clk),
    .D(\blk00000001/sig00000034 ),
    .R(sclr),
    .Q(s[0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000030  (
    .C(clk),
    .D(\blk00000001/sig00000043 ),
    .R(sclr),
    .Q(s[1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002f  (
    .C(clk),
    .D(\blk00000001/sig00000042 ),
    .R(sclr),
    .Q(s[2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002e  (
    .C(clk),
    .D(\blk00000001/sig00000041 ),
    .R(sclr),
    .Q(s[3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002d  (
    .C(clk),
    .D(\blk00000001/sig00000040 ),
    .R(sclr),
    .Q(s[4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002c  (
    .C(clk),
    .D(\blk00000001/sig0000003f ),
    .R(sclr),
    .Q(s[5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002b  (
    .C(clk),
    .D(\blk00000001/sig0000003e ),
    .R(sclr),
    .Q(s[6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000002a  (
    .C(clk),
    .D(\blk00000001/sig0000003d ),
    .R(sclr),
    .Q(s[7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000029  (
    .C(clk),
    .D(\blk00000001/sig0000003c ),
    .R(sclr),
    .Q(s[8])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000028  (
    .C(clk),
    .D(\blk00000001/sig0000003b ),
    .R(sclr),
    .Q(s[9])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000027  (
    .C(clk),
    .D(\blk00000001/sig0000003a ),
    .R(sclr),
    .Q(s[10])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000026  (
    .C(clk),
    .D(\blk00000001/sig00000039 ),
    .R(sclr),
    .Q(s[11])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000025  (
    .C(clk),
    .D(\blk00000001/sig00000038 ),
    .R(sclr),
    .Q(s[12])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000024  (
    .C(clk),
    .D(\blk00000001/sig00000037 ),
    .R(sclr),
    .Q(s[13])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000023  (
    .C(clk),
    .D(\blk00000001/sig00000036 ),
    .R(sclr),
    .Q(s[14])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000022  (
    .C(clk),
    .D(\blk00000001/sig00000035 ),
    .R(sclr),
    .Q(s[15])
  );
  MUXCY   \blk00000001/blk00000021  (
    .CI(\blk00000001/sig00000033 ),
    .DI(a[0]),
    .S(\blk00000001/sig00000053 ),
    .O(\blk00000001/sig00000062 )
  );
  MUXCY   \blk00000001/blk00000020  (
    .CI(\blk00000001/sig00000062 ),
    .DI(a[1]),
    .S(\blk00000001/sig00000051 ),
    .O(\blk00000001/sig00000061 )
  );
  MUXCY   \blk00000001/blk0000001f  (
    .CI(\blk00000001/sig00000061 ),
    .DI(a[2]),
    .S(\blk00000001/sig00000050 ),
    .O(\blk00000001/sig00000060 )
  );
  MUXCY   \blk00000001/blk0000001e  (
    .CI(\blk00000001/sig00000060 ),
    .DI(a[3]),
    .S(\blk00000001/sig0000004f ),
    .O(\blk00000001/sig0000005f )
  );
  MUXCY   \blk00000001/blk0000001d  (
    .CI(\blk00000001/sig0000005f ),
    .DI(a[4]),
    .S(\blk00000001/sig0000004e ),
    .O(\blk00000001/sig0000005e )
  );
  MUXCY   \blk00000001/blk0000001c  (
    .CI(\blk00000001/sig0000005e ),
    .DI(a[5]),
    .S(\blk00000001/sig0000004d ),
    .O(\blk00000001/sig0000005d )
  );
  MUXCY   \blk00000001/blk0000001b  (
    .CI(\blk00000001/sig0000005d ),
    .DI(a[6]),
    .S(\blk00000001/sig0000004c ),
    .O(\blk00000001/sig0000005c )
  );
  MUXCY   \blk00000001/blk0000001a  (
    .CI(\blk00000001/sig0000005c ),
    .DI(a[7]),
    .S(\blk00000001/sig0000004b ),
    .O(\blk00000001/sig0000005b )
  );
  MUXCY   \blk00000001/blk00000019  (
    .CI(\blk00000001/sig0000005b ),
    .DI(a[8]),
    .S(\blk00000001/sig0000004a ),
    .O(\blk00000001/sig0000005a )
  );
  MUXCY   \blk00000001/blk00000018  (
    .CI(\blk00000001/sig0000005a ),
    .DI(a[9]),
    .S(\blk00000001/sig00000049 ),
    .O(\blk00000001/sig00000059 )
  );
  MUXCY   \blk00000001/blk00000017  (
    .CI(\blk00000001/sig00000059 ),
    .DI(a[10]),
    .S(\blk00000001/sig00000048 ),
    .O(\blk00000001/sig00000058 )
  );
  MUXCY   \blk00000001/blk00000016  (
    .CI(\blk00000001/sig00000058 ),
    .DI(a[11]),
    .S(\blk00000001/sig00000047 ),
    .O(\blk00000001/sig00000057 )
  );
  MUXCY   \blk00000001/blk00000015  (
    .CI(\blk00000001/sig00000057 ),
    .DI(a[12]),
    .S(\blk00000001/sig00000046 ),
    .O(\blk00000001/sig00000056 )
  );
  MUXCY   \blk00000001/blk00000014  (
    .CI(\blk00000001/sig00000056 ),
    .DI(a[13]),
    .S(\blk00000001/sig00000045 ),
    .O(\blk00000001/sig00000055 )
  );
  MUXCY   \blk00000001/blk00000013  (
    .CI(\blk00000001/sig00000055 ),
    .DI(a[14]),
    .S(\blk00000001/sig00000044 ),
    .O(\blk00000001/sig00000054 )
  );
  XORCY   \blk00000001/blk00000012  (
    .CI(\blk00000001/sig00000062 ),
    .LI(\blk00000001/sig00000051 ),
    .O(\blk00000001/sig00000043 )
  );
  XORCY   \blk00000001/blk00000011  (
    .CI(\blk00000001/sig00000061 ),
    .LI(\blk00000001/sig00000050 ),
    .O(\blk00000001/sig00000042 )
  );
  XORCY   \blk00000001/blk00000010  (
    .CI(\blk00000001/sig00000060 ),
    .LI(\blk00000001/sig0000004f ),
    .O(\blk00000001/sig00000041 )
  );
  XORCY   \blk00000001/blk0000000f  (
    .CI(\blk00000001/sig0000005f ),
    .LI(\blk00000001/sig0000004e ),
    .O(\blk00000001/sig00000040 )
  );
  XORCY   \blk00000001/blk0000000e  (
    .CI(\blk00000001/sig0000005e ),
    .LI(\blk00000001/sig0000004d ),
    .O(\blk00000001/sig0000003f )
  );
  XORCY   \blk00000001/blk0000000d  (
    .CI(\blk00000001/sig0000005d ),
    .LI(\blk00000001/sig0000004c ),
    .O(\blk00000001/sig0000003e )
  );
  XORCY   \blk00000001/blk0000000c  (
    .CI(\blk00000001/sig0000005c ),
    .LI(\blk00000001/sig0000004b ),
    .O(\blk00000001/sig0000003d )
  );
  XORCY   \blk00000001/blk0000000b  (
    .CI(\blk00000001/sig0000005b ),
    .LI(\blk00000001/sig0000004a ),
    .O(\blk00000001/sig0000003c )
  );
  XORCY   \blk00000001/blk0000000a  (
    .CI(\blk00000001/sig0000005a ),
    .LI(\blk00000001/sig00000049 ),
    .O(\blk00000001/sig0000003b )
  );
  XORCY   \blk00000001/blk00000009  (
    .CI(\blk00000001/sig00000059 ),
    .LI(\blk00000001/sig00000048 ),
    .O(\blk00000001/sig0000003a )
  );
  XORCY   \blk00000001/blk00000008  (
    .CI(\blk00000001/sig00000058 ),
    .LI(\blk00000001/sig00000047 ),
    .O(\blk00000001/sig00000039 )
  );
  XORCY   \blk00000001/blk00000007  (
    .CI(\blk00000001/sig00000057 ),
    .LI(\blk00000001/sig00000046 ),
    .O(\blk00000001/sig00000038 )
  );
  XORCY   \blk00000001/blk00000006  (
    .CI(\blk00000001/sig00000056 ),
    .LI(\blk00000001/sig00000045 ),
    .O(\blk00000001/sig00000037 )
  );
  XORCY   \blk00000001/blk00000005  (
    .CI(\blk00000001/sig00000055 ),
    .LI(\blk00000001/sig00000044 ),
    .O(\blk00000001/sig00000036 )
  );
  XORCY   \blk00000001/blk00000004  (
    .CI(\blk00000001/sig00000054 ),
    .LI(\blk00000001/sig00000052 ),
    .O(\blk00000001/sig00000035 )
  );
  XORCY   \blk00000001/blk00000003  (
    .CI(\blk00000001/sig00000033 ),
    .LI(\blk00000001/sig00000053 ),
    .O(\blk00000001/sig00000034 )
  );
  GND   \blk00000001/blk00000002  (
    .G(\blk00000001/sig00000033 )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

// synthesis translate_on
