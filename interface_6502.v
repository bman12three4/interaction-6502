module interface_6502 (
		input clk,			// Internal 50MHz clock
		input clk_ext1,	// External 1 MHz clock

		input cs,			// Chip Select (Active Low)
		input [3:0] rs,	// Register select
		input wren,			// Write enable (Active low)
		input [7:0] data_in,	// Data bus
		
		output reg [7:0] led // led output
	);
	
	wire chipclk;
	
	assign chipclk = clk_ext1 & ~cs;
	
	reg [7:0] int_reg [3:0]; // 16 8 bit registers
	
	reg [3:0] curr_addr;		// Current address
	
	wire [7:0] ram_out;
	
	wire ram_wren;
	
	assign ram_wren = (curr_addr == 4'b1) ? 1'b1 : 1'b0;
	
	ram a (
		.address (int_reg[0]),
		.clock (clk),
		.data (int_reg[1]),
		.wren (ram_wren),
		.q (ram_out)
	);

	
	always @ (posedge chipclk) begin
			curr_addr = rs;
	end
	
	always @ (negedge chipclk) begin		// Main code should run here, after data has been recieved
			int_reg[curr_addr] = data_in;
	end
	
endmodule