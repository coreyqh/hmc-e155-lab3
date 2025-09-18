always @* assume (~rstn == $initstate);
always @(posedge clk) if ($past(count) == THRESHOLD) assume (!req);
always @(posedge clk) if (req == 1'b1) assume (!$changed(activeCol));
always @* assume ($onehot(~activeCol) || activeCol == 4'b1111);

always @(posedge clk) begin
    if (rstn) begin
        assert (state != ERROR);
        if (state != $past(state))
            assert (count == 0);
        if ($past(count, 2) == THRESHOLD && $past(state == HIGH, 3))
            assert (!high);
        if ($past(count, 2) == THRESHOLD && $past(state == LOW,  3))
            assert (!low);
        
    end
end
