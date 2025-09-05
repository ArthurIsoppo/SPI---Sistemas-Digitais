module Processor #(parameter REG_SIZE=10)(
    input logic clock, 
    input logic reset,
    input logic[31:0] instr,
    output logic[2**REG_SIZE] regbank[32],
    output logic ready,
    IF_SPI.MASTER spi
);

initial begin
    $srandom(3101); 
    
    for (int i = 0; i < 2**REG_SIZE; i++) begin
        regbank[i] = $random;
    end
end

logic[1:0] opcode;
logic[REG_SIZE-1:0] opa;
logic[REG_SIZE-1:0] opb;
logic[REG_SIZE-1:0] res;

assign opcode = instr[31:30];
assign opa = instr[29:20];
assign opb = instr[19:10];
assign res = instr[9:0];

typedef enum logic [4:0] { 
    FETCH    = 5'b00001,
    EXECUTE  = 5'b00010,
    SEND     = 5'b00100,
    WAIT     = 5'b01000,
    SAVE     = 5'b10000
 } proc_state_t;

proc_state_t state, next_state;

logic [65:0] data;
logic [31:0] alu_result;
logic [REG_SIZE-1:0] addr;
logic [6:0] counter;

// Bloco 1
always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        state <= FETCH;
    end else begin
        state <= next_state;
     if (state !== next_state) begin
           $display("State transition: %s -> %s @ time %t", state.name(), next_state.name(), $time);
        end
    end 
end

// Bloco 2
always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        next_state <= FETCH;
        spi.nss <= 1'b1;
        spi.mosi <= 1'b0;
        counter <= 0;
    end else begin
        unique case (state)
            FETCH: begin
                state <= next_state;
                next_state <= EXECUTE;
            end

            EXECUTE: begin
                state <= next_state;
                data <= {opcode, regbank[opa], regbank[opb]};
                addr <= res;
                counter <= 0;
                spi.nss <= 1'b0;

                next_state <= SEND;
            end

            SEND: begin
                state <= next_state;
                spi.mosi <= data[65 - counter];
                counter <= counter + 1;

                if (counter == 65) begin
                    spi.nss <= 1'b1;
                    counter <= 0;
                    next_state <= WAIT;
                end else begin
                    next_state <= SEND;
                end
            end

            WAIT: begin
                state <= next_state;
                if (counter == 0) begin
                        spi.nss <= 1'b0;
                end

                alu_result[31 - counter] <= spi.miso;
                counter <= counter + 1;

                if (counter == 31) begin
                    spi.nss <= 1'b1;
                    counter <= 0;
                    next_state <= SAVE;
                end else begin
                    next_state <= WAIT;
                end
            end

            SAVE: begin
                state <= next_state;
                regbank[addr] <= alu_result;
                next_state <= FETCH;
            end
        endcase
    end
end

endmodule