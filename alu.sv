module alu (
    input logic clock,
    input logic reset,
    IF_SPI.SLAVE spi,

    output logic miso
);

always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        
    end