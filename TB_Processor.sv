`timescale 1ns/1ps
module TB_Processor #(parameter REG_SIZE=10)();

logic clock = 0;
logic reset = 0;

always #1 clock = ~clock;

logic[31:0] instr;
logic[2**REG_SIZE] regbank[32];
logic ready;

IF_SPI spi(.*);

alu alu(clock, reset, spi);

Processor #(REG_SIZE) meu_proc (
    .clock(clock),
    .reset(reset),
    .instr(instr),
    .regbank(regbank),
    .ready(ready),
    .spi(spi)
);

logic[1:0] opcode;
logic[9:0] regA;
logic[9:0] regB;
logic[9:0] res;

assign {opcode, regA, regB, res} = instr;

enum logic[1:0]{
    ADD = 2'b00,
    SUB = 2'b01,
    AND = 2'b10,
    OR = 2'b11
} opcode_e;
/**
  0000 0000 00 - opa
  0000 0000 00 - opb
  0000 0000 00 - rd
*/
logic[24][31:0] instr_v = {
    {ADD, 10'd1023, 10'd1023, 10'd1023},
    {SUB, 10'd1023, 10'd1023, 10'd1023},
    {OR,  10'd1023, 10'd1023, 10'd1023},
    {ADD, 10'd1023, 10'd1023, 10'd1023},
    {ADD, 10'd1023, 10'd1023, 10'd1023},
    {AND, 10'd1023, 10'd1023, 10'd1023},
    {SUB, 10'd1023, 10'd1023, 10'd1023}
};

int res_sv;

initial begin
    for (int i = 0; i < $size(instr_v); i++) begin
        instr = instr_v[i];

        while(~ready); #2 $display("");

        unique case (instr[1:0])
            ADD : res_sv = regbank[regA] + regbank[regB];
            SUB : res_sv = regbank[regA] - regbank[regB];
            AND : res_sv = regbank[regA] & regbank[regB];
            OR  : res_sv = regbank[regA] | regbank[regB];
        endcase

        #150 assert property(@(posedge clock)
            (regbank[res] == res_sv)
        );
    end    
end


endmodule