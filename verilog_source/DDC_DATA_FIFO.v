`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:35 10/20/2018 
// Design Name: 
// Module Name:    DATA_FIFO 
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
module DDC_DATA_FIFO#(
	parameter DATA_WIDTH = 34
	)(	
	input rst,
	input wr_clk,
	input [DATA_WIDTH-1:0]din_L_i,
	input [DATA_WIDTH-1:0]din_L_q,
	input en_wr_L,
	input [DATA_WIDTH-1:0]din_R_i,
	input [DATA_WIDTH-1:0]din_R_q,
	input en_wr_R,
	
	input rd_clk,
	output [DATA_WIDTH-1:0]dout_L_i,
	output [DATA_WIDTH-1:0]dout_L_q,
	output [DATA_WIDTH-1:0]dout_R_i,
	output [DATA_WIDTH-1:0]dout_R_q
    );

	wire en_w_r;

   assign en_w_r = ~rst;
	 
 DDC_FIFO  FIFO_L_I(
	 .rst(rst),							//Modified on 2014.06.09
	 .wr_clk(wr_clk),
	 .rd_clk(rd_clk),
	 .din(din_L_i),
	 .wr_en(en_wr_L),
	 .rd_en(en_w_r),
	 .dout(dout_L_i),
	 .full(),
	 .empty()
	 );

DDC_FIFO FIFO_L_Q (
  .rst(rst), // input rst
  .wr_clk(wr_clk), // input wr_clk
  .rd_clk(rd_clk), // input rd_clk
  .din(din_L_q), // input [22 : 0] din
  .wr_en(en_wr_L), // input wr_en
  .rd_en(en_w_r), // input rd_en
  .dout(dout_L_q), // output [22 : 0] dout
  .full(), // output full
  .empty() // output empty
);

DDC_FIFO FIFO_R_I (
  .rst(rst), // input rst
  .wr_clk(wr_clk), // input wr_clk
  .rd_clk(rd_clk), // input rd_clk
  .din(din_R_i), // input [22 : 0] din
  .wr_en(en_wr_R), // input wr_en
  .rd_en(en_w_r), // input rd_en
  .dout(dout_R_i), // output [22 : 0] dout
  .full(), // output full
  .empty() // output empty
);

DDC_FIFO FIFO_R_Q (
  .rst(rst), // input rst
  .wr_clk(wr_clk), // input wr_clk
  .rd_clk(rd_clk), // input rd_clk
  .din(din_R_q), // input [22 : 0] din
  .wr_en(en_wr_R), // input wr_en
  .rd_en(en_w_r), // input rd_en
  .dout(dout_R_q), // output [22 : 0] dout
  .full(), // output full
  .empty() // output empty
);
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

endmodule
