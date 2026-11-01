# Questa/ModelSim example. Run from repository root.
vlib work
vlog -sv -f scripts/filelist.f
vsim -c work.tb_sync_fifo -do "run -all; quit"
