#!/bin/sh
mkdir work

ncvlog -work work ../../../rgmii.v

ncvlog -work work \
../../example_design/common/reset_sync.v \
../../example_design/common/sync_block.v \
../../example_design/fifo/tx_client_fifo_8.v \
../../example_design/fifo/rx_client_fifo_8.v \
../../example_design/fifo/ten_100_1g_eth_fifo.v \
../../example_design/pat_gen/address_swap.v \
../../example_design/pat_gen/axi_mux.v \
../../example_design/pat_gen/axi_pat_gen.v \
../../example_design/pat_gen/axi_pat_check.v \
../../example_design/pat_gen/axi_pipe.v \
../../example_design/pat_gen/basic_pat_gen.v \
../../example_design/physical/rgmii_v2_0_if.v \
../../example_design/statistics/vector_decode.v \
../../example_design/axi_lite/axi_lite_sm.v \
../../example_design/axi_ipif/counter_f.v \
../../example_design/axi_ipif/pselect_f.v \
../../example_design/axi_ipif/address_decoder.v \
../../example_design/axi_ipif/slave_attachment.v \
../../example_design/axi_ipif/axi_lite_ipif.v \
../../example_design/axi_ipif/axi4_lite_ipif_wrapper.v \
../../example_design/clk_wiz.v \
../../example_design/rgmii_block.v \
../../example_design/rgmii_fifo_block.v \
../../example_design/rgmii_example_design.v

ncvlog -work work ../phy_tb.v
ncvlog -work work ../demo_tb.v

ncelab -access +rw work.testbench glbl
ncsim -gui -input @"simvision -input wave_ncsim.sv" work.testbench
