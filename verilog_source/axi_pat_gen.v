//------------------------------------------------------------------------------
// File       : axi_pat_gen.v
// Author     : Xilinx Inc.
// Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
// File       : axi_pat_gen.v
// Version    : 2.3
//-----------------------------------------------------------------------------//
// Description:  This is a very simple pattern generator which will generate packets
// with the supplied dest_addr and src_addr and incrementing data.  The packet size
// increments between the min and max size (which can be set to the same value if a
// specific size is required
//
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module axi_pat_gen #(
//   parameter               DEST_ADDR = 48'h74D4359BE879,   //自定义目的地址
//   parameter               SRC_ADDR  = 48'h5a0102030405,	  //自定义源地址
	parameter               MAX_SIZE  = 16'd512,
   parameter               MIN_SIZE  = 16'd512

)(
   input                   axi_tclk,
   input                   axi_tresetn,

   input                   enable_pat_gen,

   output reg  [7:0]       tdata,
   output                  tvalid,
   output reg              tlast,
   input                   tready,
	
  
  input[7:0] data_in, 
  input start,   //每生成一个32KRSR数据包，就会产生一个start信号过来，传输32K需要64个网络帧
  input [63:0] user_data,
  output rd_clk, 
  output reg[8:0] addr,
  output reg busy,
  input [15:0] page_read,					//modified on 150211
//  input [1:0] bag,									//modified on 150211
  
  input [15:0]mode_sel, //150916
  
  input [47:0]SRC_ADDR,
  input [47:0]DEST_ADDR,
  input [31:0]PPS_DETECT_CNT,
  //UDP用户可定义参数
  input [31:0]SRC_IP,
  input [31:0]DEST_IP,
  input [15:0]SRC_PORT,
  input [15:0]DEST_PORT
);

					
parameter 		SYS_SIZE   = 6'd30,  //its max_size depends on sys_count 20151008
					USER_SIZE  = 6'd8,  
					DATA_SIZE  = 16'd512,
					TOTAL_SIZE = SYS_SIZE+USER_SIZE+DATA_SIZE,
					IP_SIZE = 16'd20,
					UDP_SIZE = 16'd8,
               IP_PACK_SIZE = TOTAL_SIZE + IP_SIZE + UDP_SIZE,
					UDP_PACK_SIZE = TOTAL_SIZE + UDP_SIZE;

parameter      IDLE   = 0,
               HEADER = 1,
//             SIZE   = 2,

					TYPE = 2,
					IP = 3,
					UDP = 4,
					
//					SYS    = 3,//system  系统自定义段，用于保存千兆模块定义的变量，如网络帧号等
//					USER   = 4,//user    用户自定义段，用于保存用户定义的一些变量，如数据分段序号等
//             DATA   = 5;// data   数据段，用于保存用户数据
					SYS    = 5,//system  系统自定义段，用于保存千兆模块定义的变量，如网络帧号等
					USER   = 6,//user    用户自定义段，用于保存用户定义的一些变量，如数据分段序号等
               DATA   = 7;// data   数据段，用于保存用户数据


reg         [3:0]          header_count;

reg         [4:0]          ip_count;
reg         [2:0]          udp_count;

reg         [5:0]				sys_count;
reg         [5:0]				user_count;
reg         [11:0]         data_count;

reg         [63:0]         user_reg;

reg         [2:0]          next_gen_state;
reg         [2:0]          gen_state;

//wire        [7:0]          lut_data;
reg        [7:0]          lut_data;

reg                        tvalid_int;

wire                       axi_treset;

reg         [31:0]    frame_count;
reg         [7:0]     sys_byte;
reg         [7:0] 	 user_byte;

reg         [7:0]     ip_byte;
reg         [7:0]     udp_byte;

assign axi_treset = !axi_tresetn;

assign rd_clk = axi_tclk;




// simple state machine to control the data 网络帧基于状态机实现
// on the transition from IDLE we reset the counters and increment the packet size
always @(gen_state or enable_pat_gen or tready or header_count or sys_count or user_count or data_count or tvalid_int or start)
begin
   next_gen_state = gen_state;
   case (gen_state)
      IDLE : begin
      if (enable_pat_gen & start & !tvalid_int)begin
//		if (enable_pat_gen & !tvalid_int)begin
				//busy <= 1;
            next_gen_state = HEADER;
			end
      end
      HEADER : begin
         if ((header_count == 4'd11) && tready)
//          next_gen_state = SIZE;
				next_gen_state = TYPE;
      end
//    SIZE : begin
//       if ((header_count == 4'd13) && tready)
//          next_gen_state = SYS;
//    end

		TYPE : begin
         if ((header_count == 4'd13) && tready)
            next_gen_state = IP;
      end
		IP : begin
			if ((ip_count == (IP_SIZE-1)) && tready)
				next_gen_state = UDP;
		end
		UDP : begin
			if ((udp_count == (UDP_SIZE-1)) && tready)
				next_gen_state = SYS;
		end
		
		SYS : begin
         if ((sys_count == (SYS_SIZE-1)) && tready)
            next_gen_state = USER;
      end
		
		USER : begin
         if ((user_count == (USER_SIZE-1)) && tready)
            next_gen_state = DATA;
      end
		
      DATA : begin
         if ((data_count == 12'd1) && tready) begin
			next_gen_state = IDLE;
         end
      end
      default : begin
         next_gen_state = IDLE;
      end
   endcase
end

always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      gen_state <= IDLE;
   end
   else begin
   gen_state <= next_gen_state;
   end
end

// need a small count to manage the header insertion
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      header_count <= 4'd0;
   end
   else if ((gen_state != IDLE) && !(&header_count) & (tready | !tvalid_int)) begin
      header_count <= header_count + 4'd1;
   end
   else if (gen_state == IDLE) begin
      header_count <= 4'd0;
   end
end

//need a count to manage the IP header
always @(posedge axi_tclk)
begin
	if (axi_treset) begin
		ip_count <= 5'd0;
	end
	else if ((gen_state == IP) && !(&ip_count) & (tready)) begin
		ip_count <= ip_count + 5'd1;
	end
	else if (gen_state == IDLE) begin
		ip_count <= 5'd0;
	end
end

//need a count to manage the UDP header
always @(posedge axi_tclk)
begin
	if (axi_treset) begin
		udp_count <= 3'd0;
	end
	else if ((gen_state == UDP) && !(&udp_count) & (tready)) begin
		udp_count <= udp_count + 3'd1;
	end
	else if (gen_state == IDLE) begin
		udp_count <= 3'd0;
	end
end

//system counter
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      sys_count <= 6'd0;
   end
   else if ((gen_state ==	SYS) && !(&sys_count) & (tready)) begin
      sys_count <= sys_count + 6'd1;
   end
   else if (gen_state == IDLE) begin
      sys_count <= 6'd0;
   end
end

//user counter
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      user_count <= 6'd0;
   end
   else if ((gen_state ==	USER) && !(&user_count) & (tready)) begin
      user_count <= user_count + 6'd1;
   end
   else if (gen_state == IDLE) begin
      user_count <= 6'd0;
   end
end

// DATA counter - max size limited to 11 bits
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      data_count <= 12'd0;
   end
   else if ((gen_state == DATA) && |data_count && tready) begin
      data_count <= data_count - 12'd1;
   end
   else if (gen_state == IDLE) begin
      data_count <= DATA_SIZE;
   end
end

// store the parameterized values in a lut (64 deep) 将目的地址和源地址存入查找表，方便后续使用
// this should mean the values could be adjusted in fpga_editor etc..
genvar i;
generate
  for (i=0; i<=7; i=i+1) begin : gen_addr
//    LUT6 #(
//       .INIT      ({52'd0,
//                    SRC_ADDR[i],
//                    SRC_ADDR[i+8],
//                    SRC_ADDR[i+16],
//                    SRC_ADDR[i+24],
//                    SRC_ADDR[i+32],
//                    SRC_ADDR[i+40],
//                    DEST_ADDR[i],
//                    DEST_ADDR[i+8],
//                    DEST_ADDR[i+16],
//                    DEST_ADDR[i+24],
//                    DEST_ADDR[i+32],
//                    DEST_ADDR[i+40]
//                   })   // Specify LUT Contents
//    ) LUT6_inst (
//       .O         (lut_data[i]),
//       .I0        (header_count[0]),
//       .I1        (header_count[1]),
//       .I2        (header_count[2]),
//       .I3        (header_count[3]),
//       .I4        (1'b0),
//       .I5        (1'b0)
//    );
	always @(header_count[0] or header_count[1] or header_count[2] or header_count[3])
		begin
			if(header_count==0) lut_data[i]<=DEST_ADDR[i+40];
			else if(header_count==1 ) lut_data[i]<=DEST_ADDR[i+32];
			else if(header_count==2 ) lut_data[i]<=DEST_ADDR[i+24];
			else if(header_count==3 ) lut_data[i]<=DEST_ADDR[i+16];
			else if(header_count==4 ) lut_data[i]<=DEST_ADDR[i+8];
			else if(header_count==5 ) lut_data[i]<=DEST_ADDR[i];
			else if(header_count==6 ) lut_data[i]<=SRC_ADDR[i+40];
			else if(header_count==7 ) lut_data[i]<=SRC_ADDR[i+32];
			else if(header_count==8 ) lut_data[i]<=SRC_ADDR[i+24];
			else if(header_count==9 ) lut_data[i]<=SRC_ADDR[i+16];
			else if(header_count==10) lut_data[i]<=SRC_ADDR[i+8];
			else if(header_count==11) lut_data[i]<=SRC_ADDR[i];
			else lut_data[i]<=0;
		end
   end
endgenerate


// now generate the output for different state
always @(posedge axi_tclk)
begin
   if ((gen_state == HEADER) && (tready | !tvalid_int))
      tdata <= lut_data;
		
//   else if ((gen_state == SIZE) && tready) begin
	else if ((gen_state == TYPE) && tready) begin
      if (header_count[0])
//         tdata <= TOTAL_SIZE[7:0];
			tdata <= 8'h00;
      else
//         tdata <= {5'h0, TOTAL_SIZE[10:8]};
         tdata <= 8'h08;
   end
	
	else if ((gen_state == IP) && tready)begin
		tdata <= ip_byte;
	end
	
	else if ((gen_state == UDP) && tready)begin
		tdata <= udp_byte;	
	end
	
	else if ((gen_state == SYS) && tready)begin
			tdata <= sys_byte;
	end
	
	else if ((gen_state == USER) && tready)begin
			tdata <= user_byte;
	end
	
	else if ((gen_state == DATA) && tready)begin
			tdata <= data_in;
	end
	
end

//addr 比 data 慢两个时钟周期，所以要提前两个时钟周期周期进行准备
always @(posedge axi_tclk)
begin
	if ((next_gen_state == DATA) && tready)
				addr <= addr + 9'd1;
	else if ((gen_state == USER) && (user_count==(USER_SIZE-1))  && tready) //USER_SIZE-2
		addr <= addr + 9'd1;
	else if (gen_state == IDLE)
		addr <= 0;
end

// generate the output for SYS state
always @(posedge axi_tclk)
begin
	if (axi_treset)
		frame_count <= 0;
	else if ((data_count == 12'd1) && tready)begin
		frame_count <= frame_count + 32'd1;
	end
end

always @(posedge axi_tclk)						//modified on 150211
begin
	if (tready)begin
		case(sys_count)
			6'd0:begin
			if(gen_state == SYS)
			sys_byte <= frame_count[23:16];
			else
			sys_byte <= frame_count[31:24];
			end
			6'd1:begin
			sys_byte <= frame_count[15:8];
			end
			6'd2:begin
			sys_byte <= frame_count[7:0];
			end
			6'd3:begin
			sys_byte <= mode_sel[7:0];//mode_sel[15:8];
			end
			6'd4:begin
			sys_byte <= page_read[7:0];;//mode_sel[7:0];//
			end
			6'd5:begin
			sys_byte <= 8'h53;//S//page_read[15:8];			//此处用于表明当前数字帧传的是第几个512字节
			end
			6'd6:begin
			sys_byte <= 8'h45;//E//page_read[7:0]; //此处用于表明当前数字帧传的是第几个512字节
			end
			6'd7:begin
			sys_byte <= 8'h55;//U
			end
			6'd8:begin
			sys_byte <= 8'h50;//P
			end
			6'd9:begin
			sys_byte <= 8'h53;//S
			end
			6'd10:begin
			sys_byte <= 8'h52;//R
			end
			6'd11:begin
			sys_byte <= 8'h56;//V
			end
			6'd12:begin
			sys_byte <= 8'h32;//2
			end
			6'd13:begin
			sys_byte <= PPS_DETECT_CNT[7:0];//
			end
			6'd14:begin
			sys_byte <= PPS_DETECT_CNT[15:8];
			end
			6'd15:begin
			sys_byte <= PPS_DETECT_CNT[23:16];//8'h2D;//-
			end
			6'd16:begin
			sys_byte <= PPS_DETECT_CNT[31:24];//8'h41;//A
			end
			default:begin
			sys_byte <= 0;
			end
		endcase
	end
end

//generate the output for IP state
reg [15:0] ipchecksum;
reg [31:0] ipchecksum_tmp;
always @(posedge axi_tclk)
begin
	//0x4500+IP_PACK_SIZE[15:0]+frame_count[15:0]+0x0000+0x4011
	//+SRC_IP[31:16]+SRC_IP[15:0]+DEST_IP[31:16]+DEST_IP[15:0]
	ipchecksum_tmp=32'h00008511+{16'h0000,IP_PACK_SIZE[15:0]}+{16'h0000,frame_count[15:0]}
	+{16'h0000,SRC_IP[31:16]}+{16'h0000,SRC_IP[15:0]}+{16'h0000,DEST_IP[31:16]}+{16'h0000,DEST_IP[15:0]};
	ipchecksum_tmp=ipchecksum_tmp[31:16]+ipchecksum_tmp[15:0];
end

always @(ipchecksum_tmp)
begin
	if (ipchecksum_tmp & 32'hffff0000) begin //检查溢出
		ipchecksum=ipchecksum_tmp;
		ipchecksum=ipchecksum+1;
	end
	else
		ipchecksum=ipchecksum_tmp;
	ipchecksum=~ipchecksum;
end

always @(posedge axi_tclk)
begin
	if (gen_state == TYPE)
	//提前一个时钟周期
		//版本
		ip_byte <= 8'h45;
	else if ((gen_state == IP) && tready) begin
		case(ip_count)
		//IP数据包长度
			5'd1:begin
				ip_byte <= IP_PACK_SIZE[15:8];
			end
			5'd2:begin
				ip_byte <= IP_PACK_SIZE[7:0];
			end
		//数据包标识
			5'd3:begin
				ip_byte <= frame_count[15:8];
			end
			5'd4:begin
				ip_byte <= frame_count[7:0];
			end
		//生命周期
			5'd7:begin
				ip_byte <= 8'h40;
			end
		//传输层协议类型
			5'd8:begin
				ip_byte <= 8'h11;
			end
		//IP校验和
			5'd9:begin
				ip_byte <= ipchecksum[15:8];
			end
			5'd10:begin
				ip_byte <= ipchecksum[7:0];
			end
		//源IP：192.168.253.1
			5'd11:begin
				ip_byte <= SRC_IP[31:24];
			end
			5'd12:begin
				ip_byte <= SRC_IP[23:16];
			end
			5'd13:begin
				ip_byte <= SRC_IP[15:8];
			end
			5'd14:begin
				ip_byte <= SRC_IP[7:0];
			end
		//目的IP：192.168.253.8
			5'd15:begin
				ip_byte <= DEST_IP[31:24];
			end
			5'd16:begin
				ip_byte <= DEST_IP[23:16];
			end
			5'd17:begin
				ip_byte <= DEST_IP[15:8];
			end
			5'd18:begin
				ip_byte <= DEST_IP[7:0];
			end
		//默认字节0x00
			default:begin
				ip_byte <= 8'h00;
			end
		endcase
	end
end

//generate the output for UDP state
always @(posedge axi_tclk)
begin
	if (gen_state == IP)
	//提前一个时钟周期
		//源端口
		udp_byte <= SRC_PORT[15:8];
	else if ((gen_state == UDP) && tready) begin
		case(udp_count)
			3'd0:begin
				udp_byte <= SRC_PORT[7:0];
			end
			//目的端口
			3'd1:begin
				udp_byte <= DEST_PORT[15:8];
			end
			3'd2:begin
				udp_byte <= DEST_PORT[7:0];
			end
			//UDP数据包长度
			3'd3:begin
				udp_byte <= UDP_PACK_SIZE[15:8];
			end
			3'd4:begin
				udp_byte <= UDP_PACK_SIZE[7:0];
			end
			//UDP校验和
			3'd5:begin
				udp_byte <= 8'h00;
			end
			3'd6:begin
				udp_byte <= 8'h00;
			end
			//默认字节0x00
			default:begin
				udp_byte <= 8'h00;
			end
		endcase
	end
end


// generate the output for USER state
always @(posedge axi_tclk)
begin
	if ((gen_state == USER) && tready)begin
		user_reg=user_reg>>8;
		user_byte=user_reg[7:0];
	end
	else if(gen_state==HEADER)begin
		user_reg=user_data;
		user_byte=user_reg[7:0];
	end
end

// generate the busy output
always @(posedge axi_tclk)
begin
	if (gen_state != IDLE)begin
		busy<=1;
	end
	else if(gen_state==IDLE)begin
		busy<=0;
	end
end

// now generate the TLAST output
always @(posedge axi_tclk)
begin
   if (axi_treset)
      tlast <= 0;
   else if ((data_count == 12'd1) && tready)
      tlast <= 1;
   else if (tready)
      tlast <= 0;
end

// now generate the TVALID output
always @(posedge axi_tclk)
begin
   if (axi_treset)
      tvalid_int <= 0;
   else if (gen_state != IDLE)
		tvalid_int <= 1;
   else if (tready)
      tvalid_int <= 0;
end

assign tvalid = tvalid_int;



endmodule
