module ctrlFSM (
    input  logic       clk, rstn, en,
    input  logic       dbhigh, dblow, // signals value high/low transition from debouncer
    input  logic [3:0] col,
    output logic       dbreq,         // send request to debouncer
    output logic       stall,         // stall rowFSM to maintain powered row
    output logic       strobe,        // enable fifo flops to push input value to 7-segment
    output logic [3:0] activeCol
);

    typedef enum logic [2:0] {IDLE, DEBOUNCE, STROBE, WAIT, ERROR} state_t;
    state_t state, nextstate;
    logic [3:0] activeCol, nextActiveCol;

    // state register
    always_ff @(posedge clk) begin
        if (~rstn) begin
            state     <= IDLE;
            activeCol <= nextActiveCol;
        end else if (en) begin
            state     <= nextstate;
            activeCol <= nextActiveCol;
        end else begin
            state     <= state;
            activeCol <= activeCol;
        end
    end

    // next state logic
    always_comb begin
        case (state) 
            IDLE:     begin
                if (col != 4'b0) begin
                    nextstate     = DEBOUNCE;
                    casex (col)
                        4'b1xxx: nextActiveCol <= 4'b1000;
                        4'b01xx: nextActiveCol <= 4'b0100;
                        4'b001x: nextActiveCol <= 4'b0010;
                        4'b0001: nextActiveCol <= 4'b0001;
                        default: nextActiveCol <= 4'bxxxx; // shouldn't happen
                    endcase
                end else begin
                    nextstate     = IDLE;
                    nextActiveCol = 4'b0;
                end
            end
            DEBOUNCE: begin
                nextActiveCol = activeCol;
                if (dblow)
                    nextstate = STROBE;
                else if (dbhigh)
                    nextstate = IDLE;
                else
                    nextstate = DEBOUNCE;
            end
            STROBE:   begin
                nextstate     = WAIT;
                nextActiveCol = 4'b0;
            end
            WAIT:     begin
                nextActiveCol = 4'b0;
                if (dbhigh)
                    nextstate = IDLE;
                else
                    nextstate = WAIT;
            end
            ERROR:    begin
                nextstate     = IDLE;
                nextActiveCol = 4'bx; 
            end
            default:  begin // should never happen
                nextstate     = ERROR;
                nextActiveCol = 4'bx;
            end
        endcase
    end

    // output logic
    assign strobe = (state == STROBE);
    assign stall  = (state != IDLE);
    assign dbreq  = (state == DEBOUNCE) || (state == WAIT);

    `ifdef FORMAL
        `include "ctrlFSM_sva.sv"
    `endif

endmodule