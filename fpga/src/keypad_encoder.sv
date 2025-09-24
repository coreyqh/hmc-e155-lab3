// keypad_encoder.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: To encode the row and column of a pushed button into the hex value displayed on that button

module keypad_encoder (
    input  logic [3:0] row, col,
    output logic [3:0] s
);
    always_comb
        case({row, col}) // convert from onecold to onehot for readability
            {4'b0001, 4'b0001}: s = 4'h1;
            {4'b0001, 4'b0010}: s = 4'h2;
            {4'b0001, 4'b0100}: s = 4'h3;
            {4'b0001, 4'b1000}: s = 4'hA;
            {4'b0010, 4'b0001}: s = 4'h4;
            {4'b0010, 4'b0010}: s = 4'h5;
            {4'b0010, 4'b0100}: s = 4'h6;
            {4'b0010, 4'b1000}: s = 4'hB;
            {4'b0100, 4'b0001}: s = 4'h7;
            {4'b0100, 4'b0010}: s = 4'h8;
            {4'b0100, 4'b0100}: s = 4'h9;
            {4'b0100, 4'b1000}: s = 4'hC;
            {4'b1000, 4'b0001}: s = 4'hE;
            {4'b1000, 4'b0010}: s = 4'h0;
            {4'b1000, 4'b0100}: s = 4'hF;
            {4'b1000, 4'b1000}: s = 4'hD;
            default:            s = 4'hx;
        endcase

        /*
      always_comb
        case({~row, ~col}) // convert from onecold to onehot for readability
            {4'b0001, 4'b0001}: s = 4'hA;
            {4'b0001, 4'b0010}: s = 4'h0;
            {4'b0001, 4'b0100}: s = 4'hB;
            {4'b0001, 4'b1000}: s = 4'hF;
            {4'b0010, 4'b0001}: s = 4'h7;
            {4'b0010, 4'b0010}: s = 4'h8;
            {4'b0010, 4'b0100}: s = 4'h9;
            {4'b0010, 4'b1000}: s = 4'hE;
            {4'b0100, 4'b0001}: s = 4'h4;
            {4'b0100, 4'b0010}: s = 4'h5;
            {4'b0100, 4'b0100}: s = 4'h6;
            {4'b0100, 4'b1000}: s = 4'hD;
            {4'b1000, 4'b0001}: s = 4'h1;
            {4'b1000, 4'b0010}: s = 4'h2;
            {4'b1000, 4'b0100}: s = 4'h3;
            {4'b1000, 4'b1000}: s = 4'hD;
            default:            s = 4'hx;
        endcase
        */

        `ifdef FORMAL
            `include "keypad_encoder_sva.sv"
        `endif

endmodule
