module lab3_top (
    input  logic       rstn,
    input  logic [3:0] col,
    output logic [3:0] row,
    output logic [6:0] seg,
    output logic       pwr1, pwr0
);
    logic       clk6MHz;
    logic [3:0] colDly, colSync, activeCol;
    logic [3:0] rowDly, rowSync;
    logic       stall,  strobe;
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

    rowFSM rowFSM (.clk(clk6MHz), .rstn(rstn), .en(clk6MHz), .stall(stall), .row(row));

    always_ff @(posedge clk6MHz) begin
        if (~rstn) begin
            colDly  <= 4'b0;
            rowDly  <= 4'b0; 
            colSync <= 4'b0;
            rowSync <= 4'b0;
        end else begin
            colDly  <= col;
            rowDly  <= row;
            colSync <= colDly;
            rowSync <= rowDly;
        end
    end

    ctrlFSM ctrlFSM (.clk(clk6MHz), .rstn(rstn), .en(1'b1), .col(colSync), .dbhigh(dbhigh), .dblow(dblow), .dbreq(dbreq), .stall(stall), .strobe(strobe), .activeCol(activeCol));

    debouncer debouncer (.clk(clk6MHz), .rstn(rstn), .req(dbreq), .en(1'b1), .activeCol(activeCol), .col(colSync), .high(dbhigh), .low(dblow));

    keypad_encoder keypad_encoder (.row(rowSync), .col(activeCol), .s(s0next));

    always_ff @(posedge clk6MHz)
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

    seven_seg_tmux #(.P(280), .N(24)) tmux (.clk(clk6MHz), .rstn(rstn), .s1(s1), .s0(s0), .pwr1(pwr1), .pwr0(pwr0), .seg(seg));

endmodule


// TODO: recalculate clk division && debounce counter threshold