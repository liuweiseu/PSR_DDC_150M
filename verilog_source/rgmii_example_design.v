//------------------------------------------------------------------------------
// Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
// File       : gmii_example_design.v
// Version    : 2.3
//-----------------------------------------------------------------------------
//
// (c) Copyright 2004-2011 Xilinx, Inc. All rights reserved.
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
// Description:  This is the Verilog example design for the Virtex-6
//               Embedded Tri-Mode Ethernet MAC. It is intended that this
//               example design can be quickly adapted and downloaded onto
//               an FPGA to provide a real hardware test environment.
//
//               This level:
//
//               * Instantiates the FIFO Block wrapper, containing the
//                 block level wrapper and an RX and TX FIFO with an
//                 AXI-S interface;
//
//               * Instantiates a simple AXI-S example design,
//                 providing an address swap and a simple
//                 loopback function;
//
//               * Instantiates transmitter clocking circuitry
//                   -the User side of the FIFOs are clocked at gtx_clk
//                    at all times
//
//               * Instantiates a state machine which drives the AXI Lite
//                 interface to bring the TEMAC up in the correct state
//
//               * Serializes the Statistics vectors to prevent logic being
//                 optimized out
//
//               * Ties unused inputs off to reduce the number of IO
//
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-6 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//
//
//    ---------------------------------------------------------------------
//    | EXAMPLE DESIGN WRAPPER                                            |
//    |           --------------------------------------------------------|
//    |           |FIFO BLOCK WRAPPER                                     |
//    |           |                                                       |
//    |           |                                                       |
//    |           |              -----------------------------------------|
//    |           |              | BLOCK LEVEL WRAPPER                    |
//    | --------  |              |                                        |
//    | |      |  |              |      -------------------               |
//    | | AXI  |--|--------------|----->|                 |               |
//    | | LITE |  |              |      | AXI4-Lite IPIF  |               |
//    | |  SM  |  |              |      |                 |               |
//    | |      |<-|--------------|------|                 |               |
//    | |      |  |              |      -------------------               |
//    | --------  |              |         |    |                         |
//    |           |              |    ---------------------               |
//    |           |              |    |   V6 EMAC CORE    |               |
//    |           |              |    |                   |               |
//    |           |              |    |                   |               |
//    |           |              |    |                   |               |
//    |           |              |    |                   |               |
//    | --------  |  ----------  |    |                   |               |
//    | |      |  |  |        |  |    |                   |  ---------    |
//    | |      |->|->|        |--|--->| Tx            Tx  |--|       |--->|
//    | |      |  |  |        |  |    | AXI-S         PHY |  |       |    |
//    | | ADDR |  |  |        |  |    | I/F           I/F |  |       |    |
//    | | SWAP |  |  |  AXI-S |  |    |                   |  | PHY   |    |
//    | |      |  |  |  FIFO  |  |    |                   |  | I/F   |    |
//    | |      |  |  |        |  |    |                   |  |       |    |
//    | |      |  |  |        |  |    | Rx            Rx  |  |       |    |
//    | |      |  |  |        |  |    | AX)-S         PHY |  |       |    |
//    | |      |<-|<-|        |<-|----| I/F           I/F |<-|       |<---|
//    | |      |  |  |        |  |    |                   |  ---------    |
//    | --------  |  ----------  |    ---------------------               |
//    |           |              |           |     |                      |
//    |           |              |        --------------                  |
//    |           |              |        |  STATS     |                  |
//    |           |              |        |    DECODE  |                  |
//    |           |              |        |            |                  |
//    |           |              |        --------------                  |
//    |           |              |                                        |
//    |           |              -----------------------------------------|
//    |           --------------------------------------------------------|
//    ---------------------------------------------------------------------
//
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// The entity declaration for the example_design level wrapper.
//------------------------------------------------------------------------------

module rgmii_example_design #(
	parameter BITWIDTH = 9,
	parameter FFT_POINT = 2048,
	parameter SUB_FFT_POINT = 512
)(
      // asynchronous reset
      //input         glbl_rst,

      // 200MHz clock input from board
//      input         clk_in_p,
//      input         clk_in_n,

		input clk_in,   //20Mٶƫܵǧ״⣿   q1
//		input [39:0]user_data_in,//20150912
      output        phy_resetn,
      // RGMII Interface
      //---------------

      output [3:0]  rgmii_txd,
      output        rgmii_tx_ctl,
      output        rgmii_txc,
      input  [3:0]  rgmii_rxd,
      input         rgmii_rx_ctl,
      input         rgmii_rxc,
		
      //input         mii_tx_clk, //10/100M·ʱ

      // Serialised statistics vectors to prevent logic being optimized out
      //------------------------------
      output        tx_statistics_s,
      output        rx_statistics_s,

      // Serialised Pause interface controls
      //------------------------------------
//      input         pause_req_s,

      // Main example design controls
      //-----------------------------
//      input  [1:0]  mac_speed,
//      input         update_speed,
//      input         serial_command,
      output        serial_response,
//      input         gen_tx_data,
//      input         chk_tx_data,
//      input         swap_address,
//      input         reset_error,
      output        frame_error,
      output        frame_errorn,
		input rst,
		input clk,
		input en_sync_in,
		input [10:0] cnt_sync_in,			//8bit
		input [15:0] power_com,
		input RST_66M,
		
		input [15:0]mode_sel,
		
		input rgmii_ctrl,
		input [1:0]width_ctrl,
		
		input [47:0]SRC_ADDR,
		input [47:0]DEST_ADDR,
		input [31:0]PPS_DETECT_CNT,
		//UDPûɶ
		input [31:0]SRC_IP,
		input [31:0]DEST_IP,
		input [15:0]SRC_PORT,
		input [15:0]DEST_PORT

    );


		wire  [15:0] page_read;			//modified on 150211
//		wire	[1:0] bag;						//modified on 150211




//---------------------------------------------------------------------
		wire 			 glbl_rst=0;
	   wire  [1:0]  mac_speed = 2'b10;
      wire         update_speed = 0;
      wire         serial_command = 0;
      wire         gen_tx_data = 1;
      wire         chk_tx_data = 0;
      wire         swap_address = 0;
      wire         reset_error = 0;		
      wire         pause_req_s = 0;

  wire   [7:0] dout; // input [7 : 0] din
  wire   start;
  reg   [63:0] user_data;//20150910
  wire   busy;
  wire   [8:0]  addr;
  wire    rd_clk;
	 
//---------------------------------------------------------------------
   // control parameters
   parameter            BOARD_PHY_ADDR = 5'h7;
   parameter            MAC_BASE_ADDR  = 32'h0;

   //----------------------------------------------------------------------------
   // internal signals used in this top level wrapper.
   //----------------------------------------------------------------------------

   // example design clocks
   (* KEEP = "TRUE" *)
   wire                 gtx_clk_bufg;
   (* KEEP = "TRUE" *)
   wire                 refclk_bufg;
   (* KEEP = "TRUE" *)
   wire                 s_axi_aclk;
   wire                 rx_mac_aclk;
   wire                 tx_mac_aclk;


   reg                  phy_resetn_int;
   // resets (and reset generation)
   wire                 s_axi_reset_int;
   reg                  s_axi_pre_resetn = 0;
   reg                  s_axi_resetn = 0;
   wire                 chk_reset_int;
   reg                  chk_pre_resetn = 0;
   reg                  chk_resetn = 0;
   wire                 gtx_clk_reset_int;
   reg                  gtx_pre_resetn = 0;
   reg                  gtx_resetn = 0;
   wire                 rx_reset;
   wire                 tx_reset;

   wire                 dcm_locked;
   wire                 glbl_rst_int;
   reg   [5:0]          phy_reset_count;
   wire                 glbl_rst_intn;
   // USER side RX AXI-S interface
   wire                 rx_fifo_clock;
   wire                 rx_fifo_resetn;
   wire  [7:0]          rx_axis_fifo_tdata;
   wire                 rx_axis_fifo_tvalid;
   wire                 rx_axis_fifo_tlast;
   wire                 rx_axis_fifo_tready;

   // USER side TX AXI-S interface
   wire                 tx_fifo_clock;
   wire                 tx_fifo_resetn;
   wire  [7:0]          tx_axis_fifo_tdata;
   wire                 tx_axis_fifo_tvalid;
   wire                 tx_axis_fifo_tlast;
   wire                 tx_axis_fifo_tready;

   // RX Statistics serialisation signals
   (* KEEP = "TRUE" *)
   wire                 rx_statistics_valid;
   reg                  rx_statistics_valid_reg;
   (* KEEP = "TRUE" *)
   wire  [27:0]         rx_statistics_vector;
   reg   [27:0]         rx_stats;
   reg                  rx_stats_toggle = 0;
   wire                 rx_stats_toggle_sync;
   reg                  rx_stats_toggle_sync_reg = 0;
   reg   [29:0]         rx_stats_shift;

   // TX Statistics serialisation signals
   (* KEEP = "TRUE" *)
   wire                 tx_statistics_valid;
   reg                  tx_statistics_valid_reg;
   (* KEEP = "TRUE" *)
   wire  [31:0]         tx_statistics_vector;
   reg   [31:0]         tx_stats;
   reg                  tx_stats_toggle = 0;
   wire                 tx_stats_toggle_sync;
   reg                  tx_stats_toggle_sync_reg = 0;
   reg   [33:0]         tx_stats_shift;

   // Pause interface DESerialisation
   reg   [18:0]         pause_shift;
   reg                  pause_req;
   reg   [15:0]         pause_val;


   // AXI-Lite interface
   (* KEEP = "TRUE" *)
   wire  [31:0]         s_axi_awaddr;
   (* KEEP = "TRUE" *)
   wire                 s_axi_awvalid;
   (* KEEP = "TRUE" *)
   wire                 s_axi_awready;
   (* KEEP = "TRUE" *)
   wire  [31:0]         s_axi_wdata;
   (* KEEP = "TRUE" *)
   wire                 s_axi_wvalid;
   (* KEEP = "TRUE" *)
   wire                 s_axi_wready;
   (* KEEP = "TRUE" *)
   wire  [1:0]          s_axi_bresp;
   (* KEEP = "TRUE" *)
   wire                 s_axi_bvalid;
   (* KEEP = "TRUE" *)
   wire                 s_axi_bready;
   (* KEEP = "TRUE" *)
   wire  [31:0]         s_axi_araddr;
   (* KEEP = "TRUE" *)
   wire                 s_axi_arvalid;
   (* KEEP = "TRUE" *)
   wire                 s_axi_arready;
   (* KEEP = "TRUE" *)
   wire  [31:0]         s_axi_rdata;
   (* KEEP = "TRUE" *)
   wire  [1:0]          s_axi_rresp;
   (* KEEP = "TRUE" *)
   wire                 s_axi_rvalid;
   (* KEEP = "TRUE" *)
   wire                 s_axi_rready;

   // signal tie offs
   wire  [7:0]         tx_ifg_delay = 0;    // not used in this example

   assign frame_errorn = !frame_error;



  //----------------------------------------------------------------------------
  // Clock logic to generate required clocks from the 200MHz on board
  // if 125MHz is available directly this can be removed
  //----------------------------------------------------------------------------
  clk_wiz_v2_1 clock_generator
  (
      // Clock in ports
//      .CLK_IN1_P     (clk_in_p),
//      .CLK_IN1_N     (clk_in_n),
		.CLK_IN1			(clk_in),
      // Clock out ports
      .CLK_OUT1      (gtx_clk_bufg),
      .CLK_OUT2      (s_axi_aclk),
      .CLK_OUT3      (refclk_bufg),
      // Status and control signals
      .RESET         (glbl_rst),
      .LOCKED        (dcm_locked)
 );

  //---------------
  // global reset
   reset_sync glbl_reset_gen (
      .clk              (gtx_clk_bufg),
      .enable           (dcm_locked),
      .reset_in         (glbl_rst),
      .reset_out        (glbl_rst_int)
   );

   assign glbl_rst_intn = !glbl_rst_int;

  //----------------------------------------------------------------------------
  // Generate the user side clocks for the axi fifos
  //----------------------------------------------------------------------------
  assign tx_fifo_clock = gtx_clk_bufg;
  assign rx_fifo_clock = gtx_clk_bufg;

  //----------------------------------------------------------------------------
  // Generate resets required for the fifo side signals etc
  //----------------------------------------------------------------------------
  // in each case the async reset is first captured and then synchronised


  //---------------
  // AXI-Lite reset
   reset_sync axi_lite_reset_gen (
      .clk              (s_axi_aclk),
      .enable           (dcm_locked),
      .reset_in         (glbl_rst),
      .reset_out        (s_axi_reset_int)
   );

   // Create fully synchronous reset in the s_axi clock domain.
   always @(posedge s_axi_aclk)
   begin
     if (s_axi_reset_int) begin
       s_axi_pre_resetn <= 0;
       s_axi_resetn     <= 0;
     end
     else begin
       s_axi_pre_resetn <= 1;
       s_axi_resetn     <= s_axi_pre_resetn;
     end
   end


  //---------------
  // gtx_clk reset
   reset_sync gtx_reset_gen (
      .clk              (gtx_clk_bufg),
      .enable           (dcm_locked),
      .reset_in         (glbl_rst || rx_reset || tx_reset),
      .reset_out        (gtx_clk_reset_int)
   );

   // Create fully synchronous reset in the gtx_clk domain.
   always @(posedge gtx_clk_bufg)
   begin
     if (gtx_clk_reset_int) begin
       gtx_pre_resetn  <= 0;
       gtx_resetn      <= 0;
     end
     else begin
       gtx_pre_resetn  <= 1;
       gtx_resetn      <= gtx_pre_resetn;
     end
   end

  //---------------
  // data check reset
   reset_sync chk_reset_gen (
      .clk              (gtx_clk_bufg),
      .enable           (dcm_locked),
      .reset_in         (glbl_rst || reset_error),
      .reset_out        (chk_reset_int)
   );

   // Create fully synchronous reset in the gtx_clk domain.
   always @(posedge gtx_clk_bufg)
   begin
     if (chk_reset_int) begin
       chk_pre_resetn  <= 0;
       chk_resetn      <= 0;
     end
     else begin
       chk_pre_resetn  <= 1;
       chk_resetn      <= chk_pre_resetn;
     end
   end

   //---------------
   // PHY reset
   // the phy reset output (active low) needs to be held for at least 10x25MHZ cycles
   // this is derived using the 125MHz available and a 6 bit counter
   always @(posedge gtx_clk_bufg)
   begin
      if (!glbl_rst_intn) begin
         phy_resetn_int <= 1'b0;
         phy_reset_count <= 6'd0;
      end
      else begin
         if (!(&phy_reset_count)) begin
            phy_reset_count <= phy_reset_count + 6'd1;
         end
         else begin
            phy_resetn_int <= 1'b1;
         end
      end
   end

   assign phy_resetn = phy_resetn_int;

   // generate the user side resets for the axi fifos
   assign tx_fifo_resetn = gtx_resetn;
   assign rx_fifo_resetn = gtx_resetn;

  //----------------------------------------------------------------------------
  // Serialize the stats vectors
  // This is a single bit approach, retimed onto gtx_clk
  // this code is only present to prevent code being stripped..
  //----------------------------------------------------------------------------

  // RX STATS

  // first capture the stats on the appropriate clock
  always @(posedge rx_mac_aclk)
  begin
     rx_statistics_valid_reg <= rx_statistics_valid;
     if (!rx_statistics_valid_reg & rx_statistics_valid) begin
        rx_stats <= rx_statistics_vector;
        rx_stats_toggle <= !rx_stats_toggle;
     end
  end

  sync_block rx_stats_sync (
     .clk              (gtx_clk_bufg),
     .data_in          (rx_stats_toggle),
     .data_out         (rx_stats_toggle_sync)
  );

  always @(posedge gtx_clk_bufg)
  begin
     rx_stats_toggle_sync_reg <= rx_stats_toggle_sync;
  end

  // when an update is rxd load shifter (plus start/stop bit)
  // shifter always runs (no power concerns as this is an example design)
  always @(posedge gtx_clk_bufg)
  begin
     if (rx_stats_toggle_sync_reg != rx_stats_toggle_sync) begin
        rx_stats_shift <= {1'b1, rx_stats, 1'b1};
     end
     else begin
        rx_stats_shift <= {rx_stats_shift[28:0], 1'b0};
     end
  end

  assign rx_statistics_s = rx_stats_shift[29];

  // TX STATS

  // first capture the stats on the appropriate clock
  always @(posedge tx_mac_aclk)
  begin
     tx_statistics_valid_reg <= tx_statistics_valid;
     if (!tx_statistics_valid_reg & tx_statistics_valid) begin
        tx_stats <= tx_statistics_vector;
        tx_stats_toggle <= !tx_stats_toggle;
     end
  end

  sync_block tx_stats_sync (
     .clk              (gtx_clk_bufg),
     .data_in          (tx_stats_toggle),
     .data_out         (tx_stats_toggle_sync)
  );

  always @(posedge gtx_clk_bufg)
  begin
     tx_stats_toggle_sync_reg <= tx_stats_toggle_sync;
  end

  // when an update is txd load shifter (plus start bit)
  // shifter always runs (no power concerns as this is an example design)
  always @(posedge gtx_clk_bufg)
  begin
     if (tx_stats_toggle_sync_reg != tx_stats_toggle_sync) begin
        tx_stats_shift <= {1'b1, tx_stats, 1'b1};
     end
     else begin
        tx_stats_shift <= {tx_stats_shift[32:0], 1'b0};
     end
  end

  assign tx_statistics_s = tx_stats_shift[33];

  //----------------------------------------------------------------------------
  // DESerialize the Pause interface
  // This is a single bit approach timed on gtx_clk
  // this code is only present to prevent code being stripped..
  //----------------------------------------------------------------------------
  // the serialized pause info has a start bit followed by the quanta and a stop bit
  // capture the quanta when the start bit hits the msb and the stop bit is in the lsb
  always @(posedge gtx_clk_bufg)
  begin
     pause_shift <= {pause_shift[17:0], pause_req_s};
  end

  always @(posedge gtx_clk_bufg)
  begin
     if (pause_shift[18] === 1'b0 & pause_shift[17] === 1'b1 & pause_shift[0] === 1'b1) begin
        pause_req <= 1'b1;
        pause_val <= pause_shift[16:1];
     end
     else begin
        pause_req <= 1'b0;
        pause_val <= 0;
     end
  end

  //----------------------------------------------------------------------------
  // Instantiate the AXI-LITE Controller

   axi_lite_sm #(
      .BOARD_PHY_ADDR               (BOARD_PHY_ADDR),
      .MAC_BASE_ADDR                (MAC_BASE_ADDR)
   ) axi_lite_controller (
      .s_axi_aclk                   (s_axi_aclk),
      .s_axi_resetn                 (s_axi_resetn),

      .mac_speed                    (mac_speed),
      .update_speed                 (update_speed),   // may need glitch protection on this..
      .serial_command               (serial_command),
      .serial_response              (serial_response),

      .s_axi_awaddr                 (s_axi_awaddr),
      .s_axi_awvalid                (s_axi_awvalid),
      .s_axi_awready                (s_axi_awready),

      .s_axi_wdata                  (s_axi_wdata),
      .s_axi_wvalid                 (s_axi_wvalid),
      .s_axi_wready                 (s_axi_wready),

      .s_axi_bresp                  (s_axi_bresp),
      .s_axi_bvalid                 (s_axi_bvalid),
      .s_axi_bready                 (s_axi_bready),

      .s_axi_araddr                 (s_axi_araddr),
      .s_axi_arvalid                (s_axi_arvalid),
      .s_axi_arready                (s_axi_arready),

      .s_axi_rdata                  (s_axi_rdata),
      .s_axi_rresp                  (s_axi_rresp),
      .s_axi_rvalid                 (s_axi_rvalid),
      .s_axi_rready                 (s_axi_rready)
   );

  //----------------------------------------------------------------------------
  // Instantiate the V6 Hard EMAC core fifo block wrapper
  //----------------------------------------------------------------------------
   v6_emac_v2_3_fifo_block #(
      .MAC_BASE_ADDR                (MAC_BASE_ADDR)
   ) v6emac_fifo_block (
      .gtx_clk                      (gtx_clk_bufg),

      // Reference clock for IDELAYCTRL's
      .refclk                       (refclk_bufg),

      // Receiver Statistics Interface
      //---------------------------------------
      .rx_mac_aclk                  (rx_mac_aclk),
      .rx_reset                     (rx_reset),
      .rx_statistics_vector         (rx_statistics_vector),
      .rx_statistics_valid          (rx_statistics_valid),

      // Receiver (AXI-S) Interface
      //----------------------------------------
      .rx_fifo_clock                (rx_fifo_clock),
      .rx_fifo_resetn               (rx_fifo_resetn),
      .rx_axis_fifo_tdata           (rx_axis_fifo_tdata),
      .rx_axis_fifo_tvalid          (rx_axis_fifo_tvalid),
      .rx_axis_fifo_tready          (rx_axis_fifo_tready),
      .rx_axis_fifo_tlast           (rx_axis_fifo_tlast),

      // Transmitter Statistics Interface
      //------------------------------------------
      .tx_mac_aclk                  (tx_mac_aclk),
      .tx_reset                     (tx_reset),
      .tx_ifg_delay                 (tx_ifg_delay),
      .tx_statistics_vector         (tx_statistics_vector),
      .tx_statistics_valid          (tx_statistics_valid),

      // Transmitter (AXI-S) Interface
      //-------------------------------------------
      .tx_fifo_clock                (tx_fifo_clock),
      .tx_fifo_resetn               (tx_fifo_resetn),
      .tx_axis_fifo_tdata           (tx_axis_fifo_tdata),
      .tx_axis_fifo_tvalid          (tx_axis_fifo_tvalid),
      .tx_axis_fifo_tready          (tx_axis_fifo_tready),
      .tx_axis_fifo_tlast           (tx_axis_fifo_tlast),

      // MAC Control Interface
      //------------------------
      .pause_req                    (pause_req),
      .pause_val                    (pause_val),

      // RGMII Interface
      //------------------
      .rgmii_txd                    (rgmii_txd),
      .rgmii_tx_ctl                 (rgmii_tx_ctl),
      .rgmii_txc                    (rgmii_txc),
      .rgmii_rxd                    (rgmii_rxd),
      .rgmii_rx_ctl                 (rgmii_rx_ctl),
      .rgmii_rxc                    (rgmii_rxc),




      // AXI-Lite Interface
      //---------------
      .s_axi_aclk                   (s_axi_aclk),
      .s_axi_resetn                 (s_axi_resetn),

      .s_axi_awaddr                 (s_axi_awaddr),
      .s_axi_awvalid                (s_axi_awvalid),
      .s_axi_awready                (s_axi_awready),

      .s_axi_wdata                  (s_axi_wdata),
      .s_axi_wvalid                 (s_axi_wvalid),
      .s_axi_wready                 (s_axi_wready),

      .s_axi_bresp                  (s_axi_bresp),
      .s_axi_bvalid                 (s_axi_bvalid),
      .s_axi_bready                 (s_axi_bready),

      .s_axi_araddr                 (s_axi_araddr),
      .s_axi_arvalid                (s_axi_arvalid),
      .s_axi_arready                (s_axi_arready),

      .s_axi_rdata                  (s_axi_rdata),
      .s_axi_rresp                  (s_axi_rresp),
      .s_axi_rvalid                 (s_axi_rvalid),
      .s_axi_rready                 (s_axi_rready),

      // asynchronous reset
      .glbl_rstn                    (glbl_rst_intn),
      .rx_axi_rstn                  (1'b1),
      .tx_axi_rstn                  (1'b1)
   );


  //----------------------------------------------------------------------------
  //  Instantiate the address swapping module and simple pattern generator
  //----------------------------------------------------------------------------
   basic_pat_gen basic_pat_gen (
      .axi_tclk                     (tx_fifo_clock),
      .axi_tresetn                  (tx_fifo_resetn),
      .check_resetn                 (chk_resetn),

      .enable_pat_gen               (gen_tx_data),
      .enable_pat_chk               (chk_tx_data),
      .enable_address_swap          (swap_address),

      .rx_axis_fifo_tdata           (rx_axis_fifo_tdata),
      .rx_axis_fifo_tvalid          (rx_axis_fifo_tvalid),
      .rx_axis_fifo_tlast           (rx_axis_fifo_tlast),
      .rx_axis_fifo_tready          (rx_axis_fifo_tready),

      .tx_axis_fifo_tdata           (tx_axis_fifo_tdata),
      .tx_axis_fifo_tvalid          (tx_axis_fifo_tvalid),
      .tx_axis_fifo_tlast           (tx_axis_fifo_tlast),
      .tx_axis_fifo_tready          (tx_axis_fifo_tready),

      .frame_error                  (frame_error),
				
    .data_in(dout), 
    .start(start), 
    .user_data(user_data), 
    .rd_clk(rd_clk), 
    .addr(addr), 
    .busy(busy),
	 .page_read(page_read),			//modified on 150211
//	 .bag(bag), 										//modified on 150211
	 .mode_sel(mode_sel),                  //150916
	
	 .SRC_ADDR(SRC_ADDR),
	 .DEST_ADDR(DEST_ADDR),
	 .PPS_DETECT_CNT(PPS_DETECT_CNT),
	 .SRC_IP(SRC_IP),
    .DEST_IP(DEST_IP),
    .SRC_PORT(SRC_PORT),
    .DEST_PORT(DEST_PORT)
   );

//λѡģ
wire [15:0]data_width;
wire en_sync_width;
wire [7:0]cnt_sync_width;
WIDTH_SEL WIDTH_SEL (
    .clk(clk), 
    .rst(rst), 
    .en_sync_in(en_sync_in), 
    .cnt_sync_in(cnt_sync_in), 
    .data_in(power_com), 
    .width_sel(width_ctrl), 
    .en_sync_out(en_sync_width), 
    .cnt_sync_out(cnt_sync_width), 
    .data_out(data_width)
    );
//ǧ
wire start_temp;
assign start=rgmii_ctrl & start_temp;
power_out_control RAM_BUFFER (
    .clk(clk), 									//OK
    .rst(rst), 									//OK
    .en_sync_in(en_sync_width), 				//OK					
    .cnt_sync_in(cnt_sync_width), 			//OK	
    .power_com(data_width), 					//OK	
    .RST_66M(RST_66M), 							//OK
    .rd_clk(rd_clk), 							//OK
    .busy(busy), 									//OK
    .addrb_l(addr), 								//OK
    .start(start_temp), 						//OK
    .power_out(dout), 							//OK
	 .user_data(),	
    .page_read(page_read)			//modified on 150211
//	 .bag(bag) 										//modified on 150211
    );
//-----------------------ǲʱϢ---------------------------
wire [39:0]user_data_in;
US_TIMER  #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
) us_timer_gen (
    .clk(clk), 
    .rst(rst), 
    .user_data(user_data_in)
    );
reg en_sync_in_reg,en_sync_in_reg_reg;//en_sync_inһclkʱclkʱǰʱΪ0Ŀǰ״̬Ϊ1ʱȡֵŵuser_data

always @(posedge clk)
	begin
		if(rst)
			begin
				en_sync_in_reg<=1'b0;
				en_sync_in_reg_reg<=1'b0;
			end
		else 
			begin
				en_sync_in_reg<=en_sync_in;
				en_sync_in_reg_reg<=en_sync_in_reg;
			end
	end
//en_sync_in0 0 1ʱˣʱʱϢ
always @(posedge clk)
	begin
		if(rst)user_data<=64'h0;
		else if((en_sync_in==1)&&(en_sync_in_reg==0)&&(en_sync_in_reg_reg==0))
				user_data<={24'b0,user_data_in};
				//else user_data<=user_data;
	end
endmodule
