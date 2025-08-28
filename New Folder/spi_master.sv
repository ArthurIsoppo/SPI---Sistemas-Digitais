module spi_master (
    input logic bits_in,
    input logic clock,
    input logic reset,
    ISPI.MASTER_SPI spi,
    output logic bits_out
);

assign spi.sclk = clock;
assign nss = 0;
assign spi.mosi = bits_in;

always @(posedge clock, negedge reset) begin
    if (reset) begin
        bits_out <= 0;
    end else begin
        bits_out <= spi.miso;
    end 
end
	
endmodule