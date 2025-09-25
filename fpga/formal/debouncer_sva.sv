// debouncer_sva.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: formal design properties for the debouncer

always @* assume (~rstn == $initstate);
always @(posedge clk) if ($past(high) || $past(low)) assume (!req);
always @(posedge clk) if ($past(req)) assume (!$changed(activeCol));
always @(posedge clk) if ($past(req)) assume (!$changed(activeRow));
always @* assume ($onehot(activeCol) || activeCol == 4'b0000);
always @* if (req) assume ($onehot(activeCol));
always @* assume ($onehot(activeRow));
always @* assume ($onehot(row));
always @(posedge clk) assume (row == {$past(row[0]), $past(row[3:1])});

always @(posedge clk) begin
    if (rstn && $past(rstn)) begin
        assert (state != ERROR);
        assert(~(low && high));
        if (!req && !$past(req)) assert (~(low || high));
        if (state != $past(state))
            assert (count == 0);
        if (count == THRESHOLD && state == LOW)
            assert (low);
        if (count == THRESHOLD && state == HIGH)
            assert (high);
        if (req && ((col & activeCol) != 0) &&  row == activeRow)
            assert (nextstate == HIGH);
        if (req && ((col & activeCol) == 0) &&  row == activeRow)
            assert (nextstate == LOW);
    end
end
