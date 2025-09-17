module clkDiv #(parameter D) (
    input  logic fastClk, rstn,
    output logic slowClk
);
    logic [$clog2(D)-1:0] counter;

    always_ff @(posedge fastClk) begin
        if (~rstn || slowClk) counter <= {$clog2(D){1'b0}};
        else                  counter <= counter + 1'b1;
    end

    assign slowClk = counter == D;
endmodule

