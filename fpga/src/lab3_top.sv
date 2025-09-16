module lab3_top (
    input  logic       rstn,
    input  logic [3:0] col,
    output logic [3:0] row,
    output logic [6:0] seg,
    output logic       pwr1, pwr0
);
    logic       clk48kHz, clk100Hz;
    logic [3:0] colDly, colSync, activeCol;
    logic [3:0] rowDly, rowSync;
    logic       stall,  strobe;
    logic [3:0] s1, s0, s0next;
    logic       dbhigh, dblow, dbreq;

    `ifdef VERILATOR 
        initial begin
            clk48kHz = 1'b0;
            forever #20ns clk = ~clk;
        end
    `else
        HSOSC osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk48kHz));
    `endif

    clkDiv #(.P(35), .N(24)) clkDiv100 (.fastClk(clk48kHz), .slowClk(clk100Hz), .rstn(rstn));

    rowFSM rowFSM (.clk(clk48kHz), .rstn(rstn), .en(clk100Hz), .stall(stall), .row(row));

    always_ff @(posedge clk48kHz, negedge rstn) begin
        if (~rstn) begin
            colDly  <= 4'b0; 
            colSync <= 4'b0; 
        end else begin
            colDly  <= col;
            colSync <= colDly;
        end
    end

    ctrlFSM ctrlFSM (.clk(clk48kHz), .rstn(rstn), .en(1'b1), .dbhigh(dbhigh), .dblow(dblow), .dbreq(dbreq), .stall(stall), .strobe(strobe), .activeCol(activeCol));

    debouncer debouncer (.clk(clk48kHz), .rstn(rstn), .req(dbreq), .en(1'b1), .activeCol(activeCol), .col(colSync), .high(dbhigh), .low(dblow));

    keypad_encoder keypad_encoder (.row(row), .col(activeCol), .s(s0next));

    always_ff @(posedge clk48kHz)
        if (~rstn) begin
            s0 <= 4'hf;
            s1 <= 4'hf;
        end else if (strobe) begin
            s0 <= s0next;
            s1 <= s0;
        end else begin
            s0 <= s0;
            s1 <= s1;
        end

    seven_seg_tmux tmux (.sel(clk100kHz), .s1(s1), .s0(s0), .pwr1(pwr1), .pwr0(pwr0), .seg(seg));
        // seven_seg_tmux tmux (.clk(clk48kHz), .rstn(rstn), .s1(s1), .s0(s0), .pwr1(pwr1), .pwr0(pwr0), .seg(seg));

endmodule