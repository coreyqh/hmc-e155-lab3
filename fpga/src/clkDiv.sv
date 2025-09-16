module clkDiv #(parameter P, parameter N) (
    input  logic fastClk, rstn,
    output logic slowClk
);
    logic [N-1:0] counter;

    always_ff @(posedge fastClk) begin
        if (~rstn) counter <= {N{1'b0}};
        else       counter <= counter + P;
    end
endmodule