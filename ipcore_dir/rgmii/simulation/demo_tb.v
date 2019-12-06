//----------------------------------------------------------------------
// Title      : Demo Testbench
// Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
// File       : demo_tb.v
// Version    : 2.3
//-----------------------------------------------------------------------------
//
// (c) Copyright 2004-2008 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------------------
// Description: This testbench will exercise the PHY ports of the EMAC
//              to demonstrate the functionality.
//----------------------------------------------------------------------
//
// This testbench performs the following operations on the MAC core
// and its design example:


//  - Four frames are then pushed into the receiver from the PHY
//    interface (GMII/MII or RGMII):
//    The first is of minimum length (Length/Type = Length = 46 bytes).
//    The second frame sets Length/Type to Type = 0x8000.
//    The third frame has an error inserted.
//    The fourth frame only sends 4 bytes of data: the remainder of the
//    data field is padded up to the minimum frame length i.e. 46 bytes.

//  - These frames are then parsed from the MAC into the MAC's design
//    example.  The design example provides a MAC user loopback
//    function so that frames which are received without error will be
//    looped back to the MAC transmitter and transmitted back to the
//    testbench.  The testbench verifies that this data matches that
//    previously injected into the receiver.


`timescale 1ps / 1ps


module testbench;

  //--------------------------------------------------------------------
  // Testbench signals
  //--------------------------------------------------------------------
  reg         reset;


  // RGMII wires
  wire        rgmii_txc ;
  wire        rgmii_tx_ctl;
  wire [3:0]  rgmii_txd;
  wire        rgmii_rxc;
  wire        rgmii_rx_ctl;
  wire [3:0]  rgmii_rxd;

  // Clock wires
  reg         gtx_clk;
  reg         sys_clk;

  reg  [1:0]  mac_speed;
  reg         update_speed;
  // the serial reponse output is used to indicate the Control sm has completed (nearly)
  wire        serial_response;


  //----------------------------------------------------------------
  // Testbench Semaphores
  //----------------------------------------------------------------
  reg         configuration_busy;
  wire        monitor_finished_1g;
  wire        monitor_finished_100m;
  wire        monitor_finished_10m;


  //----------------------------------------------------------------
  // Wire up device under test
  //----------------------------------------------------------------
  rgmii_example_design dut
   (
   // asynchronous reset
   .glbl_rst                                 (reset),

   // 200MHz clock input from board
   .clk_in_p                                 (sys_clk),
   .clk_in_n                                 (!sys_clk),

   .phy_resetn                               (),

   // RGMII Interface
   //----------------
   .rgmii_txd                                (rgmii_txd),
   .rgmii_tx_ctl                             (rgmii_tx_ctl),
   .rgmii_txc                                (rgmii_txc),
   .rgmii_rxd                                (rgmii_rxd),
   .rgmii_rx_ctl                             (rgmii_rx_ctl),
   .rgmii_rxc                                (rgmii_rxc),


   // Serialised statistics vectors
   //------------------------------
   .tx_statistics_s                          (),
   .rx_statistics_s                          (),

   // Serialised Pause interface controls
   //------------------------------------
   .pause_req_s                              (1'b0),

   // Main example design controls
   //-----------------------------
   .mac_speed                                (mac_speed),
   .update_speed                             (update_speed),
   .serial_command                           (1'b0),
   .serial_response                          (serial_response),
   .gen_tx_data                              (1'b0),
   .chk_tx_data                              (1'b0),
   .swap_address                             (1'b1),
   .reset_error                              (1'b0),
   .frame_error                              (),
   .frame_errorn                             ()

    );

  //---------------------------------------------------------------------------
  //-- If the simulation is still going after 620 us then
  //-- something has gone wrong
  //---------------------------------------------------------------------------
  initial
  begin
    #620000000;
    $display("** ERROR: Simulation Running Forever");
    $stop;
  end


  //--------------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------------

  // Drive GTX_CLK at 125 MHz
  initial
  begin
    gtx_clk <= 1'b0;
    #10000;
    forever
    begin
      gtx_clk <= 1'b0;
      #4000;
      gtx_clk <= 1'b1;
      #4000;
    end
  end

  // Drive sys_clk
  initial
  begin
    sys_clk <= 1'b0;
    #10000;
    forever
    begin
      sys_clk <= 1'b0;
      #2500;
      sys_clk <= 1'b1;
      #2500;
    end
  end


  //----------------------------------------------------------------------------
  // A Task to reset the MAC
  //----------------------------------------------------------------------------
  task mac_reset;
    begin
      $display("** Note: Resetting core...");

      reset <= 1'b1;
      #400000

      reset <= 1'b0;

      $display("** Note: Timing checks are valid");
    end
  endtask // mac_reset;

  //----------------------------------------------------------------------------
  // Management process. This process waits for setup to complete by monitoring the mdio
  // (the host always runs at gtx_clk so the setup after mdio accesses are complete
  // doesn't take long) and then allows packets to be sent
  //----------------------------------------------------------------------------
  initial
  begin : p_management
    configuration_busy <= 1'b1;

    mac_speed <= 2'b10;
    update_speed <= 1'b0;

    // reset the core
    mac_reset;

    @(posedge serial_response);
    repeat (50) @(posedge gtx_clk);

    // Signal that configuration is complete.  Other processes will now
    // be allowed to run.
    configuration_busy = 0;

    // The stimulus process will now send 4 frames at 1Gb/s.
    //------------------------------------------------------------------

    // Wait for 1G monitor process to complete.
    wait (monitor_finished_1g == 1);
    configuration_busy = 1;

    // Change the speed to 100Mb/s and send the 4 frames
    //------------------------------------------------------------------

    @(posedge gtx_clk);
    mac_speed <= 2'b01;
    update_speed <= 1'b1;
    @(posedge gtx_clk);
    @(posedge gtx_clk);
    update_speed <= 1'b0;

    @(posedge serial_response);
    repeat (50) @(posedge gtx_clk);

    // Signal that configuration is complete.  Other processes will now
    // be allowed to run.
    configuration_busy = 0;

    // Wait for 100M monitor process to complete.
    wait (monitor_finished_100m == 1);
    configuration_busy = 1;

    // Change the speed to 10Mb/s and send the 4 frames
    //------------------------------------------------------------------

    @(posedge gtx_clk);
    mac_speed <= 2'b00;
    update_speed <= 1'b1;
    @(posedge gtx_clk);
    @(posedge gtx_clk);
    update_speed <= 1'b0;

    @(posedge serial_response);
    repeat (50) @(posedge gtx_clk);

    configuration_busy = 0;

    // Wait for 10M monitor process to complete.
    wait (monitor_finished_10m == 1);
    configuration_busy = 1;

    // Change the speed back to 1Gb/s and send the 4 frames
    //------------------------------------------------------------------

    @(posedge gtx_clk);
    mac_speed <= 2'b10;
    update_speed <= 1'b1;
    @(posedge gtx_clk);
    @(posedge gtx_clk);
    update_speed <= 1'b0;

    @(posedge serial_response);
    repeat (50) @(posedge gtx_clk);

    configuration_busy = 0;
    wait (monitor_finished_1g == 1);

    // Our work here is done
    $display("** failure: Simulation Stopped");
    $stop;

  end // p_management



  //--------------------------------------------------------------------
  // Instantiate the PHY stimulus and monitor
  //--------------------------------------------------------------------

  phy_tb phy_test
    (
      //----------------------------------------------------------------
      // RGMII interface
      //----------------------------------------------------------------
      .rgmii_txd             (rgmii_txd),
      .rgmii_tx_ctl          (rgmii_tx_ctl),
      .rgmii_txc             (rgmii_txc),
      .rgmii_rxd             (rgmii_rxd),
      .rgmii_rx_ctl          (rgmii_rx_ctl),
      .rgmii_rxc             (rgmii_rxc),

      //----------------------------------------------------------------
      // Testbench semaphores
      //----------------------------------------------------------------
      .configuration_busy    (configuration_busy),
      .monitor_finished_1g   (monitor_finished_1g),
      .monitor_finished_100m (monitor_finished_100m),
      .monitor_finished_10m  (monitor_finished_10m),
      .monitor_error         (monitor_error)
    );

endmodule
