always @* assume (~rstn == $initstate);

always @* assume (eventually(dbhigh || dblow));

always_ff @(posedge clk) begin
    if (rstn && $past(rstn)) begin
        assert (state != ERROR);
        assert (nextstate != ERROR);
        assert($onehot(~activeCol) || activeCol == 4'b1111);
        if ($past(state) == UPDATE)
            assert (state != UPDATE);
        if (state == DEBOUNCE)
            assert (eventually(state != DEBOUNCE));
        if (state == WAIT)
            assert (eventually(state != WAIT));
        if (state == UPDATE)
            assert (update);
        else
            assert (!update);
        if (state == DEBOUNCE || state == WAIT)
            assert (dbreq);
        else
            assert (!dbreq);
        if (state == DEBOUNCE && $past(state == IDLE))
            assert ($past(col) != 4'b1111);
        if (state == IDLE && $past(state == DEBOUNCE))
            assert ($past(dbhigh));
        if (state == UPDATE && $past(state == DEBOUNCE))
            assert ($past(dblow));
    end
end
