`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:27 09/01/2015 
// Design Name: 
// Module Name:    de_dispersion 
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
/*******************˼·****************************
1ȽPC˼õɫɢдpara RAM(2048)Удʱ򣬵ַ;ݾPC˸
ݵֵַȷдʹǷַС2047дʹܣ2047ֹдյĵַ
붨2047Ҫдɫɢ0ַҪдΣһεַ0ʹдʹܣڶʽ
д
2para RAMжʱдַͬźжǷöдַΪ2047˵дˣͬʱ⵽ͬ
źŵأ˵Чˣʱpara RAMʹܣparaдַΪ2047Ҽ⵽ͬźŵ½أ˵Ч
ʱرնʹ
3arm_ackźarmķźţÿarmdreadyźţΪʱȡݣȻһθߵƽarm_ack
źţdreadyźţʾѶȡҪעǣarm_ackź֮һҪѸ
ע⣺ʱϵϣܹ⿴룬ҪԼʱͼҸݷе˼·Ҫ
**************************************************/
//////////////////////////////////////////////////////////////////////////////////
module de_dispersion #(
	parameter BITWIDTH = 7,
	parameter FFT_POINT = 512,
	parameter SUB_FFT_POINT = 512
)(  
	input clk,
	input rst,
	input [7:0]power_com,
	input [15:0]para,
	input [(BITWIDTH+1):0]para_addr,
	input en_in_sync,
	output reg [23:0]power_com_out,
	output reg dready,
	input arm_ack,
	output reg [39:0]time_output,
	input arm_en,
	input [(BITWIDTH+1):0]para_raddr,
	output reg[15:0]para_out
  );
reg para_ena;//para RAMд˿ʹź
reg [(BITWIDTH+1):0]addr_out;//ַź
wire [(BITWIDTH+2):0]addr_out_plus;
reg [(BITWIDTH+1):0]para_addr_out;
reg para_wea;//para RAMʹź
//reg [8:0]max_delay;//ɫɢʱʱ䵥λֵ
reg para_enb;//paraRAM˿ʹź
reg para_enb_en;//paraRAM˿ʹźŵʹܣǵźΪ1ǿԴRAMݵ֮һ
reg para_enb_reg;//Ϊdisp_enaַͬһʱ̳֣disp_enapara_enbｫpara_enbʱʱƥ
reg para_enb_reg1;
reg para_enb_reg2;
reg para_enb_reg3;
reg para_enb_reg4;
/****************************Ϊpara ramõļĴ***************************/
wire [15:0]disp_raddr;//ĴĶַ
reg [15:0]disp_waddr;//Ĵдַ
reg [15:0]disp_raddr_mid;
reg [15:0]disp_waddr_mid;
reg [15:0]disp_raddr_reg;
reg [15:0]disp_waddr_reg;
reg disp_ena;
reg disp_wea;
reg disp_enb;
reg disp_enb_reg;
wire [23:0]power_com_out_reg;//
reg [23:0]power_com_in;//DISP_RAM˿ڽӵݣΪĽpower_comĺ
reg [15:0]base_addr;//һַÿһƵ֮ͨ󣬻ַ1ȷһֿʼʱǴһַʼۼ
reg [(BITWIDTH+1):0]cnt;//ڼΪÿ2048ݲһ
wire [(BITWIDTH+2):0] cnt_plus;
reg en_in_sync_reg;//ʹźŵһclkʱ
reg [7:0]power_com_reg;//źţźʱ1clk
reg [7:0]power_com_reg1;//źţźʱ2clk
reg [7:0]power_com_reg2;//źţźʱ3clk
reg [7:0]power_com_reg3;//źţźʱ4clk
reg [7:0]power_com_reg4;//źţźʱ5clk
//reg [7:0]power_com_reg5;
//Ϊݽʱܻen_in_syncźһʱ
reg output_en;//ʹ
reg output_en_reg;//ʹܵһclkʱ
reg cnt_en;//ʹź
wire [39:0]time_flag;//ʱϢ
//ʱĸclkҪΪʱϵ
//ע⣡Уen_in_syncźͬģҪݽ֮Ҫʱ4clkͬģҪʵʵʱ
always @(posedge clk)
	begin
		if(rst)
			begin
				power_com_reg<=8'b0;
				power_com_reg1<=8'b0;
				power_com_reg2<=8'b0;
				power_com_reg3<=8'b0;
				power_com_reg4<=8'b0;
//				power_com_reg5<=8'b0;
			end
		else 
			begin
				power_com_reg1<=power_com;
				power_com_reg2<=power_com_reg1;
				power_com_reg3<=power_com_reg2;
				power_com_reg4<=power_com_reg3;
				power_com_reg<=power_com_reg4;
//				power_com_reg<=power_com_reg5;
			end
	end

always @(posedge clk)
	begin
		if(rst)en_in_sync_reg<=1'b0;
		else en_in_sync_reg<=en_in_sync;
	end
//رpara RAMдʹ
always @(posedge clk)
	begin
		if(rst)
			begin
				para_ena<=1'b0;
				para_wea<=1'b0;
			end
		else if(arm_en==1)//ARMдpara_addrʱҪдΣһдʹܣڶʽд para_addr==2047
				begin
					para_ena<=1'b0;
					para_wea<=1'b0;
				end
			else 
				begin
					para_ena<=1'b1;
					para_wea<=1'b1;
				end
	end
//para RAMʹ
always @(posedge clk)
	begin 
		if(rst)
			begin
				//max_delay<=9'b0;
				para_enb_en<=1'b0;
			end
			else if(arm_en==1)//Ҫɫɢд para_addr==2047
				begin
					para_enb_en<=1'b1;
					//max_delay<=para;
				end
			else para_enb_en<=1'b0;
	end
//дʹҪɫɢѾд룬para_enb_en=1ͬʱͬźصˣͬź½صˣرдʹ
always@(posedge clk)
	begin
		if(rst)para_enb<=1'b0;
		else if(para_enb_en==0)para_enb<=1'b0;
		else if(para_enb_en==1 && en_in_sync_reg==0 &&en_in_sync==1)para_enb<=1'b1;
		else if(para_enb_en==1 && en_in_sync_reg==1 &&en_in_sync==0)para_enb<=1'b0;		
	end
//para_eab״̬ȷַǷʼϼ

assign addr_out_plus = addr_out+1'b1;
always @(posedge clk)
	begin
		if(rst)
			addr_out<=10'b0;
		else if(para_enb==1)
			addr_out<=addr_out_plus[(BITWIDTH+1):0];
				else addr_out<=0;
	end
//arm_enֵȷpara ramĶַ
always @(posedge clk)
	begin
		if(rst)
			para_addr_out<=0;
		else if(arm_en==0)para_addr_out<=para_raddr;
		else para_addr_out<=addr_out;
	end
//para RAMģ飬ڴɫɢϵ
PARA_RAM mypararam (
  .clka(clk), // input clka
  .ena(para_ena), // input ena
  .wea(para_wea), // input [0 : 0] wea
  .addra(para_addr), // input [10 : 0] addra
  .dina(para), // input [15 : 0] dina
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(1), // input enb para_enb
  .addrb(para_addr_out), // input [10 : 0] addrb
  .doutb(disp_raddr) // output [15 : 0] doutb
);
//disp_raddrһclkʱarm֤
always @(posedge clk)
	begin
		if(rst)para_out<=0;
		else para_out<=disp_raddr;
	end
/************************************ɶpara RAMݵĴ洢********************************************/
//Ϊʱϣpara_enbʱһclkһʹź
always @(posedge clk)
	begin
		if(rst)
			begin
				para_enb_reg<=1'b0;
				para_enb_reg1<=1'b0;
				para_enb_reg2<=1'b0;
				para_enb_reg3<=1'b0;
				para_enb_reg4<=1'b0;
			end
		else 
			begin
				para_enb_reg<=para_enb;
				para_enb_reg1<=para_enb_reg;
				para_enb_reg2<=para_enb_reg1;
				para_enb_reg3<=para_enb_reg2;
				para_enb_reg4<=para_enb_reg3;
			end
	end
	
//
assign cnt_plus = cnt;
always @(posedge clk)
	begin
		if(rst)
			cnt<=11'b0;
		else if(cnt_en==1)
					cnt<=cnt_plus[(BITWIDTH+1):0];
				else cnt<=11'b0; 
	end
//ʹ
always @(posedge clk)
	begin 
		if(rst)
			cnt_en<=1'b0;
		else if(para_enb_reg1==1) //para_enb_reg==1
					cnt_en<=1'b1;	
			else cnt_en<=1'b0;
	end
//ʹźʹ߼
always @(posedge clk)
	begin 
		if(rst)
			begin
				disp_ena<=1'b0;
				disp_wea<=1'b0;
			end
		else if(para_enb_reg1==1) //para_enb_reg==1
				begin
					disp_ena<=1'b1;
					disp_wea<=1'b1;
				end
			else if(para_enb_reg3==0 && para_enb_reg4==1)//cnt==2047 ! ⵽дʹܵ½ para_enb_reg2==0 && para_enb_reg3==1
				begin
					disp_ena<=1'b1;
					disp_wea<=1'b1;
				end
			else	
				begin
					disp_ena<=1'b0;
					disp_wea<=1'b0;
				end
	end
//дʹź߼
always @(posedge clk)//дʹźǶʹźŵclkʱ
	begin
		if(rst)
				disp_enb<=1'b0;
		else if(para_enb_reg4==1 || para_enb_reg3==1) //para_enb_reg3==1 || para_enb_reg2==1
					disp_enb<=1'b1;
				else	disp_enb<=1'b0;
	end
//дʹź߼һclkʱ
always @(posedge clk)
	begin
		if(rst)disp_enb_reg<=1'b0;
		else disp_enb_reg<=disp_enb;
	end
//дַȶַڣΪҪȰȡҪһڣٸӣҪһ
always @(posedge clk)
	begin
		if(rst)
			begin
				disp_waddr<=0;//֮510ΪϵͳտʼʱַΪ0дַҪȶַ2clk
				disp_waddr_mid<=0;
			end
		else if(para_enb_reg1==1)//para_enb_reg==1
			begin
				disp_waddr_mid<=disp_raddr;
				disp_waddr<=disp_waddr_mid;
			end
	end

//ȷַı仯
always @(posedge clk)
	begin
		if(rst)
			base_addr<=16'b0;
		else if(para_enb_reg3==0 && para_enb_reg4==1)base_addr<=base_addr+1;//cnt == 2047 para_enb_reg2==0 && para_enb_reg3==1
	end

//ȷյĶдַ
always @(posedge clk)
	begin
		if(rst)
			begin
				disp_waddr_reg<=16'b0;
				disp_raddr_reg<=16'b0;
			end
		else if(para_enb_reg3==0 && para_enb_reg4==1)//cnt==2047 para_enb_reg2==0 && para_enb_reg3==1
			begin
				disp_waddr_reg<=base_addr-1;
				//֮-1ΪöдͬһַΪз֣
				//дͬһַʱ˿ڲramȡݣֱӽд˿ڵݸĶ˿
				disp_raddr_reg<=base_addr;
			end
		else
			begin
				disp_waddr_reg<=disp_waddr+base_addr;//м仺Ķдַpara RAMеֵ+base_addrֵ
				disp_raddr_reg<=disp_raddr+base_addr;
			end
	end
//ַʱһclk
always @(posedge clk)
	begin
		if(rst)disp_raddr_mid<=16'b0;
		else disp_raddr_mid<=disp_raddr_reg;
	end
//ʹȷ
always @(posedge clk)
		begin
			if(rst)output_en<=1'b0;
			else if(para_enb_reg3==0 && para_enb_reg4==1)output_en<=1'b1;//cnt==2047 para_enb_reg2==0 && para_enb_reg3==1
			else output_en<=1'b0;
		end
//ʹܵ1clkʱΪʱ
always @(posedge clk)
	begin
		if(rst)output_en_reg<=1'b0;
		else output_en_reg<=output_en;
	end
//ȷյӦÿ2048һ
always @(posedge clk)
	begin
		if(rst)
			begin
				power_com_out<=24'b0;
				dready<=1'b0;
				time_output<=40'b0;
			end
		else if(output_en_reg==1)
					begin
						power_com_out<=power_com_out_reg;
						dready<=1'b1;
						time_output<=time_flag;
					end
				else //if(arm_ack==1)
					begin
//						power_com_out<=24'b0;
						dready<=1'b0;
						time_output<=time_flag;
					end
	end
//ƵͨۼӣӵDISP_RAM˿
always @(posedge clk)
	begin 
		if(rst)power_com_in<=24'b0;
		else if(para_enb_reg3==0 && para_enb_reg4==1)power_com_in<=24'b0;//cnt==2047 //para_enb_reg2==0 && para_enb_reg3==1
		else if(disp_enb==0 && disp_enb_reg==1)power_com_in<=24'b0;
		else if(en_in_sync==1 && en_in_sync_reg==0)power_com_in<=24'b0;
		else if(disp_raddr_mid!=disp_waddr_reg)power_com_in<=power_com_out_reg+power_com_reg;
		//Ҫע⣬ͬһַҪ⴦
		else power_com_in<=power_com_in+power_com_reg;//ҪΪдȶҪڣ
		//ɫɢʱдͬһramַ⣬ʱдͬһַдҪ仯һ
		//modelsimʱֵ
	end

//DISP RAMģ飬ڻƵͨӵ
DISP_RAM mydispram(
  .clka(clk), // input clka
  .ena(disp_enb), // input ena
  .wea(disp_enb), // input [0 : 0] wea
  .addra(disp_waddr_reg), // input [15 : 0] addra
  .dina(power_com_in), // input [23 : 0] dina
  .clkb(clk), // input clkb
  .enb(disp_ena),
  .addrb(disp_raddr_reg), // input [15 : 0] addrb
  .doutb(power_com_out_reg) // output [23 : 0] doutb
);
/*
DISP_RAM mydispram (
  .clka(clk), // input clka
  .rsta(rst), // input rstb
  .ena(disp_enb), // input ena
  .wea(disp_enb), // input [0 : 0] wea
  .addra(disp_waddr_reg), // input [8 : 0] addra
  .dina(power_com_in), // input [24 : 0] dina
  .douta(), // output [15 : 0] douta
  .clkb(clk), // input clkb
  .rstb(rst), // input rstb
  .enb(disp_ena), // input enb
  .web(0), // input [0 : 0] web
  .addrb(disp_raddr_reg), // input [8 : 0] addrb
  .dinb(0), // input [15 : 0] dinb
  .doutb(power_com_out_reg) // output [24 : 0] doutb
);*/
US_TIMER #(
	 .BITWIDTH(BITWIDTH),
	 .FFT_POINT(FFT_POINT),
	 .SUB_FFT_POINT(SUB_FFT_POINT)
)time_flag_gen(
	.clk(clk),
	.rst(rst),
	.user_data(time_flag)
);
endmodule
