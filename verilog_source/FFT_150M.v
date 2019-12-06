`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:23 10/20/2018 
// Design Name: 
// Module Name:    FFT_150M 
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
module FFT_150M #(
	parameter DATA_WIDTH = 34,
	parameter FFT_WIDTH = 44		//截断后的输出位宽
	)(
	input clk,
	input rst,
	
	input [DATA_WIDTH-1:0] data_L_i,
	input [DATA_WIDTH-1:0] data_L_q,
	input [DATA_WIDTH-1:0] data_R_i,
	input [DATA_WIDTH-1:0] data_R_q,
	
	output [FFT_WIDTH-1:0] re0_out_fftl,
	output [FFT_WIDTH-1:0] im0_out_fftl,
	output [FFT_WIDTH-1:0] re0_out_fftr,
	output [FFT_WIDTH-1:0] im0_out_fftr,
	output en_sync_fft,
	output [8:0]cnt_sync_fft
    );

	localparam FFT_OUT_WIDTH = 33;	//FFT核的输出位宽
	
wire [FFT_OUT_WIDTH-1:0]re0_out_fftl_temp,im0_out_fftl_temp;
wire [FFT_OUT_WIDTH-1:0]re0_out_fftr_temp,im0_out_fftr_temp;

fft_512 FFT_150M_L (								 //8192 point fft
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .start(1'b1), // input start
  .xn_re(data_L_i), // input [7 : 0] xn_re
  .xn_im(data_L_q), // input [7 : 0] xn_im
  .fwd_inv(1'b1), // input fwd_inv
  .fwd_inv_we(1'b1), // input fwd_inv_we
  .rfd(), // output rfd
  .xn_index(), // output [8 : 0] xn_index
  .busy(), // output busy
  .edone(), // output edone
  //.done(en_sync_fft), // output done
  .dv(en_sync_fft), // output dv
  .xk_index(cnt_sync_fft), // output [8 : 0] xk_index
  .xk_re(re0_out_fftl_temp), // output [17 : 0] xk_re
  .xk_im(im0_out_fftl_temp) // output [17 : 0] xk_im
);

fft_512 FFT_150M_R (								 //8192 point fft
  .clk(clk), // input clk
  .sclr(rst), // input sclr
  .start(1'b1), // input start
  .xn_re(data_R_i), // input [7 : 0] xn_re
  .xn_im(data_R_q), // input [7 : 0] xn_im
  .fwd_inv(1'b1), // input fwd_inv
  .fwd_inv_we(1'b1), // input fwd_inv_we
  .rfd(), // output rfd
  .xn_index(), // output [8 : 0] xn_index
  .busy(), // output busy
  .edone(), // output edone
  .done(), // output done
  .dv(), // output dv
  .xk_index(), // output [8 : 0] xk_index
  .xk_re(re0_out_fftr_temp), // output [17 : 0] xk_re
  .xk_im(im0_out_fftr_temp) // output [17 : 0] xk_im
);

assign re0_out_fftl = re0_out_fftl_temp[FFT_OUT_WIDTH-1:FFT_OUT_WIDTH-FFT_WIDTH];
assign im0_out_fftl = im0_out_fftl_temp[FFT_OUT_WIDTH-1:FFT_OUT_WIDTH-FFT_WIDTH];
assign re0_out_fftr = re0_out_fftr_temp[FFT_OUT_WIDTH-1:FFT_OUT_WIDTH-FFT_WIDTH];
assign im0_out_fftr = im0_out_fftr_temp[FFT_OUT_WIDTH-1:FFT_OUT_WIDTH-FFT_WIDTH];
endmodule
