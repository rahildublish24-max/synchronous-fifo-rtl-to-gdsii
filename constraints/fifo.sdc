# Illustrative SDC only. Replace values with project-specific constraints.
# Clock period is 10 ns (100 MHz) for this example.
create_clock -name clk -period 10.000 [get_ports clk]

# Example clock uncertainty and source latency.
set_clock_uncertainty 0.100 [get_clocks clk]
set_clock_latency 0.200 [get_clocks clk]

# Illustrative I/O budgets. Adjust for the real interface and environment.
set_input_delay  1.000 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.000 -clock clk [all_outputs]

# Reset is asynchronous in this RTL. Review reset handling and exceptions
# with the STA methodology used by your project before adding false paths.
