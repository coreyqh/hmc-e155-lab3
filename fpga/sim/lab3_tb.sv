`timescale 1ms/1ns
/* verilator lint_off UNUSEDSIGNAL */
module lab3_tb;
    logic       rstn;
    logic [3:0] col;
    logic [3:0] row;
    logic [6:0] seg;
    logic       pwr1, pwr0;

    logic [31:0] testnum;

    lab3_top dut (.*);

    `ifdef VERILATOR
        initial begin
            $dumpfile("trace.vcd");
            $dumpvars(0, lab3_tb);
        end
    `endif 

    initial begin
        rstn = 0;
        #1ms;
        rstn = 1;
    end

    initial begin

        col = 4'b1111;

        #10ms;

        repeat (4) @(posedge dut.clk6MHz) begin
            col = row == 4'b1110 ? 4'b0111 : 4'b1111;
        end

        col = 4'b0111;

        #20ms;

        $display("test 1");
        assert (dut.s0 == 4'hA) else $display ("expecting A, actually %b", dut.s0);
        assert (dut.s1 == 4'hf) else $display ("expecting F, actually %b", dut.s1);

        #20ms;

        $display("test 2");
        assert (dut.s0 == 4'hA) else $display ("expecting A, actually %b", dut.s0);
        assert (dut.s1 == 4'hf) else $display ("expecting F, actually %b", dut.s1);

        col = 4'b1111;

        #20ms;

        $display("test 3");
        assert (dut.s0 == 4'hA) else $display ("expecting A, actually %b", dut.s0);
        assert (dut.s1 == 4'hf) else $display ("expecting F, actually %b", dut.s1);

        #30ms

        repeat (4) @(posedge dut.clk6MHz) begin
            col = row == 4'b1101 ? 4'b1101 : 4'b1111;
        end

        col = 4'b1101;

        #20ms;

        $display("test 4");
        assert (dut.s0 == 4'h5) else $display ("expecting 5, actually %b", dut.s0);
        assert (dut.s1 == 4'hA) else $display ("expecting A, actually %b", dut.s1);

        #20ms;

        $display("test 5");
        assert (dut.s0 == 4'h5) else $display ("expecting 5, actually %b", dut.s0);
        assert (dut.s1 == 4'hA) else $display ("expecting A, actually %b", dut.s1);

        col = 4'b1111;

        #20ms;

        $display("test 6");
        assert (dut.s0 == 4'h5) else $display ("expecting 5, actually %b", dut.s0);
        assert (dut.s1 == 4'hA) else $display ("expecting A, actually %b", dut.s1);

        #20ms;

        $finish;
    end
/* verilator lint_on UNUSEDSIGNAL */

endmodule
