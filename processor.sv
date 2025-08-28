module Processor #(parameter REG_SIZE=10)(
    input logic clock, 
    input logic reset,
    input logic[31:0] instr,
    IF_SPI.MASTER spi
);

logic[1:0] opcode;
logic[REG_SIZE-1:0] opa;
logic[REG_SIZE-1:0] opb;
logic[REG_SIZE-1:0] res;

logic[2**REG_SIZE] regbank;

assign opcode = instr[31:30];
assign opa = instr[29:20];
assign opb = instr[19:10];
assign res = instr[9:0];

always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        // ??
    end else begin
        $display(miso, mosi, sclk, nss);
    end 
end

endmodule