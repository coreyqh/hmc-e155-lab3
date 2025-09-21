module rowFSM (
    input  logic       clk, rstn,
    output logic [3:0] row
);

    always_ff @(posedge clk) begin
        if (~rstn) 
            row <= 4'b0111;
        else
            row <= {row[0], row[3:1]};
    end

    `ifdef FORMAL
        `include "rowFSM_sva.sv"
    `endif

endmodule
