interface IF_SPI(
    input logic clock,
    input logic reset
);

logic sclk;
logic miso;
logic mosi;
logic nss;

modport MASTER (
    input miso,
    
    output sclk,
    output mosi,
    output nss
);

modport SLAVE (
    input sclk,
    input mosi,
    input nss,

    output miso
);

always_ff @(posedge clock, negedge reset) begin
    if (~reset) begin
        sclk <= 1'b0;
        mosi <= 1'b0;
        nss <= 1'b1;
    end else begin
        $display(miso, mosi, sclk, nss);
    end 
end

endinterface