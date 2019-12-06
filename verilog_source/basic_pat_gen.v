//------------------------------------------------------------------------------
// File       : basic_pat_gen.v
// Author     : Xilinx Inc.
// Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
// File       : basic_pat_gen.v
// Version    : 2.3
//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// Description:  This module allows either a user side loopback, with address swapping,
// OR the generation of simple packets.  The selection being controlled by a top level input
// which can be sourced fdrom a DIP switch in hardware.
// The packet generation is controlled by simple parameters giving the ability to set the DA,
// SA amd max/min size packets.  The data portion of each packet is always a simple
// incrementing pattern.
// When configured to loopback the first 12 bytes of the packet are accepted and then the
// packet is output with/without address swapping.  Currently, this is hard wired in the address
// swap logic.
//
//
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module basic_pat_gen #(
    //parameter                            DEST_ADDR = 48'hda0102030405,
//	 parameter                            DEST_ADDR = 48'h74D4359BE879, //ffffffffffff
	 //parameter                            DEST_ADDR = 48'h4439C4320C00,
//    parameter                            SRC_ADDR  = 48'h5a0102030405,
	 parameter               				  MAX_SIZE  = 16'd512,
    parameter               				  MIN_SIZE  = 16'd512
)(
    input                                axi_tclk,
    input                                axi_tresetn,
    input                                check_resetn,

    input                                enable_pat_gen,
    input                                enable_pat_chk,
    input                                enable_address_swap,

    // data from the RX FIFO
    input       [7:0]                    rx_axis_fifo_tdata,
    input                                rx_axis_fifo_tvalid,
    input                                rx_axis_fifo_tlast,
    output                               rx_axis_fifo_tready,
    // data TO the tx fifo
    output      [7:0]                    tx_axis_fifo_tdata,
    output                               tx_axis_fifo_tvalid,
    output                               tx_axis_fifo_tlast,
    input                                tx_axis_fifo_tready,

    output                               frame_error,
	 
  input[7:0] data_in, 
  input start,
  input [63:0] user_data,
  output rd_clk, 
  output [8:0] addr,
  output busy,
  
  input [15:0] page_read,			//modified on 20150322, by wxh
//  input [1:0] bag,						//modified on 150211
  
  input [15:0]mode_sel,                    //150916
  
  input [47:0]SRC_ADDR,
  input [47:0]DEST_ADDR,
  input [31:0]PPS_DETECT_CNT,
  //UDP用户可定义参数
  input [31:0]SRC_IP,
  input [31:0]DEST_IP,
  input [15:0]SRC_PORT,
  input [15:0]DEST_PORT
);

wire     [7:0]       rx_axis_fifo_tdata_int;
wire                 rx_axis_fifo_tvalid_int;
wire                 rx_axis_fifo_tlast_int;
wire                 rx_axis_fifo_tready_int;

wire     [7:0]       pat_gen_tdata;
wire                 pat_gen_tvalid;
wire                 pat_gen_tlast;
wire                 pat_gen_tready;

wire     [7:0]       mux_tdata;
wire                 mux_tvalid;
wire                 mux_tlast;
wire                 mux_tready;

//wire  [8:0] addr;    //del by wxh
//wire        rd_clk; 
//wire        busy;

// basic packet generator - this has parametisable
// DA and SA fields but the LT and data will be auto-generated
// based on the min/max size parameters - these can be set
// to the same value to obtain a specific packet size or will
// increment from the lower packet size to the upper
axi_pat_gen #(
//   .DEST_ADDR                 (DEST_ADDR),
//   .SRC_ADDR                  (SRC_ADDR),
   .MAX_SIZE                  (MAX_SIZE),
   .MIN_SIZE                  (MIN_SIZE)

) axi_pat_gen (
   .axi_tclk                  (axi_tclk),
   .axi_tresetn               (axi_tresetn),

   .enable_pat_gen            (enable_pat_gen),

   .tdata                     (pat_gen_tdata),
   .tvalid                    (pat_gen_tvalid),
   .tlast                     (pat_gen_tlast),
   .tready                    (pat_gen_tready),

    .data_in(data_in), 
    .start(start), 
    .user_data(user_data), 
    .rd_clk(rd_clk),        //125MHz
    .addr(addr), 
    .busy(busy),
	 .page_read(page_read),			//modified on 150211
//	 .bag(bag), 										//modified on 150211
	 .mode_sel(mode_sel),
	 .DEST_ADDR                 (DEST_ADDR),
    .SRC_ADDR                  (SRC_ADDR),
	 .PPS_DETECT_CNT    			 (PPS_DETECT_CNT),
	 //UDP用户可定义参数
	 .SRC_IP							 (SRC_IP),
    .DEST_IP						 (DEST_IP),
    .SRC_PORT						 (SRC_PORT),
    .DEST_PORT						 (DEST_PORT)
);

axi_pat_check #(
//   .DEST_ADDR                 (DEST_ADDR),
//   .SRC_ADDR                  (SRC_ADDR),
   .MAX_SIZE                  (MAX_SIZE),
   .MIN_SIZE                  (MIN_SIZE)

) axi_pat_check (
   .axi_tclk                  (axi_tclk),
   .axi_tresetn               (check_resetn),

   .enable_pat_chk            (enable_pat_chk),

   .tdata                     (rx_axis_fifo_tdata),
   .tvalid                    (rx_axis_fifo_tvalid),
   .tlast                     (rx_axis_fifo_tlast),
   .tready                    (rx_axis_fifo_tready),

   .frame_error               (frame_error),
	
	.DEST_ADDR                 (DEST_ADDR),
   .SRC_ADDR                  (SRC_ADDR)
);

// simple mux between the rx_fifo AXI interface and the pat gen output
// this is not registered as it is passed through a pipeline stage to limit the impact
axi_mux axi_mux(
   .mux_select                (enable_pat_gen),

   .tdata0                    (rx_axis_fifo_tdata),
   .tvalid0                   (rx_axis_fifo_tvalid),
   .tlast0                    (rx_axis_fifo_tlast),
   .tready0                   (rx_axis_fifo_tready),

   .tdata1                    (pat_gen_tdata),
   .tvalid1                   (pat_gen_tvalid),
   .tlast1                    (pat_gen_tlast),
   .tready1                   (pat_gen_tready),

   .tdata                     (mux_tdata),
   .tvalid                    (mux_tvalid),
   .tlast                     (mux_tlast),
   .tready                    (mux_tready)
);

// a pipeline stage has been added to reduce timing issues and allow
// a pattern generator to be muxed into the path
axi_pipe axi_pipe (
   .axi_tclk                  (axi_tclk),
   .axi_tresetn               (axi_tresetn),

   .rx_axis_fifo_tdata_in     (mux_tdata),
   .rx_axis_fifo_tvalid_in    (mux_tvalid),
   .rx_axis_fifo_tlast_in     (mux_tlast),
   .rx_axis_fifo_tready_in    (mux_tready),

   .rx_axis_fifo_tdata_out    (rx_axis_fifo_tdata_int),
   .rx_axis_fifo_tvalid_out   (rx_axis_fifo_tvalid_int),
   .rx_axis_fifo_tlast_out    (rx_axis_fifo_tlast_int),
   .rx_axis_fifo_tready_out   (rx_axis_fifo_tready_int)

);

// address swap module: based around a Dual port distributed ram
// data is written in and the read only starts once the da/sa have been
// stored.  Can cope with a gap of one cycle between packets.
address_swap address_swap (
   .axi_tclk                  (axi_tclk),
   .axi_tresetn               (axi_tresetn),
   .en_address_swap           (enable_address_swap),

   .rx_axis_fifo_tdata        (rx_axis_fifo_tdata_int),
   .rx_axis_fifo_tvalid       (rx_axis_fifo_tvalid_int),
   .rx_axis_fifo_tlast        (rx_axis_fifo_tlast_int),
   .rx_axis_fifo_tready       (rx_axis_fifo_tready_int),

   .tx_axis_fifo_tdata        (tx_axis_fifo_tdata),
   .tx_axis_fifo_tvalid       (tx_axis_fifo_tvalid),
   .tx_axis_fifo_tlast        (tx_axis_fifo_tlast),
   .tx_axis_fifo_tready       (tx_axis_fifo_tready)
  );


endmodule