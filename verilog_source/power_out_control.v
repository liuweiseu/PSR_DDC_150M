`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:44:40 07/27/2013 
// Design Name: 
// Module Name:    power_out_control 
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

module power_out_control(clk,rst,en_sync_in,cnt_sync_in,power_com,RST_66M,rd_clk,busy,addrb_l,start,power_out,user_data,page_read
    );


input clk;
input rst;
input en_sync_in;
input [4:0] cnt_sync_in;			//8bit [7:0]
input [15:0] power_com;
input RST_66M;	


input rd_clk;
input busy;
input [8:0] addrb_l;
output reg start;
output [7:0] power_out;

output [63:0] user_data;

output [15:0] page_read;			//modified on 150211
//output reg [1:0] bag;						//modified on 150211 0802



assign user_data = 64'h0123456789abcdef;


//reg [63:0] cnt_frame;

//reg ms_inner;

reg work;
reg busy_reg;
reg busy_reg_reg;

always@(posedge rd_clk)
 begin 
	busy_reg<=busy;
	busy_reg_reg<=busy_reg;
 end

//RAMдַ
wire [12:0] addressa;
reg [4:0] cnt_page;
//reg [8:0] cnt512;
reg [2:0]cnt_page_temp;
assign addressa[12:0]={cnt_page[4:0],cnt_page_temp[2:0],cnt_sync_in[4:0]};
//Ҫ8bitģʽ£cnt_sync_inΪ255clkcnt_page2
reg [7:0]cnt_sync_in_reg;
reg [2:0]cnt_page_temp_reg;
always @(posedge clk)
	begin
		if(rst)
			begin
				cnt_sync_in_reg<=0;
				cnt_page_temp_reg<=0;
			end
		else
			begin
				cnt_sync_in_reg<=cnt_sync_in;
				cnt_page_temp_reg<=cnt_page_temp;
			end
	end
always @(posedge clk)
	begin
		if(rst)
			cnt_page_temp<=0;
		else if((cnt_sync_in==31) &&(cnt_sync_in_reg <31) ) //2047 cnt512
			cnt_page_temp<=cnt_page_temp+1;
	end

always @(posedge clk)
	begin
		if(rst)
			cnt_page<=0;
//		else if((cnt_page_temp==7) &&(cnt_page_temp_reg <7) ) //2047 cnt512
		else if((cnt_page_temp==7) &&(cnt_sync_in==31) &&(cnt_sync_in_reg <31) )
			cnt_page<=cnt_page+1;
	end
//always@(posedge clk)
// begin
//   if (rst)
//	  cnt512<=9'b0;
//	else if (en_sync_in==1)
//	  cnt512<=cnt512+1'b1;
//	else
//	  cnt512<=cnt512;
// end	 
 
//RAMַ
wire [13:0] addressb;
reg [4:0]cnt_page_read;
assign addressb[13:0]={cnt_page_read[4:0],addrb_l[8:0]};		
 
assign page_read={11'b0,cnt_page_read};
//Ѷҳ߼
always @(posedge rd_clk)
	begin
		if(rst)
			cnt_page_read<=0;
		else if(addrb_l==511)
			cnt_page_read<=cnt_page_read+1;
	end
//߼
always@(posedge rd_clk)
 begin
   if (rst)
		begin
			work<=1'b0;
		end
	else if (cnt_page_read!=cnt_page)
		begin
			work<=1;
		end
	else
		begin
			work<=0;
		end
 end

always@(posedge rd_clk)
 begin
   if (rst)
		begin
			start<=1'b0;
//			cnt_page_read<=0;
		end
	else
		begin
			if ((busy_reg==1)&(busy_reg_reg==0))
				start<=0;
//			else if ((busy==0)&(busy_reg==1))
//				begin 
//					cnt_page_read<=cnt_page_read+1'b1;
//				end
			else if ((busy_reg==0)&(busy_reg_reg==0)&(work==1))
				start<=1;
		end
 end
	

//RAM_ethernet-------------------------------------------------------------------------------
RAM_ethernet RAM_ethernet(                         //500 pages
      .clka(clk),    
		.ena(en_sync_in), // input ena
	   .wea(en_sync_in),         	//ַͬ
	   .addra(addressa),				// input [17 : 0] addra
	   .dina(power_com),				// input [7 : 0] dina
	   .clkb(rd_clk),
	   .rstb(RST_66M),               
	   .addrb(addressb), 			// input [17 : 0] addrb
	   .doutb(power_out)				// output [7 : 0] doutb
		);
//------------------------------------------------------------------------------------------

//ʱӼֹ-------------------------------------------------------------------------
//always@(posedge clk)
//  begin
//   if (rst)
//      cnt_frame<=64'd0;			//64'd2
//   else		
//   	cnt_frame<=cnt_frame+1'b1;
//	end
//-------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
//always@(posedge clk)
//begin
//  if (rst)
//     ms_inner  <= 1'b0;
//  else if (	cnt_frame[28:0]==29'd299999999)
//     ms_inner<=1'b1;
//  else if (	cnt_frame[28:0]==29'd10)  
//     ms_inner <=1'b0;
//  else 
//     ms_inner <=ms_inner;
// end
//  
////assign ms_out = ms_inner;
//BUFG ms_out_module (
//      .O(ms_out), // 1-bit output: Clock buffer output
//      .I(ms_inner)  // 1-bit input: Clock buffer input
//   );
//------------------------------------------------------------------------------------------


endmodule
