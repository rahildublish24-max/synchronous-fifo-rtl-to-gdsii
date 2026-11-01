`timescale 1ns/1ps

module tb_sync_fifo;
    localparam int DATA_WIDTH = 8;
    localparam int DEPTH = 4;
    localparam int COUNT_WIDTH = $clog2(DEPTH + 1);

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en = 0;
    logic rd_en = 0;
    logic [DATA_WIDTH-1:0] din = '0;
    logic [DATA_WIDTH-1:0] dout;
    logic full, empty;
    logic [COUNT_WIDTH-1:0] count;

    logic [DATA_WIDTH-1:0] expected_q[$];

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk, .rst_n, .wr_en, .din, .rd_en, .dout,
        .full, .empty, .count
    );

    always #5 clk = ~clk;

    task automatic tick;
        @(posedge clk);
        #1;
    endtask

    task automatic write_word(input logic [DATA_WIDTH-1:0] value);
        if (full) $fatal(1, "Test attempted write while FIFO full");
        @(negedge clk);
        wr_en = 1;
        din = value;
        expected_q.push_back(value);
        tick();
        @(negedge clk);
        wr_en = 0;
    endtask

    task automatic read_word;
        logic [DATA_WIDTH-1:0] expected;
        if (empty) $fatal(1, "Test attempted read while FIFO empty");
        expected = expected_q.pop_front();
        @(negedge clk);
        rd_en = 1;
        tick();
        if (dout !== expected)
            $fatal(1, "Data mismatch: expected %0h, got %0h", expected, dout);
        @(negedge clk);
        rd_en = 0;
    endtask

    initial begin
        repeat (2) tick();
        rst_n = 1;
        tick();

        if (!empty || full || count != 0)
            $fatal(1, "Reset/initial state check failed");

        write_word(8'h11);
        write_word(8'h22);
        write_word(8'h33);
        write_word(8'h44);

        if (!full || count != DEPTH)
            $fatal(1, "FIFO did not assert full at expected occupancy");

        // Drain in FIFO order.
        read_word();
        read_word();
        read_word();
        read_word();

        if (!empty || count != 0)
            $fatal(1, "FIFO did not return to empty");

        // Verify that the FIFO can be reused after pointer wrap-around.
        write_word(8'hA5);
        write_word(8'h5A);
        read_word();
        read_word();

        $display("PASS: synchronous FIFO test completed");
        $finish;
    end

    initial begin
        #2000;
        $fatal(1, "Watchdog timeout");
    end
endmodule
