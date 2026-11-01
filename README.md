# Synchronous FIFO – RTL Design and Physical Design Flow

## Overview

This project focuses on the design of a synchronous FIFO (First In First Out) using SystemVerilog.

The FIFO stores data temporarily and outputs it in the same order in which it was received. The design uses read and write pointers along with status flags to manage data flow.

The project also includes a testbench for functional verification and TCL scripts demonstrating how synthesis and physical design steps can be organized.

## Features

- Parameterized data width and FIFO depth.
- Synchronous read and write operations.
- Full and empty flag generation.
- Read and write pointer management.
- Functional verification using a SystemVerilog testbench.
- TCL scripts for synthesis and physical design flow setup.

## Project Structure

```text
synchronous-fifo-rtl-to-gdsii/
│
├── rtl/
│   └── sync_fifo.sv
│
├── tb/
│   └── tb_sync_fifo.sv
│
├── constraints/
│   └── fifo.sdc
│
├── scripts/
│   ├── filelist.f
│   ├── run_sim.do
│   ├── genus_synthesis_template.tcl
│   └── innovus_pnr_template.tcl
│
├── docs/
│   └── rtl_to_gdsii_flow.md
│
├── reports/
├── results/
├── README.md
└── LICENSE
```

## Design Details

The FIFO has two main pointers:

- **Write Pointer:** Points to the location where the next data will be stored.
- **Read Pointer:** Points to the location from which data will be read.

A counter keeps track of the number of occupied locations.

The `full` flag is asserted when the FIFO reaches its maximum capacity, while the `empty` flag is asserted when there is no data available to read.

Default configuration:
- Data Width: 8 bits
- FIFO Depth: 16 entries

## Verification

A SystemVerilog testbench is included to check the basic functionality of the FIFO.

The testbench covers:
- Reset operation.
- Writing data into the FIFO.
- Reading data in FIFO order.
- Full and empty conditions.
- Pointer wrap-around.

## Synthesis and Physical Design

TCL templates are included for working with Cadence Genus and Innovus.

The scripts provide a starting point for:
- RTL elaboration and synthesis.
- Technology mapping.
- Timing constraint application.
- Area and timing report generation.
- Physical design flow setup.

The scripts require suitable technology libraries, LEF files and PDK configuration before they can be executed.

## Tools and Languages

- SystemVerilog
- TCL
- Cadence Genus
- Cadence Innovus
- Questa/ModelSim
- SDC

## Running the Simulation

Using Questa/ModelSim:

```tcl
vlog -sv -f scripts/filelist.f
vsim -c work.tb_sync_fifo -do "run -all; quit"
```

The testbench checks the FIFO operations and reports a PASS message when the included tests complete successfully.

---

*This repository contains a reference implementation and flow templates. Synthesis and physical design results should be added after running the flow with an appropriate technology setup.*
