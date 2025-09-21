always @* assume (~rstn == $initstate);

always @(posedge clk) begin
    if (rstn) begin
        assert (row != $past(row));
        assert ($onehot(~row));

        assert (eventually(row == 4'b0111));
        assert (eventually(row == 4'b1011));
        assert (eventually(row == 4'b1101));
        assert (eventually(row == 4'b1110));
    end
end
