#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir -p results

echo 'Synthesizing example design with XST';
xst -ifn xst.scr
cp rgmii_example_design.ngc results/

# Copy the EDIF's generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../rgmii.ngc results/

echo 'Copying files from constraints directory to results directory'
cp ../example_design/rgmii_example_design.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -uc rgmii_example_design.ucf rgmii_example_design.ngc rgmii_example_design.ngd

echo 'Running map'
map -detail -ol high rgmii_example_design -o mapped.ncd

echo 'Running par'
par -ol high mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed routed mapped.pcf

echo 'Running netgen to create gate level Verilog model'
netgen -ofmt verilog -sim -dir . -pcf mapped.pcf -tm rgmii_example_design -w -sdf_anno false routed.ncd routed.v
