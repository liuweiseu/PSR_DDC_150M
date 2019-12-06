`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ģ�����ƣ�ADC_REG_MODULE
// ���ܣ�������ADC�Ĺܽ�ӳ��ɼĴ���
//////////////////////////////////////////////////////////////////////////////////
module ADC_REG_MODULE(
	input [15:0]ADC_REG,
	input ADC_MISO_IN,
	
	output [15:0]ADC_RD_BACK,
	output ADC_SCLK_OUT,
	output ADC_MOSI_OUT,
	output ADC_CSN_OUT,
	output ADC_RSTN_OUT,
	output ADC_SYNC_P,
	output ADC_SYNC_N
    );
//����߼�
assign ADC_SCLK_OUT = ADC_REG[0:0];
assign ADC_MOSI_OUT = ADC_REG[1:1];
assign ADC_CSN_OUT = ADC_REG[2:2];
assign ADC_RSTN_OUT = ADC_REG[3:3];

wire ADC_SYNC;
assign ADC_SYNC = ADC_REG[4:4];
//������������
OBUFDS #(
      .IOSTANDARD("LVDS_25") 		// Specify the output I/O standard(LVDS 2.5V ��ֽӿ�)
   ) OBUFDS_SYNC (
      .O(ADC_SYNC_P),     			// Diff_p output (connect directly to top-level port),UCF�����ADC
      .OB(ADC_SYNC_N),   			// Diff_n output (connect directly to top-level port),UCF�����ADC
      .I(ADC_SYNC)      			// Buffer input 
   );
//�����߼�
assign ADC_RD_BACK[0:0] = ADC_MISO_IN;
assign ADC_RD_BACK[15:1] = 0;

endmodule
