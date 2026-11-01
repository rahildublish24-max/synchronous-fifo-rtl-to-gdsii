# RTL-to-GDSII flow notes

This document explains the intended flow and the purpose of the example scripts.

## 1. RTL design

`rtl/sync_fifo.sv` describes a parameterized synchronous FIFO. The design has one clock and an active-low asynchronous reset. `wr_en` and `rd_en` request operations; operations are accepted only when the FIFO is not full/empty respectively.

## 2. Functional verification

`tb/tb_sync_fifo.sv` instantiates a small FIFO and checks:
- Reset state.
- Filling to capacity and the `full` flag.
- FIFO ordering while draining.
- The `empty` flag after all entries are read.
- Reuse after pointer wrap-around.

The testbench uses a SystemVerilog queue as a simple reference model. It is a starter testbench, not exhaustive verification. Add randomized traffic, simultaneous read/write tests, reset-during-traffic tests, parameter sweeps, and assertions for stronger coverage.

## 3. Synthesis

`scripts/genus_synthesis_template.tcl` illustrates the structure of a Genus script:
- Load technology libraries.
- Read and elaborate RTL.
- Read timing constraints.
- Run generic synthesis, mapping, and optimization.
- Generate area, timing, and QoR reports.
- Write a mapped netlist and SDC.

Before running it, create the `reports/` and `results/` directories, use real library paths, confirm the commands for your tool version, and inspect all warnings and reports.

## 4. Physical design

`scripts/innovus_pnr_template.tcl` is a scaffold for Innovus. A complete flow needs technology LEF, standard-cell LEF, Liberty, a technology setup, floorplan decisions, power-grid definitions, placement, clock-tree synthesis, routing, extraction, and sign-off checks.

The commented commands are deliberately left as flow-stage reminders rather than pretending that a generic script can run across all PDKs and tool releases.

## 5. Timing constraints

`constraints/fifo.sdc` provides a simple example clock and I/O delay budget. These values are illustrative only. A real SDC must reflect the interface timing, clock source, uncertainty, latency, and sign-off methodology. Review reset treatment and all unconstrained paths.

## 6. Evidence to add after running the flow

Only add results you have actually generated and checked:
- Simulator transcript and functional coverage summary.
- Synthesis area/timing reports.
- Post-placement and post-route timing reports.
- DRC/LVS summaries.
- A floorplan or layout screenshot, if permitted to share.
- Tool versions and PDK/library information where disclosure is allowed.

Never publish proprietary PDK files, licensed libraries, internal scripts, or confidential university/company material.
