#!/bin/sh
# file: implement.sh

#-----------------------------------------------------------------------------
# Script to synthesize and implement the RTL provided for the clocking wizard
#-----------------------------------------------------------------------------

# Clean up the results directory
rm -rf results
mkdir results

# Copy unisim_comp.v file to results directory
cp $XILINX/verilog/src/iSE/unisim_comp.v ./results/

# Synthesize the Verilog Wrapper Files
echo 'Synthesizing System Monitor Wizard design with XST'
xst -ifn xst.scr
cp SYS_MON_exdes.ngc results/

#  Copy the constraints files generated by Coregen
#echo 'Copying files from constraints directory to results directory'
#cp ../SYS_MON.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild SYS_MON_exdes

echo 'Running map'
map -timing SYS_MON_exdes -o mapped.ncd

echo 'Running par'
par -w mapped.ncd routed mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level model for the System Monitor Wizard example design'
netgen -ofmt verilog -sim -tm SYS_MON_exdes -w routed.ncd routed.v
cd ..
