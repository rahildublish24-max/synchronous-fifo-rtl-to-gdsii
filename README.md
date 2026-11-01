# Synchronous FIFO — RTL-to-GDSII Portfolio Demonstration

A small, self-contained SystemVerilog FIFO project intended as a **portfolio demonstration** of RTL design, functional verification, and an ASIC implementation-flow setup.

> **Important:** This repository is a newly prepared reference implementation. It is not a recovered copy of the original university project, and the physical-design scripts are editable templates that must be adapted and run with the appropriate licensed EDA tools, technology files, and PDK. Do not describe a physical layout, timing result, area result, or sign-off as completed unless you have personally run and verified it.

## What is included

- Parameterized synchronous FIFO RTL with configurable data width and depth.
- Self-checking SystemVerilog testbench covering reset, writes, reads, full/empty behavior, and simultaneous read/write.
- A simple file list and example timing constraints.
- TCL templates showing how a typical synthesis and place-and-route flow can be organized.
- A flow guide describing the expected RTL-to-GDSII stages and the inputs required from a real technology setup.

## Architecture

The FIFO stores `DEPTH` words of `DATA_WIDTH` bits. A write pointer identifies the next location to write, and a read pointer identifies the next location to read. A count register tracks the number of occupied entries.

- `empty` is asserted when the occupancy count is zero.
- `full` is asserted when the occupancy count equals the configured depth.
- A write is accepted only when `wr_en && !full`.
- A read is accepted only when `rd_en && !empty`.
- Read data is registered on an accepted read.

The implementation uses a count-based full/empty scheme for clarity and ease of learning. For production designs, review reset strategy, memory inference, simultaneous-operation semantics, and timing/area trade-offs for the target library.

## Repository layout

```text
.
├── rtl/
│   └── sync_fifo.sv
├── tb/
│   └── tb_sync_fifo.sv
├── constraints/
│   └── fifo.sdc
├── scripts/
│   ├── filelist.f
│   ├── run_sim.do
│   ├── genus_synthesis_template.tcl
│   └── innovus_pnr_template.tcl
├── docs/
│   └── rtl_to_gdsii_flow.md
├── .gitignore
└── LICENSE
```

## Run the RTL testbench

The testbench is written in SystemVerilog. With Questa/ModelSim, from the repository root:

```tcl
vlog -sv -f scripts/filelist.f
vsim -c work.tb_sync_fifo -do "run -all; quit"
```

A simulator with equivalent SystemVerilog support can also be used. `scripts/run_sim.do` contains the same basic commands.

The testbench uses a scoreboard and calls `$fatal` if an expected behavior fails. A successful simulation should finish with:

```text
PASS: synchronous FIFO test completed
```

## ASIC flow overview

The scripts under `scripts/` are **templates**, not plug-and-play sign-off scripts. A real flow requires, at minimum:

1. A foundry/technology PDK and standard-cell libraries.
2. Correct LEF/Liberty files and technology files.
3. A floorplan, utilization target, power-grid strategy, and routing rules.
4. Tool-version-specific commands and project-specific paths.
5. Timing constraints reviewed against the intended clocking and I/O environment.

Typical stages:

1. RTL elaboration and checks.
2. Logic synthesis and technology mapping.
3. Floorplanning and power planning.
4. Placement and placement optimization.
5. Clock-tree synthesis.
6. Routing and post-route optimization.
7. Static timing analysis, DRC/LVS, and GDSII export.

See [`docs/rtl_to_gdsii_flow.md`](docs/rtl_to_gdsii_flow.md).

## Design parameters

| Parameter | Default | Description |
|---|---:|---|
| `DATA_WIDTH` | 8 | Number of bits per FIFO word |
| `DEPTH` | 16 | Number of entries |

For this simple count-based implementation, `DEPTH` must be at least 2. The pointer width is calculated using `$clog2(DEPTH)`.

## Limitations and next steps

- The example is a synchronous FIFO, not an asynchronous clock-domain-crossing FIFO.
- The RTL uses a register array; whether it maps to flops or a memory macro depends on the synthesis tool and target library.
- The SDC is illustrative. Replace the clock period and I/O delays with justified project requirements.
- The PnR TCL template contains explicit placeholders for technology-specific setup and should not be run unchanged.
- Add measured synthesis/PnR reports only after running the flow and checking the results.

## Suggested GitHub description

`Parameterized SystemVerilog synchronous FIFO with self-checking verification and editable RTL-to-GDSII flow templates.`

## Suggested topics

`systemverilog` `verilog` `rtl-design` `fifo` `asic` `vlsi` `functional-verification` `tcl` `physical-design`
