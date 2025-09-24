// debouncer.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: to debounce button pushes and releases for one ket at a time, at the request of the main controller

module debouncer #(parameter THRESHOLD = 6000) (
    input  logic       clk, rstn,
    input  logic       req,                  // request to debouce one bit
    input  logic [3:0] activeCol, activeRow, // which bit to debounce (onecold)
    input  logic [3:0] col, row,
    output logic       high,                 // valid high transition occurred
    output logic       low                   // valid low  transition occurred
);

    enum logic [1:0] {LOW, HIGH, ERROR} state, nextstate;
    logic [$clog2(THRESHOLD)-1:0] count, nextcount;

    always_ff @(posedge clk) begin
        if (~rstn || ~req) begin
            state <= LOW;
            count <= {$clog2(THRESHOLD){1'b0}};
        end else begin
            state <= nextstate;
            count <= nextcount;
        end
    end

    always_comb begin
        case (state)
            LOW:  begin
                if (row != activeRow) begin
                    nextstate = LOW;
                    nextcount = count;
                end else if ((activeCol & col) == 4'b0) begin
                    nextstate = LOW;
                    nextcount = count + 1;
                end else begin
                    nextstate = HIGH;
                    nextcount = {$clog2(THRESHOLD){1'b0}};
                end
            end
            HIGH: begin
                if (row != activeRow) begin
                    nextstate = HIGH;
                    nextcount = count;
                end else if ((activeCol & col) != 4'b0) begin
                    nextstate = HIGH;
                    nextcount = count + 1;
                end else begin
                    nextstate = LOW;
                    nextcount = {$clog2(THRESHOLD){1'b0}};
                end
            end
            default: begin // should never happen
                nextstate = ERROR;
                nextcount = {$clog2(THRESHOLD){1'bx}};
            end
        endcase
    end

    assign high = (state == HIGH) && (count == THRESHOLD);
    assign low  = (state == LOW ) && (count == THRESHOLD);

    `ifdef FORMAL 
        `include "debouncer_sva.sv"
    `endif

endmodule
