
 
 
 



 

window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /adc_snap_ram_psr_tb/status
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/CLKA
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/ADDRA
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/DINA
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/WEA
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/ENA
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/RSTB
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/CLKB
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/ADDRB
      waveform add -signals /adc_snap_ram_psr_tb/adc_snap_ram_psr_synth_inst/bmg_port/DOUTB
console submit -using simulator -wait no "run"
