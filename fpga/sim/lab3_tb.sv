`timescale 1ms/1ns

module lab3_tb;
    logic       rstn;
    logic [3:0] col;
    logic [3:0] row;
    logic [6:0] seg;
    logic       pwr1, pwr0;

    lab3_top dut (.*);

    initial begin
        rstn = 0;
        #1;
        rstn = 1;
    end

    initial begin
        #2;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #10ms;
        assert(dut.s0 == 4'hA);
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0001 ? 4'b1000 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #10ms;

        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #10ms;
        assert(dut.s0 == 4'h5);
        assert(dut.s1 == 4'hA);
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #5ns;
        col = row == 4'b0010 ? 4'b0010 : 4'b0000;
        #5ns;
        col = 4'b0000;
        #10ms;
        $finish;
    end

endmodule
