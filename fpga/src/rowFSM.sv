module rowFSM (
    input  logic       clk, rstn, stall, en,
    output logic [3:0] row
);

    always_ff @(posedge clk) begin
        if (~rstn) 
            row <= 4'b0111;
        else if (en && !stall)
            row <= {row[0], row[3:1]};
        else
            row <= row;
    end

    `ifdef FORMAL
        `include "rowFSM_sva.sv"
    `endif

endmodule
