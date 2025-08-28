module tb_spi #()();

logic clock = 0;
logic reset = 1;
logic bits_in;
logic bits_out;

ISPI if_spi();

spi_master master(
    .clock(clock), .reset(reset),
    .spi(if_spi.MASTER_SPI),
    .bits_in(bits_in),
    .bits_out(bits_out)
);

spi_slave slave(
    .clock(clock), .reset(reset),
    .spi(if_spi.SLAVE_SPI)
);

always #1 clock = ~clock;

initial begin
    logic i = 0;
    #2 reset = 0;
    while (1) begin
        bits_in <= i;
        #2 i = ~i;
    end 
end 

endmodule