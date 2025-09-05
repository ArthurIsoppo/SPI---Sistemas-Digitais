module alu (
    input logic clock,
    input logic reset,
    IF_SPI.SLAVE spi
);

typedef enum logic [4:0] { 
    IDLE     = 5'b00001,
    RECEIVE  = 5'b00010,
    THINK    = 5'b00100,
    WAIT     = 5'b01000,
    SAND     = 5'b10000
 } alu_state_t;

alu_state_t state, next_state; 

logic [1:0] opcode;
logic [31:0] opa;
logic [31:0] opb;
logic [31:0] res;

logic [65:0] buffer;
logic [6:0] counter;

always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        next_state <= IDLE;
        counter <= 0;
        spi.miso <= 1'b0;
        buffer <= 0;
    end else begin
        unique case (state)
            IDLE: begin
                counter <= 0;

                if(~spi.nss) begin
                    next_state <= RECEIVE;
                end else begin
                    next_state <= IDLE;
                end
            end

            RECEIVE: begin
                buffer[65 - counter] <= spi.mosi;
                counter <= counter + 1;

                if (counter == 65) begin
                    next_state <= THINK;
                end else begin
                    next_state <= RECEIVE;
                end
            end

            THINK: begin
                opcode <= buffer[65:64];
                opa    <= buffer[63:32];
                opb    <= buffer[31:0];

                case (opcode)
                    2'b00: res <= opa + opb; // ADD
                    2'b01: res <= opa - opb; // SUB
                    2'b10: res <= opa & opb; // AND
                    2'b11: res <= opa | opb; // OR
                    default: res <= 32'b0;
                    endcase

                counter <= 0;
                next_state <= WAIT;
            end

            WAIT: begin
                if (~spi.nss) begin
                    next_state <= SAND;
                end else begin
                    next_state <= WAIT;
                end
            end

            SAND: begin
                spi.miso <= res[31 - counter];
                counter <= counter + 1;

                if (counter == 31) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= SAND;
                end
            end
        endcase
    end
end

endmodule