module lab3_top (
    input  logic       rstn,
    input  logic [3:0] col_i,
    output logic [3:0] row_o,
    output logic [6:0] seg_o,
    output logic       pwr1_o, pwr0_o,
    output logic [2:0] debugState // for hardware debug
);
    logic       clk6MHz;
    logic [3:0] colDly1, colSync, activeCol;
    logic [3:0] preRow1, preRow0, rowSync, activeRow;
    logic       update;
    logic [3:0] s1, s0, s0next;
    logic       dbhigh, dblow, dbreq;

    `ifdef VERILATOR 
        initial begin
            clk6MHz = 1'b0;
            forever #166.66ns clk6MHz = ~clk6MHz;
        end
    `else
        HSOSC #(.CLKHF_DIV(2'b11)) osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk6MHz));
    `endif

    // clkDiv #(.D(480)) clkDiv100 (.fastClk(clk6MHz), .slowClk(clk100Hz), .rstn(rstn));

    always_ff @(posedge clk6MHz) begin
        if (~rstn) begin
            colDly1   <= 4'b0000; // convert to active high
            colSync   <= 4'b0000; // convert to active high
            preRow0   <= 4'b0;
            rowSync   <= 4'b0;
        end else begin
            colDly1   <= col_i;
            colSync   <= colDly1;
            preRow0   <= ~preRow1; // convert to active high
            rowSync   <= preRow0;
        end
    end

    rowFSM rowFSM (.clk(clk6MHz), .rstn(rstn), .row(preRow1));

    ctrlFSM ctrlFSM (.clk(clk6MHz), .rstn(rstn), .col(~colSync), .row(rowSync), .dbhigh(dbhigh), .dblow(dblow), .dbreq(dbreq), .update(update), .activeCol(activeCol), .activeRow(activeRow), .debugState(debugState)); // convert to active high

    debouncer #(.THRESHOLD(600)) debouncer (.clk(clk6MHz), .rstn(rstn), .req(dbreq), .activeCol(activeCol), .activeRow(activeRow), .col(~colSync), .row(rowSync), .high(dbhigh), .low(dblow)); // convert to active high

    keypad_encoder keypad_encoder (.row(activeRow), .col(activeCol), .s(s0next));

    always_ff @(posedge clk6MHz)
        if (~rstn) begin
            s0 <= 4'hf;
            s1 <= 4'hf;
        end else if (update) begin
            s0 <= s0next;
            s1 <= s0;
        end else begin
            s0 <= s0;
            s1 <= s1;
        end

    seven_seg_tmux #(.P(280), .N(24)) tmux (.clk(clk6MHz), .rstn(rstn), .s1(s1), .s0(s0), .pwr1(pwr1_o), .pwr0(pwr0_o), .seg(seg_o));

    assign row_o = ~preRow1; // convert to active high

endmodule
