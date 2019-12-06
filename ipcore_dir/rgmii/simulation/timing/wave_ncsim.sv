# SimVision Command Script

#
# groups
#
if {[catch {group new -name {System Signals} -overlay 0}] != ""} {
    group using {System Signals}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.reset \
    :testbench.gtx_clk

if {[catch {group new -name {TX MAC Interface} -overlay 0}] != ""} {
    group using {TX MAC Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.dut.\\v6emac_fifo_block/tx_axis_mac_tvalid \
    :testbench.dut.\\v6emac_fifo_block/tx_axis_mac_tdata \
    :testbench.dut.\\v6emac_fifo_block/tx_axis_mac_tready \
    :testbench.dut.\\v6emac_fifo_block/tx_axis_mac_tlast \
    :testbench.dut.\\v6emac_fifo_block/tx_axis_mac_tuser

if {[catch {group new -name {RX MAC Interface} -overlay 0}] != ""} {
    group using {RX MAC Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.dut.\\v6emac_fifo_block/rx_axis_mac_tvalid \
    :testbench.dut.\\v6emac_fifo_block/rx_axis_mac_tdata \
    :testbench.dut.\\v6emac_fifo_block/rx_axis_mac_tlast \
    :testbench.dut.\\v6emac_fifo_block/rx_axis_mac_tuser

if {[catch {group new -name {TX RGMII Interface} -overlay 0}] != ""} {
    group using {TX RGMII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.rgmii_txc \
    :testbench.rgmii_tx_ctl \
    :testbench.rgmii_txd

if {[catch {group new -name {RX RGMII Interface} -overlay 0}] != ""} {
    group using {RX RGMII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.rgmii_rxc \
    :testbench.rgmii_rx_ctl \
    :testbench.rgmii_rxd


if {[catch {group new -name {Configuration Interface} -overlay 0}] != ""} {
    group using {Configuration Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.mac_speed         \
    :testbench.update_speed      \
    :testbench.dut.s_axi_awaddr  \
    :testbench.dut.s_axi_awready \
    :testbench.dut.s_axi_awvalid \
    :testbench.dut.s_axi_wdata   \
    :testbench.dut.s_axi_wready  \
    :testbench.dut.s_axi_wvalid  \
    :testbench.dut.s_axi_bready  \
    :testbench.dut.s_axi_bvalid  \
    :testbench.dut.s_axi_araddr  \
    :testbench.dut.s_axi_arready \
    :testbench.dut.s_axi_arvalid \
    :testbench.dut.s_axi_rdata   \
    :testbench.dut.s_axi_rready  \
    :testbench.dut.s_axi_rvalid


#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 906x585+25+55
} else {
    window geometry "Waveform 1" 906x585+25+55
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units fs \
    -valuewidth 75
cursor set -using TimeA -time 50,000,000,000fs
cursor set -using TimeA -marching 1
waveform baseline set -time 0

set groupId [waveform add -groups {{System Signals}}]
set groupId [waveform add -groups {{TX MAC Interface}}]
set groupId [waveform add -groups {{RX MAC Interface}}]

set groupId [waveform add -groups {{TX RGMII Interface}}]
set groupId [waveform add -groups {{RX RGMII Interface}}]
set groupId [waveform add -groups {{Configuration Interface}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us

