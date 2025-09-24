// rowFSM.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: a shift register to drive one row of the keypad matrix at a time

module rowFSM (
    input  logic       clk, rstn,
    output logic [3:0] row
);

    always_ff @(posedge clk) begin
        if (~rstn) 
            row <= 4'b1000;
        else
            row <= {row[0], row[3:1]};
    end

    `ifdef FORMAL
        `include "rowFSM_sva.sv"
    `endif

endmodule
