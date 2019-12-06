gui_open_window Wave
gui_list_select -id Hier.1 { testbench }
gui_list_select -id Data.1 { testbench.reset }
gui_sg_create TEMAC_Group
gui_list_add_group -id Wave.1 {TEMAC_Group}
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Test_semaphores }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Configuration_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Tx_RGMII_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Rx_RGMII_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Rx_MAC_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Tx_MAC_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { System_Signals }

gui_list_add -id Wave.1 -after System_Signals {{testbench.reset} {testbench.gtx_clk} }

gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tuser}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tlast}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tready}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tdata}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tkeep}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/tx_axis_mac_tvalid}}
gui_list_add -id Wave.1 -after Tx_MAC_Interface {{testbench.dut.tx_reset}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/rx_axis_mac_tuser}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/rx_axis_mac_tlast}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/rx_axis_mac_tdata}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/rx_axis_mac_tkeep}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.\v6emac_fifo_block/rx_axis_mac_tvalid}}
gui_list_add -id Wave.1 -after Rx_MAC_Interface {{testbench.dut.rx_reset}}
gui_list_add -id Wave.1 -after Tx_RGMII_Interface {{testbench.rgmii_tx_ctl}}
gui_list_add -id Wave.1 -after Tx_RGMII_Interface {{testbench.rgmii_txd}}
gui_list_add -id Wave.1 -after Tx_RGMII_Interface {{testbench.rgmii_txc}}
gui_list_add -id Wave.1 -after Rx_RGMII_Interface {{testbench.rgmii_rx_ctl}}
gui_list_add -id Wave.1 -after Rx_RGMII_Interface {{testbench.rgmii_rxd}}
gui_list_add -id Wave.1 -after Rx_RGMII_Interface {{testbench.rgmii_rxc}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_wvalid}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_wready}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_wdata}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_bvalid}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_bresp}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_bready}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_awvalid}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_awready}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_awaddr}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_rvalid}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_rresp}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_rready}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_rdata}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_arvalid}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_arready}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_araddr}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_resetn}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_reset_int}}
gui_list_add -id Wave.1 -after Configuration_Interface {{testbench.dut.s_axi_aclk}}

gui_zoom -window Wave.1 -full
