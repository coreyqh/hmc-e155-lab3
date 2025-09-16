always @* assume (~rstn == $initstate);

always @* assume (eventually(dbhigh || dblow));

always_ff @(posedge clk) begin
    if (rstn && $past(en) && $past(rstn)) begin
        assert (state != ERROR);
        assert (nextstate != ERROR);
        assert($onehot(activeCol) || activeCol == 4'b0);
        if ($past(state) == STROBE)
            assert (state != STROBE);
        if (state == DEBOUNCE)
            assert (eventually(state != DEBOUNCE));
        if (state == WAIT)
            assert (eventually(state != WAIT));
        if (state == STROBE)
            assert (strobe);
        else
            assert (!strobe);
        if (state == IDLE)
            assert (!stall);
        else
            assert (stall);
        if (state == DEBOUNCE || state == WAIT)
            assert (dbreq);
        else
            assert (!dbreq);
        if (state == DEBOUNCE && $past(state == IDLE))
            assert ($past(col) != 4'b0);
        if (state == IDLE && $past(state == DEBOUNCE))
            assert ($past(dbhigh));
        if (state == STROBE && $past(state == DEBOUNCE))
            assert ($past(dblow));
    end
end
