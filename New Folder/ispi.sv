interface ISPI();
	logic sclk;
	logic miso;
	logic mosi;
	logic nss;

	modport MASTER_SPI (
		input miso,
		output sclk, mosi, nss
	);

	modport SLAVE_SPI (
		input sclk, mosi, nss,
		output miso
	);

	always @(posedge sclk) begin
		$display(sclk, mosi, miso, nss);
	end
endinterface