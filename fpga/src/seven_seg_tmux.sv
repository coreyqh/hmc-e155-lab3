module seven_seg_tmux (
    input  logic       sel,
    input  logic [3:0] s1, s0,
    output logic       pwr1, pwr0,
    output logic [6:0] seg
);

    logic [3:0] sMuxed;

    assign sMuxed = sel ? s1 : s0;

    seven_seg_dec (.s(sMuxed), .seg(seg));

    assign pwr0 = ~sel;
    assign pwr1 =  sel;

endmodule


// module seven_seg_tmux #(parameter P = 84, parameter CNT_WIDTH = 24) (
//     input  logic       clk, rstn,
//     input  logic [3:0] s1, s0,
//     output logic       pwr1, pwr0,
//     output logic [6:0] seg
// );

//     logic [3:0] sMuxed;
//     logic       sel;

//     always_ff @(posedge clk, negedge rstn) begin
//         if (~rstn) count = {CNT_WIDTH{1'b0}};
//         else begin
//             count = count + P[CNT_WIDTH-1:0];
//         end
//     end

//     assign sel = count[CNT_WIDTH-1];

//     assign sMuxed = sel ? s1 : s0;

//     seven_seg_dec (.s(sMuxed), .seg(seg));

//     assign pwr0 = ~sel;
//     assign pwr1 =  sel;

// endmodule