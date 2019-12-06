////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: adder.v
// /___/   /\     Timestamp: Sun Nov 04 21:02:02 2018
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/adder.ngc E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/adder.v 
// Device	: 6vlx240tff1156-1
// Input file	: E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/adder.ngc
// Output file	: E:/6-RSR-1G/8-liuwei/PSR_DDC_150M_V1.1/ipcore_dir/tmp/_cg/adder.v
// # of Modules	: 1
// Design Name	: adder
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

module adder (
  clk, sclr, a, b, s
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input sclr;
  input [45 : 0] a;
  input [45 : 0] b;
  output [46 : 0] s;
  
  // synthesis translate_off
  
  wire \blk00000001/sig0000011a ;
  wire \blk00000001/sig00000119 ;
  wire \blk00000001/sig00000118 ;
  wire \blk00000001/sig00000117 ;
  wire \blk00000001/sig00000116 ;
  wire \blk00000001/sig00000115 ;
  wire \blk00000001/sig00000114 ;
  wire \blk00000001/sig00000113 ;
  wire \blk00000001/sig00000112 ;
  wire \blk00000001/sig00000111 ;
  wire \blk00000001/sig00000110 ;
  wire \blk00000001/sig0000010f ;
  wire \blk00000001/sig0000010e ;
  wire \blk00000001/sig0000010d ;
  wire \blk00000001/sig0000010c ;
  wire \blk00000001/sig0000010b ;
  wire \blk00000001/sig0000010a ;
  wire \blk00000001/sig00000109 ;
  wire \blk00000001/sig00000108 ;
  wire \blk00000001/sig00000107 ;
  wire \blk00000001/sig00000106 ;
  wire \blk00000001/sig00000105 ;
  wire \blk00000001/sig00000104 ;
  wire \blk00000001/sig00000103 ;
  wire \blk00000001/sig00000102 ;
  wire \blk00000001/sig00000101 ;
  wire \blk00000001/sig00000100 ;
  wire \blk00000001/sig000000ff ;
  wire \blk00000001/sig000000fe ;
  wire \blk00000001/sig000000fd ;
  wire \blk00000001/sig000000fc ;
  wire \blk00000001/sig000000fb ;
  wire \blk00000001/sig000000fa ;
  wire \blk00000001/sig000000f9 ;
  wire \blk00000001/sig000000f8 ;
  wire \blk00000001/sig000000f7 ;
  wire \blk00000001/sig000000f6 ;
  wire \blk00000001/sig000000f5 ;
  wire \blk00000001/sig000000f4 ;
  wire \blk00000001/sig000000f3 ;
  wire \blk00000001/sig000000f2 ;
  wire \blk00000001/sig000000f1 ;
  wire \blk00000001/sig000000f0 ;
  wire \blk00000001/sig000000ef ;
  wire \blk00000001/sig000000ee ;
  wire \blk00000001/sig000000ed ;
  wire \blk00000001/sig000000ec ;
  wire \blk00000001/sig000000eb ;
  wire \blk00000001/sig000000ea ;
  wire \blk00000001/sig000000e9 ;
  wire \blk00000001/sig000000e8 ;
  wire \blk00000001/sig000000e7 ;
  wire \blk00000001/sig000000e6 ;
  wire \blk00000001/sig000000e5 ;
  wire \blk00000001/sig000000e4 ;
  wire \blk00000001/sig000000e3 ;
  wire \blk00000001/sig000000e2 ;
  wire \blk00000001/sig000000e1 ;
  wire \blk00000001/sig000000e0 ;
  wire \blk00000001/sig000000df ;
  wire \blk00000001/sig000000de ;
  wire \blk00000001/sig000000dd ;
  wire \blk00000001/sig000000dc ;
  wire \blk00000001/sig000000db ;
  wire \blk00000001/sig000000da ;
  wire \blk00000001/sig000000d9 ;
  wire \blk00000001/sig000000d8 ;
  wire \blk00000001/sig000000d7 ;
  wire \blk00000001/sig000000d6 ;
  wire \blk00000001/sig000000d5 ;
  wire \blk00000001/sig000000d4 ;
  wire \blk00000001/sig000000d3 ;
  wire \blk00000001/sig000000d2 ;
  wire \blk00000001/sig000000d1 ;
  wire \blk00000001/sig000000d0 ;
  wire \blk00000001/sig000000cf ;
  wire \blk00000001/sig000000ce ;
  wire \blk00000001/sig000000cd ;
  wire \blk00000001/sig000000cc ;
  wire \blk00000001/sig000000cb ;
  wire \blk00000001/sig000000ca ;
  wire \blk00000001/sig000000c9 ;
  wire \blk00000001/sig000000c8 ;
  wire \blk00000001/sig000000c7 ;
  wire \blk00000001/sig000000c6 ;
  wire \blk00000001/sig000000c5 ;
  wire \blk00000001/sig000000c4 ;
  wire \blk00000001/sig000000c3 ;
  wire \blk00000001/sig000000c2 ;
  wire \blk00000001/sig000000c1 ;
  wire \blk00000001/sig000000c0 ;
  wire \blk00000001/sig000000bf ;
  wire \blk00000001/sig000000be ;
  wire \blk00000001/sig000000bd ;
  wire \blk00000001/sig000000bc ;
  wire \blk00000001/sig000000bb ;
  wire \blk00000001/sig000000ba ;
  wire \blk00000001/sig000000b9 ;
  wire \blk00000001/sig000000b8 ;
  wire \blk00000001/sig000000b7 ;
  wire \blk00000001/sig000000b6 ;
  wire \blk00000001/sig000000b5 ;
  wire \blk00000001/sig000000b4 ;
  wire \blk00000001/sig000000b3 ;
  wire \blk00000001/sig000000b2 ;
  wire \blk00000001/sig000000b1 ;
  wire \blk00000001/sig000000b0 ;
  wire \blk00000001/sig000000af ;
  wire \blk00000001/sig000000ae ;
  wire \blk00000001/sig000000ad ;
  wire \blk00000001/sig000000ac ;
  wire \blk00000001/sig000000ab ;
  wire \blk00000001/sig000000aa ;
  wire \blk00000001/sig000000a9 ;
  wire \blk00000001/sig000000a8 ;
  wire \blk00000001/sig000000a7 ;
  wire \blk00000001/sig000000a6 ;
  wire \blk00000001/sig000000a5 ;
  wire \blk00000001/sig000000a4 ;
  wire \blk00000001/sig000000a3 ;
  wire \blk00000001/sig000000a2 ;
  wire \blk00000001/sig000000a1 ;
  wire \blk00000001/sig000000a0 ;
  wire \blk00000001/sig0000009f ;
  wire \blk00000001/sig0000009e ;
  wire \blk00000001/sig0000009d ;
  wire \blk00000001/sig0000009c ;
  wire \blk00000001/sig0000009b ;
  wire \blk00000001/sig0000009a ;
  wire \blk00000001/sig00000099 ;
  wire \blk00000001/sig00000098 ;
  wire \blk00000001/sig00000097 ;
  wire \blk00000001/sig00000096 ;
  wire \blk00000001/sig00000095 ;
  wire \blk00000001/sig00000094 ;
  wire \blk00000001/sig00000093 ;
  wire \blk00000001/sig00000092 ;
  wire \blk00000001/sig00000091 ;
  wire \blk00000001/sig00000090 ;
  wire \blk00000001/sig0000008f ;
  wire \blk00000001/sig0000008e ;
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000bd  (
    .I0(a[45]),
    .I1(b[45]),
    .O(\blk00000001/sig0000011a )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000bc  (
    .I0(a[45]),
    .I1(b[45]),
    .O(\blk00000001/sig000000be )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000bb  (
    .I0(a[44]),
    .I1(b[44]),
    .O(\blk00000001/sig000000bf )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000ba  (
    .I0(a[43]),
    .I1(b[43]),
    .O(\blk00000001/sig000000c0 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b9  (
    .I0(a[42]),
    .I1(b[42]),
    .O(\blk00000001/sig000000c1 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b8  (
    .I0(a[41]),
    .I1(b[41]),
    .O(\blk00000001/sig000000c2 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b7  (
    .I0(a[40]),
    .I1(b[40]),
    .O(\blk00000001/sig000000c3 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b6  (
    .I0(a[39]),
    .I1(b[39]),
    .O(\blk00000001/sig000000c4 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b5  (
    .I0(a[38]),
    .I1(b[38]),
    .O(\blk00000001/sig000000c5 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b4  (
    .I0(a[37]),
    .I1(b[37]),
    .O(\blk00000001/sig000000c6 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b3  (
    .I0(a[36]),
    .I1(b[36]),
    .O(\blk00000001/sig000000c7 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b2  (
    .I0(a[35]),
    .I1(b[35]),
    .O(\blk00000001/sig000000c8 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b1  (
    .I0(a[34]),
    .I1(b[34]),
    .O(\blk00000001/sig000000c9 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000b0  (
    .I0(a[33]),
    .I1(b[33]),
    .O(\blk00000001/sig000000ca )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000af  (
    .I0(a[32]),
    .I1(b[32]),
    .O(\blk00000001/sig000000cb )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000ae  (
    .I0(a[31]),
    .I1(b[31]),
    .O(\blk00000001/sig000000cc )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000ad  (
    .I0(a[30]),
    .I1(b[30]),
    .O(\blk00000001/sig000000cd )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000ac  (
    .I0(a[29]),
    .I1(b[29]),
    .O(\blk00000001/sig000000ce )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000ab  (
    .I0(a[28]),
    .I1(b[28]),
    .O(\blk00000001/sig000000cf )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000aa  (
    .I0(a[27]),
    .I1(b[27]),
    .O(\blk00000001/sig000000d0 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a9  (
    .I0(a[26]),
    .I1(b[26]),
    .O(\blk00000001/sig000000d1 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a8  (
    .I0(a[25]),
    .I1(b[25]),
    .O(\blk00000001/sig000000d2 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a7  (
    .I0(a[24]),
    .I1(b[24]),
    .O(\blk00000001/sig000000d3 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a6  (
    .I0(a[23]),
    .I1(b[23]),
    .O(\blk00000001/sig000000d4 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a5  (
    .I0(a[22]),
    .I1(b[22]),
    .O(\blk00000001/sig000000d5 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a4  (
    .I0(a[21]),
    .I1(b[21]),
    .O(\blk00000001/sig000000d6 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a3  (
    .I0(a[20]),
    .I1(b[20]),
    .O(\blk00000001/sig000000d7 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a2  (
    .I0(a[19]),
    .I1(b[19]),
    .O(\blk00000001/sig000000d8 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a1  (
    .I0(a[18]),
    .I1(b[18]),
    .O(\blk00000001/sig000000d9 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk000000a0  (
    .I0(a[17]),
    .I1(b[17]),
    .O(\blk00000001/sig000000da )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009f  (
    .I0(a[16]),
    .I1(b[16]),
    .O(\blk00000001/sig000000db )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009e  (
    .I0(a[15]),
    .I1(b[15]),
    .O(\blk00000001/sig000000dc )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009d  (
    .I0(a[14]),
    .I1(b[14]),
    .O(\blk00000001/sig000000dd )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009c  (
    .I0(a[13]),
    .I1(b[13]),
    .O(\blk00000001/sig000000de )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009b  (
    .I0(a[12]),
    .I1(b[12]),
    .O(\blk00000001/sig000000df )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000009a  (
    .I0(a[11]),
    .I1(b[11]),
    .O(\blk00000001/sig000000e0 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000099  (
    .I0(a[10]),
    .I1(b[10]),
    .O(\blk00000001/sig000000e1 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000098  (
    .I0(a[9]),
    .I1(b[9]),
    .O(\blk00000001/sig000000e2 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000097  (
    .I0(a[8]),
    .I1(b[8]),
    .O(\blk00000001/sig000000e3 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000096  (
    .I0(a[7]),
    .I1(b[7]),
    .O(\blk00000001/sig000000e4 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000095  (
    .I0(a[6]),
    .I1(b[6]),
    .O(\blk00000001/sig000000e5 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000094  (
    .I0(a[5]),
    .I1(b[5]),
    .O(\blk00000001/sig000000e6 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000093  (
    .I0(a[4]),
    .I1(b[4]),
    .O(\blk00000001/sig000000e7 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000092  (
    .I0(a[3]),
    .I1(b[3]),
    .O(\blk00000001/sig000000e8 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000091  (
    .I0(a[2]),
    .I1(b[2]),
    .O(\blk00000001/sig000000e9 )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk00000090  (
    .I0(a[1]),
    .I1(b[1]),
    .O(\blk00000001/sig000000ea )
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  \blk00000001/blk0000008f  (
    .I0(a[0]),
    .I1(b[0]),
    .O(\blk00000001/sig000000eb )
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000008e  (
    .C(clk),
    .D(\blk00000001/sig0000008f ),
    .R(sclr),
    .Q(s[0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000008d  (
    .C(clk),
    .D(\blk00000001/sig000000bd ),
    .R(sclr),
    .Q(s[1])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000008c  (
    .C(clk),
    .D(\blk00000001/sig000000bc ),
    .R(sclr),
    .Q(s[2])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000008b  (
    .C(clk),
    .D(\blk00000001/sig000000bb ),
    .R(sclr),
    .Q(s[3])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000008a  (
    .C(clk),
    .D(\blk00000001/sig000000ba ),
    .R(sclr),
    .Q(s[4])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000089  (
    .C(clk),
    .D(\blk00000001/sig000000b9 ),
    .R(sclr),
    .Q(s[5])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000088  (
    .C(clk),
    .D(\blk00000001/sig000000b8 ),
    .R(sclr),
    .Q(s[6])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000087  (
    .C(clk),
    .D(\blk00000001/sig000000b7 ),
    .R(sclr),
    .Q(s[7])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000086  (
    .C(clk),
    .D(\blk00000001/sig000000b6 ),
    .R(sclr),
    .Q(s[8])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000085  (
    .C(clk),
    .D(\blk00000001/sig000000b5 ),
    .R(sclr),
    .Q(s[9])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000084  (
    .C(clk),
    .D(\blk00000001/sig000000b4 ),
    .R(sclr),
    .Q(s[10])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000083  (
    .C(clk),
    .D(\blk00000001/sig000000b3 ),
    .R(sclr),
    .Q(s[11])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000082  (
    .C(clk),
    .D(\blk00000001/sig000000b2 ),
    .R(sclr),
    .Q(s[12])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000081  (
    .C(clk),
    .D(\blk00000001/sig000000b1 ),
    .R(sclr),
    .Q(s[13])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000080  (
    .C(clk),
    .D(\blk00000001/sig000000b0 ),
    .R(sclr),
    .Q(s[14])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007f  (
    .C(clk),
    .D(\blk00000001/sig000000af ),
    .R(sclr),
    .Q(s[15])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007e  (
    .C(clk),
    .D(\blk00000001/sig000000ae ),
    .R(sclr),
    .Q(s[16])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007d  (
    .C(clk),
    .D(\blk00000001/sig000000ad ),
    .R(sclr),
    .Q(s[17])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007c  (
    .C(clk),
    .D(\blk00000001/sig000000ac ),
    .R(sclr),
    .Q(s[18])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007b  (
    .C(clk),
    .D(\blk00000001/sig000000ab ),
    .R(sclr),
    .Q(s[19])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000007a  (
    .C(clk),
    .D(\blk00000001/sig000000aa ),
    .R(sclr),
    .Q(s[20])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000079  (
    .C(clk),
    .D(\blk00000001/sig000000a9 ),
    .R(sclr),
    .Q(s[21])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000078  (
    .C(clk),
    .D(\blk00000001/sig000000a8 ),
    .R(sclr),
    .Q(s[22])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000077  (
    .C(clk),
    .D(\blk00000001/sig000000a7 ),
    .R(sclr),
    .Q(s[23])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000076  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .R(sclr),
    .Q(s[24])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000075  (
    .C(clk),
    .D(\blk00000001/sig000000a5 ),
    .R(sclr),
    .Q(s[25])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000074  (
    .C(clk),
    .D(\blk00000001/sig000000a4 ),
    .R(sclr),
    .Q(s[26])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000073  (
    .C(clk),
    .D(\blk00000001/sig000000a3 ),
    .R(sclr),
    .Q(s[27])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000072  (
    .C(clk),
    .D(\blk00000001/sig000000a2 ),
    .R(sclr),
    .Q(s[28])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000071  (
    .C(clk),
    .D(\blk00000001/sig000000a1 ),
    .R(sclr),
    .Q(s[29])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000070  (
    .C(clk),
    .D(\blk00000001/sig000000a0 ),
    .R(sclr),
    .Q(s[30])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006f  (
    .C(clk),
    .D(\blk00000001/sig0000009f ),
    .R(sclr),
    .Q(s[31])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006e  (
    .C(clk),
    .D(\blk00000001/sig0000009e ),
    .R(sclr),
    .Q(s[32])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006d  (
    .C(clk),
    .D(\blk00000001/sig0000009d ),
    .R(sclr),
    .Q(s[33])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006c  (
    .C(clk),
    .D(\blk00000001/sig0000009c ),
    .R(sclr),
    .Q(s[34])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006b  (
    .C(clk),
    .D(\blk00000001/sig0000009b ),
    .R(sclr),
    .Q(s[35])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000006a  (
    .C(clk),
    .D(\blk00000001/sig0000009a ),
    .R(sclr),
    .Q(s[36])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000069  (
    .C(clk),
    .D(\blk00000001/sig00000099 ),
    .R(sclr),
    .Q(s[37])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000068  (
    .C(clk),
    .D(\blk00000001/sig00000098 ),
    .R(sclr),
    .Q(s[38])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000067  (
    .C(clk),
    .D(\blk00000001/sig00000097 ),
    .R(sclr),
    .Q(s[39])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000066  (
    .C(clk),
    .D(\blk00000001/sig00000096 ),
    .R(sclr),
    .Q(s[40])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000065  (
    .C(clk),
    .D(\blk00000001/sig00000095 ),
    .R(sclr),
    .Q(s[41])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000064  (
    .C(clk),
    .D(\blk00000001/sig00000094 ),
    .R(sclr),
    .Q(s[42])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000063  (
    .C(clk),
    .D(\blk00000001/sig00000093 ),
    .R(sclr),
    .Q(s[43])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000062  (
    .C(clk),
    .D(\blk00000001/sig00000092 ),
    .R(sclr),
    .Q(s[44])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000061  (
    .C(clk),
    .D(\blk00000001/sig00000091 ),
    .R(sclr),
    .Q(s[45])
  );
  FDR #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000060  (
    .C(clk),
    .D(\blk00000001/sig00000090 ),
    .R(sclr),
    .Q(s[46])
  );
  MUXCY   \blk00000001/blk0000005f  (
    .CI(\blk00000001/sig0000008e ),
    .DI(a[0]),
    .S(\blk00000001/sig000000eb ),
    .O(\blk00000001/sig00000119 )
  );
  MUXCY   \blk00000001/blk0000005e  (
    .CI(\blk00000001/sig00000119 ),
    .DI(a[1]),
    .S(\blk00000001/sig000000ea ),
    .O(\blk00000001/sig00000118 )
  );
  MUXCY   \blk00000001/blk0000005d  (
    .CI(\blk00000001/sig00000118 ),
    .DI(a[2]),
    .S(\blk00000001/sig000000e9 ),
    .O(\blk00000001/sig00000117 )
  );
  MUXCY   \blk00000001/blk0000005c  (
    .CI(\blk00000001/sig00000117 ),
    .DI(a[3]),
    .S(\blk00000001/sig000000e8 ),
    .O(\blk00000001/sig00000116 )
  );
  MUXCY   \blk00000001/blk0000005b  (
    .CI(\blk00000001/sig00000116 ),
    .DI(a[4]),
    .S(\blk00000001/sig000000e7 ),
    .O(\blk00000001/sig00000115 )
  );
  MUXCY   \blk00000001/blk0000005a  (
    .CI(\blk00000001/sig00000115 ),
    .DI(a[5]),
    .S(\blk00000001/sig000000e6 ),
    .O(\blk00000001/sig00000114 )
  );
  MUXCY   \blk00000001/blk00000059  (
    .CI(\blk00000001/sig00000114 ),
    .DI(a[6]),
    .S(\blk00000001/sig000000e5 ),
    .O(\blk00000001/sig00000113 )
  );
  MUXCY   \blk00000001/blk00000058  (
    .CI(\blk00000001/sig00000113 ),
    .DI(a[7]),
    .S(\blk00000001/sig000000e4 ),
    .O(\blk00000001/sig00000112 )
  );
  MUXCY   \blk00000001/blk00000057  (
    .CI(\blk00000001/sig00000112 ),
    .DI(a[8]),
    .S(\blk00000001/sig000000e3 ),
    .O(\blk00000001/sig00000111 )
  );
  MUXCY   \blk00000001/blk00000056  (
    .CI(\blk00000001/sig00000111 ),
    .DI(a[9]),
    .S(\blk00000001/sig000000e2 ),
    .O(\blk00000001/sig00000110 )
  );
  MUXCY   \blk00000001/blk00000055  (
    .CI(\blk00000001/sig00000110 ),
    .DI(a[10]),
    .S(\blk00000001/sig000000e1 ),
    .O(\blk00000001/sig0000010f )
  );
  MUXCY   \blk00000001/blk00000054  (
    .CI(\blk00000001/sig0000010f ),
    .DI(a[11]),
    .S(\blk00000001/sig000000e0 ),
    .O(\blk00000001/sig0000010e )
  );
  MUXCY   \blk00000001/blk00000053  (
    .CI(\blk00000001/sig0000010e ),
    .DI(a[12]),
    .S(\blk00000001/sig000000df ),
    .O(\blk00000001/sig0000010d )
  );
  MUXCY   \blk00000001/blk00000052  (
    .CI(\blk00000001/sig0000010d ),
    .DI(a[13]),
    .S(\blk00000001/sig000000de ),
    .O(\blk00000001/sig0000010c )
  );
  MUXCY   \blk00000001/blk00000051  (
    .CI(\blk00000001/sig0000010c ),
    .DI(a[14]),
    .S(\blk00000001/sig000000dd ),
    .O(\blk00000001/sig0000010b )
  );
  MUXCY   \blk00000001/blk00000050  (
    .CI(\blk00000001/sig0000010b ),
    .DI(a[15]),
    .S(\blk00000001/sig000000dc ),
    .O(\blk00000001/sig0000010a )
  );
  MUXCY   \blk00000001/blk0000004f  (
    .CI(\blk00000001/sig0000010a ),
    .DI(a[16]),
    .S(\blk00000001/sig000000db ),
    .O(\blk00000001/sig00000109 )
  );
  MUXCY   \blk00000001/blk0000004e  (
    .CI(\blk00000001/sig00000109 ),
    .DI(a[17]),
    .S(\blk00000001/sig000000da ),
    .O(\blk00000001/sig00000108 )
  );
  MUXCY   \blk00000001/blk0000004d  (
    .CI(\blk00000001/sig00000108 ),
    .DI(a[18]),
    .S(\blk00000001/sig000000d9 ),
    .O(\blk00000001/sig00000107 )
  );
  MUXCY   \blk00000001/blk0000004c  (
    .CI(\blk00000001/sig00000107 ),
    .DI(a[19]),
    .S(\blk00000001/sig000000d8 ),
    .O(\blk00000001/sig00000106 )
  );
  MUXCY   \blk00000001/blk0000004b  (
    .CI(\blk00000001/sig00000106 ),
    .DI(a[20]),
    .S(\blk00000001/sig000000d7 ),
    .O(\blk00000001/sig00000105 )
  );
  MUXCY   \blk00000001/blk0000004a  (
    .CI(\blk00000001/sig00000105 ),
    .DI(a[21]),
    .S(\blk00000001/sig000000d6 ),
    .O(\blk00000001/sig00000104 )
  );
  MUXCY   \blk00000001/blk00000049  (
    .CI(\blk00000001/sig00000104 ),
    .DI(a[22]),
    .S(\blk00000001/sig000000d5 ),
    .O(\blk00000001/sig00000103 )
  );
  MUXCY   \blk00000001/blk00000048  (
    .CI(\blk00000001/sig00000103 ),
    .DI(a[23]),
    .S(\blk00000001/sig000000d4 ),
    .O(\blk00000001/sig00000102 )
  );
  MUXCY   \blk00000001/blk00000047  (
    .CI(\blk00000001/sig00000102 ),
    .DI(a[24]),
    .S(\blk00000001/sig000000d3 ),
    .O(\blk00000001/sig00000101 )
  );
  MUXCY   \blk00000001/blk00000046  (
    .CI(\blk00000001/sig00000101 ),
    .DI(a[25]),
    .S(\blk00000001/sig000000d2 ),
    .O(\blk00000001/sig00000100 )
  );
  MUXCY   \blk00000001/blk00000045  (
    .CI(\blk00000001/sig00000100 ),
    .DI(a[26]),
    .S(\blk00000001/sig000000d1 ),
    .O(\blk00000001/sig000000ff )
  );
  MUXCY   \blk00000001/blk00000044  (
    .CI(\blk00000001/sig000000ff ),
    .DI(a[27]),
    .S(\blk00000001/sig000000d0 ),
    .O(\blk00000001/sig000000fe )
  );
  MUXCY   \blk00000001/blk00000043  (
    .CI(\blk00000001/sig000000fe ),
    .DI(a[28]),
    .S(\blk00000001/sig000000cf ),
    .O(\blk00000001/sig000000fd )
  );
  MUXCY   \blk00000001/blk00000042  (
    .CI(\blk00000001/sig000000fd ),
    .DI(a[29]),
    .S(\blk00000001/sig000000ce ),
    .O(\blk00000001/sig000000fc )
  );
  MUXCY   \blk00000001/blk00000041  (
    .CI(\blk00000001/sig000000fc ),
    .DI(a[30]),
    .S(\blk00000001/sig000000cd ),
    .O(\blk00000001/sig000000fb )
  );
  MUXCY   \blk00000001/blk00000040  (
    .CI(\blk00000001/sig000000fb ),
    .DI(a[31]),
    .S(\blk00000001/sig000000cc ),
    .O(\blk00000001/sig000000fa )
  );
  MUXCY   \blk00000001/blk0000003f  (
    .CI(\blk00000001/sig000000fa ),
    .DI(a[32]),
    .S(\blk00000001/sig000000cb ),
    .O(\blk00000001/sig000000f9 )
  );
  MUXCY   \blk00000001/blk0000003e  (
    .CI(\blk00000001/sig000000f9 ),
    .DI(a[33]),
    .S(\blk00000001/sig000000ca ),
    .O(\blk00000001/sig000000f8 )
  );
  MUXCY   \blk00000001/blk0000003d  (
    .CI(\blk00000001/sig000000f8 ),
    .DI(a[34]),
    .S(\blk00000001/sig000000c9 ),
    .O(\blk00000001/sig000000f7 )
  );
  MUXCY   \blk00000001/blk0000003c  (
    .CI(\blk00000001/sig000000f7 ),
    .DI(a[35]),
    .S(\blk00000001/sig000000c8 ),
    .O(\blk00000001/sig000000f6 )
  );
  MUXCY   \blk00000001/blk0000003b  (
    .CI(\blk00000001/sig000000f6 ),
    .DI(a[36]),
    .S(\blk00000001/sig000000c7 ),
    .O(\blk00000001/sig000000f5 )
  );
  MUXCY   \blk00000001/blk0000003a  (
    .CI(\blk00000001/sig000000f5 ),
    .DI(a[37]),
    .S(\blk00000001/sig000000c6 ),
    .O(\blk00000001/sig000000f4 )
  );
  MUXCY   \blk00000001/blk00000039  (
    .CI(\blk00000001/sig000000f4 ),
    .DI(a[38]),
    .S(\blk00000001/sig000000c5 ),
    .O(\blk00000001/sig000000f3 )
  );
  MUXCY   \blk00000001/blk00000038  (
    .CI(\blk00000001/sig000000f3 ),
    .DI(a[39]),
    .S(\blk00000001/sig000000c4 ),
    .O(\blk00000001/sig000000f2 )
  );
  MUXCY   \blk00000001/blk00000037  (
    .CI(\blk00000001/sig000000f2 ),
    .DI(a[40]),
    .S(\blk00000001/sig000000c3 ),
    .O(\blk00000001/sig000000f1 )
  );
  MUXCY   \blk00000001/blk00000036  (
    .CI(\blk00000001/sig000000f1 ),
    .DI(a[41]),
    .S(\blk00000001/sig000000c2 ),
    .O(\blk00000001/sig000000f0 )
  );
  MUXCY   \blk00000001/blk00000035  (
    .CI(\blk00000001/sig000000f0 ),
    .DI(a[42]),
    .S(\blk00000001/sig000000c1 ),
    .O(\blk00000001/sig000000ef )
  );
  MUXCY   \blk00000001/blk00000034  (
    .CI(\blk00000001/sig000000ef ),
    .DI(a[43]),
    .S(\blk00000001/sig000000c0 ),
    .O(\blk00000001/sig000000ee )
  );
  MUXCY   \blk00000001/blk00000033  (
    .CI(\blk00000001/sig000000ee ),
    .DI(a[44]),
    .S(\blk00000001/sig000000bf ),
    .O(\blk00000001/sig000000ed )
  );
  MUXCY   \blk00000001/blk00000032  (
    .CI(\blk00000001/sig000000ed ),
    .DI(a[45]),
    .S(\blk00000001/sig0000011a ),
    .O(\blk00000001/sig000000ec )
  );
  XORCY   \blk00000001/blk00000031  (
    .CI(\blk00000001/sig00000119 ),
    .LI(\blk00000001/sig000000ea ),
    .O(\blk00000001/sig000000bd )
  );
  XORCY   \blk00000001/blk00000030  (
    .CI(\blk00000001/sig00000118 ),
    .LI(\blk00000001/sig000000e9 ),
    .O(\blk00000001/sig000000bc )
  );
  XORCY   \blk00000001/blk0000002f  (
    .CI(\blk00000001/sig00000117 ),
    .LI(\blk00000001/sig000000e8 ),
    .O(\blk00000001/sig000000bb )
  );
  XORCY   \blk00000001/blk0000002e  (
    .CI(\blk00000001/sig00000116 ),
    .LI(\blk00000001/sig000000e7 ),
    .O(\blk00000001/sig000000ba )
  );
  XORCY   \blk00000001/blk0000002d  (
    .CI(\blk00000001/sig00000115 ),
    .LI(\blk00000001/sig000000e6 ),
    .O(\blk00000001/sig000000b9 )
  );
  XORCY   \blk00000001/blk0000002c  (
    .CI(\blk00000001/sig00000114 ),
    .LI(\blk00000001/sig000000e5 ),
    .O(\blk00000001/sig000000b8 )
  );
  XORCY   \blk00000001/blk0000002b  (
    .CI(\blk00000001/sig00000113 ),
    .LI(\blk00000001/sig000000e4 ),
    .O(\blk00000001/sig000000b7 )
  );
  XORCY   \blk00000001/blk0000002a  (
    .CI(\blk00000001/sig00000112 ),
    .LI(\blk00000001/sig000000e3 ),
    .O(\blk00000001/sig000000b6 )
  );
  XORCY   \blk00000001/blk00000029  (
    .CI(\blk00000001/sig00000111 ),
    .LI(\blk00000001/sig000000e2 ),
    .O(\blk00000001/sig000000b5 )
  );
  XORCY   \blk00000001/blk00000028  (
    .CI(\blk00000001/sig00000110 ),
    .LI(\blk00000001/sig000000e1 ),
    .O(\blk00000001/sig000000b4 )
  );
  XORCY   \blk00000001/blk00000027  (
    .CI(\blk00000001/sig0000010f ),
    .LI(\blk00000001/sig000000e0 ),
    .O(\blk00000001/sig000000b3 )
  );
  XORCY   \blk00000001/blk00000026  (
    .CI(\blk00000001/sig0000010e ),
    .LI(\blk00000001/sig000000df ),
    .O(\blk00000001/sig000000b2 )
  );
  XORCY   \blk00000001/blk00000025  (
    .CI(\blk00000001/sig0000010d ),
    .LI(\blk00000001/sig000000de ),
    .O(\blk00000001/sig000000b1 )
  );
  XORCY   \blk00000001/blk00000024  (
    .CI(\blk00000001/sig0000010c ),
    .LI(\blk00000001/sig000000dd ),
    .O(\blk00000001/sig000000b0 )
  );
  XORCY   \blk00000001/blk00000023  (
    .CI(\blk00000001/sig0000010b ),
    .LI(\blk00000001/sig000000dc ),
    .O(\blk00000001/sig000000af )
  );
  XORCY   \blk00000001/blk00000022  (
    .CI(\blk00000001/sig0000010a ),
    .LI(\blk00000001/sig000000db ),
    .O(\blk00000001/sig000000ae )
  );
  XORCY   \blk00000001/blk00000021  (
    .CI(\blk00000001/sig00000109 ),
    .LI(\blk00000001/sig000000da ),
    .O(\blk00000001/sig000000ad )
  );
  XORCY   \blk00000001/blk00000020  (
    .CI(\blk00000001/sig00000108 ),
    .LI(\blk00000001/sig000000d9 ),
    .O(\blk00000001/sig000000ac )
  );
  XORCY   \blk00000001/blk0000001f  (
    .CI(\blk00000001/sig00000107 ),
    .LI(\blk00000001/sig000000d8 ),
    .O(\blk00000001/sig000000ab )
  );
  XORCY   \blk00000001/blk0000001e  (
    .CI(\blk00000001/sig00000106 ),
    .LI(\blk00000001/sig000000d7 ),
    .O(\blk00000001/sig000000aa )
  );
  XORCY   \blk00000001/blk0000001d  (
    .CI(\blk00000001/sig00000105 ),
    .LI(\blk00000001/sig000000d6 ),
    .O(\blk00000001/sig000000a9 )
  );
  XORCY   \blk00000001/blk0000001c  (
    .CI(\blk00000001/sig00000104 ),
    .LI(\blk00000001/sig000000d5 ),
    .O(\blk00000001/sig000000a8 )
  );
  XORCY   \blk00000001/blk0000001b  (
    .CI(\blk00000001/sig00000103 ),
    .LI(\blk00000001/sig000000d4 ),
    .O(\blk00000001/sig000000a7 )
  );
  XORCY   \blk00000001/blk0000001a  (
    .CI(\blk00000001/sig00000102 ),
    .LI(\blk00000001/sig000000d3 ),
    .O(\blk00000001/sig000000a6 )
  );
  XORCY   \blk00000001/blk00000019  (
    .CI(\blk00000001/sig00000101 ),
    .LI(\blk00000001/sig000000d2 ),
    .O(\blk00000001/sig000000a5 )
  );
  XORCY   \blk00000001/blk00000018  (
    .CI(\blk00000001/sig00000100 ),
    .LI(\blk00000001/sig000000d1 ),
    .O(\blk00000001/sig000000a4 )
  );
  XORCY   \blk00000001/blk00000017  (
    .CI(\blk00000001/sig000000ff ),
    .LI(\blk00000001/sig000000d0 ),
    .O(\blk00000001/sig000000a3 )
  );
  XORCY   \blk00000001/blk00000016  (
    .CI(\blk00000001/sig000000fe ),
    .LI(\blk00000001/sig000000cf ),
    .O(\blk00000001/sig000000a2 )
  );
  XORCY   \blk00000001/blk00000015  (
    .CI(\blk00000001/sig000000fd ),
    .LI(\blk00000001/sig000000ce ),
    .O(\blk00000001/sig000000a1 )
  );
  XORCY   \blk00000001/blk00000014  (
    .CI(\blk00000001/sig000000fc ),
    .LI(\blk00000001/sig000000cd ),
    .O(\blk00000001/sig000000a0 )
  );
  XORCY   \blk00000001/blk00000013  (
    .CI(\blk00000001/sig000000fb ),
    .LI(\blk00000001/sig000000cc ),
    .O(\blk00000001/sig0000009f )
  );
  XORCY   \blk00000001/blk00000012  (
    .CI(\blk00000001/sig000000fa ),
    .LI(\blk00000001/sig000000cb ),
    .O(\blk00000001/sig0000009e )
  );
  XORCY   \blk00000001/blk00000011  (
    .CI(\blk00000001/sig000000f9 ),
    .LI(\blk00000001/sig000000ca ),
    .O(\blk00000001/sig0000009d )
  );
  XORCY   \blk00000001/blk00000010  (
    .CI(\blk00000001/sig000000f8 ),
    .LI(\blk00000001/sig000000c9 ),
    .O(\blk00000001/sig0000009c )
  );
  XORCY   \blk00000001/blk0000000f  (
    .CI(\blk00000001/sig000000f7 ),
    .LI(\blk00000001/sig000000c8 ),
    .O(\blk00000001/sig0000009b )
  );
  XORCY   \blk00000001/blk0000000e  (
    .CI(\blk00000001/sig000000f6 ),
    .LI(\blk00000001/sig000000c7 ),
    .O(\blk00000001/sig0000009a )
  );
  XORCY   \blk00000001/blk0000000d  (
    .CI(\blk00000001/sig000000f5 ),
    .LI(\blk00000001/sig000000c6 ),
    .O(\blk00000001/sig00000099 )
  );
  XORCY   \blk00000001/blk0000000c  (
    .CI(\blk00000001/sig000000f4 ),
    .LI(\blk00000001/sig000000c5 ),
    .O(\blk00000001/sig00000098 )
  );
  XORCY   \blk00000001/blk0000000b  (
    .CI(\blk00000001/sig000000f3 ),
    .LI(\blk00000001/sig000000c4 ),
    .O(\blk00000001/sig00000097 )
  );
  XORCY   \blk00000001/blk0000000a  (
    .CI(\blk00000001/sig000000f2 ),
    .LI(\blk00000001/sig000000c3 ),
    .O(\blk00000001/sig00000096 )
  );
  XORCY   \blk00000001/blk00000009  (
    .CI(\blk00000001/sig000000f1 ),
    .LI(\blk00000001/sig000000c2 ),
    .O(\blk00000001/sig00000095 )
  );
  XORCY   \blk00000001/blk00000008  (
    .CI(\blk00000001/sig000000f0 ),
    .LI(\blk00000001/sig000000c1 ),
    .O(\blk00000001/sig00000094 )
  );
  XORCY   \blk00000001/blk00000007  (
    .CI(\blk00000001/sig000000ef ),
    .LI(\blk00000001/sig000000c0 ),
    .O(\blk00000001/sig00000093 )
  );
  XORCY   \blk00000001/blk00000006  (
    .CI(\blk00000001/sig000000ee ),
    .LI(\blk00000001/sig000000bf ),
    .O(\blk00000001/sig00000092 )
  );
  XORCY   \blk00000001/blk00000005  (
    .CI(\blk00000001/sig000000ed ),
    .LI(\blk00000001/sig0000011a ),
    .O(\blk00000001/sig00000091 )
  );
  XORCY   \blk00000001/blk00000004  (
    .CI(\blk00000001/sig000000ec ),
    .LI(\blk00000001/sig000000be ),
    .O(\blk00000001/sig00000090 )
  );
  XORCY   \blk00000001/blk00000003  (
    .CI(\blk00000001/sig0000008e ),
    .LI(\blk00000001/sig000000eb ),
    .O(\blk00000001/sig0000008f )
  );
  GND   \blk00000001/blk00000002  (
    .G(\blk00000001/sig0000008e )
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
