//------------------------------------------------------------------------------
// File       : axi_lite_sm.v
// Author     : Xilinx Inc.
// Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
// File       : axi_lite_sm.v
// Version    : 2.3
//-----------------------------------------------------------------------------
//
// (c) Copyright 2010 Xilinx, Inc. All rights reserved.
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
// Description:  This module is reponsible for bringing up the MAC via the AXI4-Lite
//  to enable basic packet transfer in both directions.
//
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module axi_lite_sm #(
      parameter            BOARD_PHY_ADDR = 8'h7,
      parameter            MAC_BASE_ADDR  = 32'h0
) (
      input                s_axi_aclk,
      input                s_axi_resetn,

      input       [1:0]    mac_speed,
      input                update_speed,
      input                serial_command,
      output reg           serial_response,

      output reg  [31:0]   s_axi_awaddr,
      output reg           s_axi_awvalid,
      input                s_axi_awready,

      output reg  [31:0]   s_axi_wdata,
      output reg           s_axi_wvalid,
      input                s_axi_wready,

      input       [1:0]    s_axi_bresp,
      input                s_axi_bvalid,
      output reg           s_axi_bready,

      output reg  [31:0]   s_axi_araddr,
      output reg           s_axi_arvalid,
      input                s_axi_arready,

      input       [31:0]   s_axi_rdata,
      input       [1:0]    s_axi_rresp,
      input                s_axi_rvalid,
      output reg           s_axi_rready
);

parameter RUN_HALF_DUPLEX              = 0;

// main state machine

parameter  STARTUP                     = 0,
           UPDATE_SPEED                = 15,
           RESET_MAC_TX                = 16,
           RESET_MAC_RX                = 17,
           CNFG_MAC_TX                 = 18,
           CNFG_MAC_RX                 = 19,
           CNFG_FLOW                   = 21,
           CNFG_LO_ADDR                = 22,
           CNFG_HI_ADDR                = 23,
           CNFG_FILTER                 = 25,
           CNFG_HD1                    = 26,
           CNFG_HD2                    = 27,
           CHECK_SPEED                 = 28;


// AXI State Machine
parameter  IDLE                        = 0,
           READ                        = 1,
           WRITE                       = 2,
           DONE                        = 3;


// Management configuration register address     (0x500)
parameter CONFIG_MANAGEMENT_ADD  = MAC_BASE_ADDR[10:0] + 11'h500;

// Flow control configuration register address   (0x40C)
parameter CONFIG_FLOW_CTRL_ADD   = MAC_BASE_ADDR[10:0] + 11'h40C;

// Receiver configuration register address       (0x404)
parameter RECEIVER_ADD           = MAC_BASE_ADDR[10:0] + 11'h404;

// Transmitter configuration register address    (0x408)
parameter TRANSMITTER_ADD        = MAC_BASE_ADDR[10:0] + 11'h408;

// Speed configuration register address    (0x410)
parameter SPEED_CONFIG_ADD       = MAC_BASE_ADDR[10:0] + 11'h410;

// Unicast Word 0 configuration register address (0x700)
parameter CONFIG_UNI0_CTRL_ADD   = MAC_BASE_ADDR[10:0] + 11'h700;

// Unicast Word 1 configuration register address (0x704)
parameter CONFIG_UNI1_CTRL_ADD   = MAC_BASE_ADDR[10:0] + 11'h704;

// Address Filter configuration register address (0x708)
parameter CONFIG_ADDR_CTRL_ADD   = MAC_BASE_ADDR[10:0] + 11'h708;


//-------------------------------------------------
// Wire/reg declarations
reg      [4:0]    axi_status;          // used to keep track of axi transactions
reg      [31:0]   axi_rd_data;
reg      [31:0]   axi_wr_data;

reg      [4:0]    axi_state;           // main state machine to configure example design
reg      [1:0]    axi_access_sm;       // axi state machine - handles the 5 channels

reg               start_access;        // used to kick the axi acees state machine
reg               writenread;
reg      [10:0]   addr;
reg      [1:0]    speed;
reg               update_speed_reg;
wire              update_speed_axi;

reg      [20:0]   count_shift = {21{1'b1}};

reg      [36:0]   serial_command_shift = {37{1'b0}};
reg               load_data;
reg               capture_data;
reg               write_access;
reg               read_access;

wire              s_axi_reset;

assign s_axi_reset = !s_axi_resetn;


sync_block updatespeedsync (
   .clk              (s_axi_aclk),
   .data_in          (update_speed),
   .data_out         (update_speed_axi)
);

always @(posedge s_axi_aclk)
begin
   if (s_axi_reset) begin
      update_speed_reg <= 0;
      speed            <= mac_speed;
   end
   else begin
      update_speed_reg <= update_speed_axi;
      if (!update_speed_reg & update_speed_axi)
         speed         <= mac_speed;
   end
end

//----------------------------------------------------------------------------
// Management process. This process sets up the configuration by
// turning off flow control, then checks gathered statistics at the
// end of transmission
//----------------------------------------------------------------------------
always @(posedge s_axi_aclk)
begin
   if (s_axi_reset) begin
      axi_state      <= STARTUP;
      start_access   <= 0;
      writenread     <= 0;
      addr           <= 0;
      axi_wr_data    <= 0;
   end
   // main state machine is kicking off multi cycle accesses in each state so has to
   // stall while they take place
   else if (axi_access_sm == IDLE && !start_access) begin
      case (axi_state)
         STARTUP : begin
            // this state will be ran after reset to wait for count_shift
            if (count_shift[20] === 1'b0) begin
               axi_state      <= UPDATE_SPEED;
            end
         end


         // program the MAC to the required speed
         UPDATE_SPEED : begin
            $display("** Note: Programming MAC speed");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= SPEED_CONFIG_ADD;
            // bits 31:30 are used for speed, bottom 9 bits for link timer val
            axi_wr_data    <= {speed, 30'h32};
            axi_state      <= RESET_MAC_RX;
         end
         // this state will drive the reset to the example design (apart from this block)
         // this will be separately captured and synched into the various clock domains
         RESET_MAC_RX : begin
            $display("** Note: Reseting MAC RX");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RECEIVER_ADD;
            axi_wr_data    <= 32'h90000000;
            axi_state      <= RESET_MAC_TX;
         end
         // this state will drive the reset to the example design (apart from this block)
         // this will be separately captured and synched into the various clock domains
         RESET_MAC_TX : begin
            $display("** Note: Reseting MAC TX");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= TRANSMITTER_ADD;
            axi_wr_data    <= 32'h90000000;
            axi_state      <= CNFG_MAC_TX;
         end
         // this state will set ony the modes we plan to use
         CNFG_MAC_TX : begin
            $display("** Note: Configuring MAC RX");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RECEIVER_ADD;
            axi_wr_data    <= 32'h10000000;
            axi_state      <= CNFG_MAC_RX;
         end
         // this state will set ony the modes we plan to use
         CNFG_MAC_RX : begin
            $display("** Note: Configuring MAC TX");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= TRANSMITTER_ADD;
            axi_wr_data    <= 32'h10000000;
            axi_state      <= CNFG_FLOW;
         end
         CNFG_FLOW : begin
            $display("** Note: Disabling Flow control....");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= CONFIG_FLOW_CTRL_ADD;
            axi_wr_data    <= 32'h0;
            axi_state      <= CNFG_LO_ADDR;
         end
         CNFG_LO_ADDR : begin
            $display("** Note: Configuring unicast address(low word)....");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= CONFIG_UNI0_CTRL_ADD;
            axi_wr_data    <= 32'h040302DA;
            axi_state      <= CNFG_HI_ADDR;
         end
         CNFG_HI_ADDR : begin
            $display("** Note: Configuring unicast address(high word)....");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= CONFIG_UNI1_CTRL_ADD;
            axi_wr_data    <= 32'h0605;
            axi_state      <= CNFG_FILTER;
         end
         CNFG_FILTER : begin
            $display("** Note: Setting core to promiscuous mode....");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= CONFIG_ADDR_CTRL_ADD;
            axi_wr_data    <= 32'h80000000;
            if (RUN_HALF_DUPLEX)
               axi_state      <= CNFG_HD1;
            else
               axi_state      <= CHECK_SPEED;
         end
         CNFG_HD1 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RECEIVER_ADD;
            axi_wr_data    <= 32'h14000000;
            axi_state      <= CNFG_HD2;
         end
         CNFG_HD2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= TRANSMITTER_ADD;
            axi_wr_data    <= 32'h14000000;
            axi_state      <= CHECK_SPEED;
         end
         CHECK_SPEED : begin
            if (update_speed_reg) begin
              axi_state      <= STARTUP;
            end
            else begin
               if (capture_data)
                  axi_wr_data <= serial_command_shift[33:2];
               if (write_access || read_access) begin
                  addr        <= serial_command_shift[13:2];
                  start_access <= 1;
                  writenread   <= write_access;
               end
            end
         end
         default : begin
            axi_state <= STARTUP;
         end
      endcase
   end
   else begin
      start_access <= 0;
   end
end



//-------------------------------------------------------------------------------------------
// processes to generate the axi transactions - only simple reads and write can be generated

always @(posedge s_axi_aclk)
begin
   if (s_axi_reset) begin
      axi_access_sm <= IDLE;
   end
   else begin
      case (axi_access_sm)
         IDLE : begin
            if (start_access) begin
               if (writenread) begin
                  axi_access_sm <= WRITE;
               end
               else begin
                  axi_access_sm <= READ;
               end
            end
         end
         WRITE : begin
            // wait in this state until axi_status signals the write is complete
            if (axi_status[4:2] == 3'b111)
               axi_access_sm <= DONE;
         end
         READ : begin
            // wait in this state until axi_status signals the read is complete
            if (axi_status[1:0] == 2'b11)
               axi_access_sm <= DONE;
         end
         DONE : begin
            axi_access_sm <= IDLE;
         end
      endcase
   end
end

// need a process per axi interface (i.e 5)
// in each case the interface is driven accordingly and once acknowledged a sticky
// status bit is set and the process waits until the access_sm moves on
// READ ADDR
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == READ) begin
      if (!axi_status[0]) begin
         s_axi_araddr   <= addr;
         s_axi_arvalid  <= 1'b1;
         if (s_axi_arready === 1'b1 && s_axi_arvalid) begin
            axi_status[0] <= 1;
            s_axi_araddr      <= 0;
            s_axi_arvalid     <= 0;
         end
      end
   end
   else begin
      axi_status[0]     <= 0;
      s_axi_araddr      <= 0;
      s_axi_arvalid     <= 0;
   end
end

// READ DATA/RESP
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == READ) begin
      if (!axi_status[1]) begin
         s_axi_rready  <= 1'b1;
         if (s_axi_rvalid === 1'b1 && s_axi_rready) begin
            axi_status[1] <= 1;
            s_axi_rready  <= 0;
            axi_rd_data   <= s_axi_rdata;
         end
      end
   end
   else begin
      s_axi_rready      <= 0;
      axi_status[1]     <= 0;
      if (axi_access_sm == IDLE & start_access) begin
         axi_rd_data    <= 0;
      end
   end
end

// WRITE ADDR
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[2]) begin
         s_axi_awaddr   <= addr;
         s_axi_awvalid  <= 1'b1;
         if (s_axi_awready === 1'b1 && s_axi_awvalid) begin
            axi_status[2] <= 1;
            s_axi_awaddr      <= 0;
            s_axi_awvalid     <= 0;
         end
      end
   end
   else begin
      s_axi_awaddr      <= 0;
      s_axi_awvalid     <= 0;
      axi_status[2]     <= 0;
   end
end

// WRITE DATA
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[3]) begin
         s_axi_wdata   <= axi_wr_data;
         s_axi_wvalid  <= 1'b1;
         if (s_axi_wready === 1'b1 && s_axi_wvalid) begin
            axi_status[3] <= 1;
            s_axi_wdata      <= 0;
            s_axi_wvalid     <= 0;
         end
      end
   end
   else begin
      s_axi_wdata      <= 0;
      s_axi_wvalid     <= 0;
      axi_status[3]     <= 0;
   end
end

// WRITE RESP
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[4]) begin
         s_axi_bready  <= 1'b1;
         if (s_axi_bvalid === 1'b1 && s_axi_bready) begin
            axi_status[4] <= 1;
            s_axi_bready     <= 0;
         end
      end
   end
   else begin
      s_axi_bready     <= 0;
      axi_status[4]     <= 0;
   end
end

//-------------------------------------------------------------------------------------------------------
// to avoid logic being stripped a serial input is included which enables an address/data and control to be setup for
// a user config access..
always @(posedge s_axi_aclk)
begin
    if (load_data)
       serial_command_shift <= {serial_command_shift[35:33], axi_rd_data, serial_command_shift[0], serial_command};
    else
       serial_command_shift <= {serial_command_shift[35:0], serial_command};
end

// the serial response output is used to indiacte the SM has almost completed to enable the testbench to
// sync up
always @(posedge s_axi_aclk)
begin
  if (axi_state == CNFG_FILTER)
    serial_response <= 1'b1;
  else
    serial_response <= serial_command_shift[35];
end

// the serial command is expected to have a start and stop bit - to avoid a counter -
// and a two bit code field in the uppper two bits.
// these decode as follows:
// 00 - read address
// 01 - write address
// 10 - write data
// 11 - read data - slightly more involved - when detected the read data is registered into the shift and passed out
// 11 is used for read data as if the input is tied high the output will simply reflect whatever was
// captured but will not result in any activity
// it is expected that the write data is setup BEFORE the write address
always @(posedge s_axi_aclk)
begin
    load_data <= 0;
    capture_data <= 0;
    write_access <= 0;
    read_access  <= 0;
    if (!serial_command_shift[36] & serial_command_shift[35] & serial_command_shift[0])
       if (serial_command_shift[34] & serial_command_shift[33])       // READ DATA
          load_data <= 1;
       else if (serial_command_shift[34] & !serial_command_shift[33]) // WRITE DATA
          capture_data <= 1;
       else if (!serial_command_shift[34] & serial_command_shift[33]) // WRITE ADDRESS
          write_access <= 1;
       else                                                           // READ ADDRESS
          read_access <= 1;
end

// don't reset this  - it will always be updated before it is used..
// it does need an init value (all ones)
always @(posedge s_axi_aclk)
begin
      count_shift <= {count_shift[19:0], s_axi_reset};
end

endmodule

