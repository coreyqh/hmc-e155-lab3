always @* assume (~rstn == $initstate);
always @(posedge clk) if ($past(high) || $past(low)) assume (!req);
always @(posedge clk) if ($past(req)) assume (!$changed(activeCol));
always @(posedge clk) if ($past(req)) assume (!$changed(activeRow));
always @* assume ($onehot(~activeCol) || activeCol == 4'b1111);
always @* if (req) assume ($onehot(~activeCol));
always @* assume ($onehot(activeRow));

always @(posedge clk) begin
    if (rstn) begin
        assert (state != ERROR);
        assert(~(low && high));
        if (!req) assert (~(low || high));
        if ($past(row) != $past(activeRow)) begin
            assert (count == $past(count));
            assert (state == $past(state));
        end
        if (state != $past(state))
            assert (count == 0);
        if (count == THRESHOLD && state == LOW)
            assert (low);
        if (count == THRESHOLD && state == HIGH)
            assert (high);
        if (req && row == activeRow && ((state == high && ((~activeCol & col) != 4'b0)) || (state == low && ((~activeCol & col) == 4'b0))))
            assert nextcount = count + 1;
    end
end
