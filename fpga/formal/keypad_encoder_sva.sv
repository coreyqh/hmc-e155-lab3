
rand const reg [7:0] rand_input;
reg            [3:0] rand_output;
rand reg             check;


always @(posedge clk) begin
    if  (check) assume ({row, col} == rand_input && s == rand_output);
    if ({row, col} == rand_input) assert (s == rand_output);
    if ({row, col} != rand_input) assert (s != rand_output);
    if (s == rand_output)         assert ({row, col} == rand_input);
    if (s != rand_output)         assert ({row, col} != rand_input);
    
end
