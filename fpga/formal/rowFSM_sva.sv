always @* assume (~rstn == $initstate);
always @* assume (eventually(en && !stall));

always @(posedge clk) begin
    if (rstn) begin
        if (!$past(en) || $past(stall)) 
            assert (row == $past(row));
        else if ($past(rstn))
            assert (row == {$past(row[0]), $past(row[3:1])});

        assert ((row == 4'b0111) || (row == 4'b1011) || (row == 4'b1101) || (row == 4'b1110));

        assert (eventually(row == 4'b0111));
        assert (eventually(row == 4'b1011));
        assert (eventually(row == 4'b1101));
        assert (eventually(row == 4'b1110));
    end
end
