// keypad_encoder_sva.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: formal design properties for the keypad encoder

rand const reg [7:0] rand_input;
rand const reg [3:0] rand_output;


always @(posedge clk) begin
    assume ({row, col} == rand_input && s == rand_output);
    if ({row, col} == rand_input) assert (s == rand_output);
    if ({row, col} != rand_input) assert (s != rand_output);
    if (s == rand_output)         assert ({row, col} == rand_input);
    if (s != rand_output)         assert ({row, col} != rand_input);
    
end
