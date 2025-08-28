module spi_slave (
    input logic clock,
    input logic reset,
    ISPI.SLAVE_SPI spi
);

always @(posedge spi.sclk) begin
    spi.miso <= spi.mosi;
end
    
endmodule