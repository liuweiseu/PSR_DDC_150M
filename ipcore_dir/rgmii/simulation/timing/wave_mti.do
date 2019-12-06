view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -divider {Tx MAC Interface}
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/tx_axis_mac_tvalid }
add wave -noupdate -format Literal {/testbench/dut/\v6emac_fifo_block/tx_axis_mac_tdata }
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/tx_axis_mac_tready }
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/tx_axis_mac_tlast }
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/tx_axis_mac_tuser }
add wave -noupdate -divider {Rx MAC Interface}
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/rx_axis_mac_tvalid }
add wave -noupdate -format Literal {/testbench/dut/\v6emac_fifo_block/rx_axis_mac_tdata }
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/rx_axis_mac_tlast }
add wave -noupdate -format Logic {/testbench/dut/\v6emac_fifo_block/rx_axis_mac_tuser }
add wave -noupdate -divider {Tx RGMII Interface}
add wave -noupdate -format logic /testbench/rgmii_txc
add wave -noupdate -format logic /testbench/rgmii_tx_ctl
add wave -noupdate -format logic -hex /testbench/rgmii_txd
add wave -noupdate -divider {Rx RGMII Interface}
add wave -noupdate -format logic /testbench/rgmii_rxc
add wave -noupdate -format logic /testbench/rgmii_rx_ctl
add wave -noupdate -format logic -hex /testbench/rgmii_rxd
add wave -noupdate -divider {AXI4 Lite Interface}
add wave -noupdate -format Literal /testbench/mac_speed
add wave -noupdate -format Logic /testbench/update_speed
add wave -noupdate -format Literal /testbench/dut/s_axi_awaddr
add wave -noupdate -format Logic /testbench/dut/s_axi_awready
add wave -noupdate -format Logic /testbench/dut/s_axi_awvalid
add wave -noupdate -format Literal /testbench/dut/s_axi_wdata
add wave -noupdate -format Logic /testbench/dut/s_axi_wready
add wave -noupdate -format Logic /testbench/dut/s_axi_wvalid
add wave -noupdate -format Logic /testbench/dut/s_axi_bready
add wave -noupdate -format Logic /testbench/dut/s_axi_bvalid
add wave -noupdate -format Literal /testbench/dut/s_axi_araddr
add wave -noupdate -format Logic /testbench/dut/s_axi_arready
add wave -noupdate -format Logic /testbench/dut/s_axi_arvalid
add wave -noupdate -format Literal /testbench/dut/s_axi_rdata
add wave -noupdate -format Logic /testbench/dut/s_axi_rready
add wave -noupdate -format Logic /testbench/dut/s_axi_rvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
