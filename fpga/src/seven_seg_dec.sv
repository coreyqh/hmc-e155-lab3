// seven_seg_dec.sv
// written: Corey Hickson chickson@hmc.edu 9/2/2025
// Purpose: 7 segment display decoder

module seven_seg_dec #(parameter ACTIVE_LOW = 1'b1) (
    input  logic [3:0] s,
    output logic [6:0] seg
);
    logic [6:0] seg_int;

    always_comb
        case (s)
            4'h0:    seg_int = 7'b0111111;
            4'h1:    seg_int = 7'b0000110;
            4'h2:    seg_int = 7'b1011011;
            4'h3:    seg_int = 7'b1001111;
            4'h4:    seg_int = 7'b1100110;
            4'h5:    seg_int = 7'b1101101;
            4'h6:    seg_int = 7'b1111101;
            4'h7:    seg_int = 7'b0000111;
            4'h8:    seg_int = 7'b1111111;
            4'h9:    seg_int = 7'b1100111;
            4'ha:    seg_int = 7'b1110111;
            4'hb:    seg_int = 7'b1111100;
            4'hc:    seg_int = 7'b0111001;
            4'hd:    seg_int = 7'b1011110;
            4'he:    seg_int = 7'b1111001;
            4'hf:    seg_int = 7'b1110001;
            default: seg_int = 7'bx; // shouldn't happen
        endcase
    
    // if ACTIVE_LOW param is set, zeros turn on the segments, so invert the bits
    if (ACTIVE_LOW) 
        assign seg = ~seg_int;
    else
        assign seg = seg_int; 

endmodule