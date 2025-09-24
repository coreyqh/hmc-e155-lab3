// rowFSM_sva.sv
// written: Corey Hickson chickson@hmc.edu 9/14/2025
// Purpose: formal design properties for the row driver FSM

always @* assume (~rstn == $initstate);

always @(posedge clk) begin
    if (rstn && $past(rstn)) begin
        assert (row != $past(row));
        assert ($onehot(~row));

        assert (eventually(row == 4'b0111));
        assert (eventually(row == 4'b1011));
        assert (eventually(row == 4'b1101));
        assert (eventually(row == 4'b1110));
    end
end
