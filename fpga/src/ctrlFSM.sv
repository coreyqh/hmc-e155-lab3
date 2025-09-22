module ctrlFSM (
    input  logic       clk, rstn,
    input  logic       dbhigh, dblow, // signals value high/low transition from debouncer
    input  logic [3:0] col, row,
    output logic       dbreq,         // send request to debouncer
    output logic       update,        // enable fifo flops to push input value to 7-segment
    output logic [3:0] activeCol, activeRow,
    output logic [2:0] debugState     // for debugging
);

    typedef enum logic [2:0] {IDLE, DEBOUNCE, UPDATE, WAIT, ERROR} state_t;
    state_t state, nextstate;
    logic [3:0] nextActiveCol, nextActiveRow;

    // state register
    always_ff @(posedge clk) begin
        if (~rstn) begin
            state     <= IDLE;
            activeCol <= nextActiveCol;
            activeRow <= nextActiveRow;
        end else begin
            state     <= nextstate;
            activeCol <= nextActiveCol;
            activeRow <= nextActiveRow;
        end
    end

    // next state logic
    always_comb begin
        case (state) 
            IDLE:     begin
                if (col != 4'b1111) begin
                    nextstate     = DEBOUNCE;
                    nextActiveRow = row;
                    casez (col)
                        4'b0???: nextActiveCol = 4'b0111;
                        4'b10??: nextActiveCol = 4'b1011;
                        4'b110?: nextActiveCol = 4'b1101;
                        4'b1110: nextActiveCol = 4'b1110;
                        default: nextActiveCol = 4'bxxxx; // shouldn't happen
                    endcase
                end else begin
                    nextstate     = IDLE;
                    nextActiveCol = 4'b1111;
                    nextActiveRow = 4'b1111;
                end
            end
            DEBOUNCE: begin
                nextActiveCol = activeCol;
                nextActiveRow = activeRow;
                if (dblow)
                    nextstate = UPDATE;
                else if (dbhigh)
                    nextstate = IDLE;
                else
                    nextstate = DEBOUNCE;
            end
            UPDATE:   begin
                nextstate     = WAIT;
                nextActiveCol = activeCol;
                nextActiveRow = activeRow;
            end
            WAIT:     begin
                nextActiveCol = activeCol;
                nextActiveRow = activeRow;
                if (dbhigh)
                    nextstate = IDLE;
                else
                    nextstate = WAIT;
            end
            ERROR:    begin
                nextstate     = IDLE;
                nextActiveCol = 4'bx; 
                nextActiveRow = 4'bx; 
            end
            default:  begin // should never happen
                nextstate     = ERROR;
                nextActiveCol = 4'bx;
                nextActiveRow = 4'bx;
            end
        endcase
    end

    // output logic
    assign update = (state == UPDATE);
    assign dbreq  = (state == DEBOUNCE) || (state == WAIT);

    always_comb
        case (state)
            IDLE: debugState = 3'b000;
            DEBOUNCE: debugState = 3'b001;
            UPDATE: debugState = 3'b010;
            WAIT: debugState = 3'b011;
        endcase

    `ifdef FORMAL
        `include "ctrlFSM_sva.sv"
    `endif

endmodule
