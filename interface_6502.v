module interface_6502 (
		input clk,	// Internal 50MHz clock (phi2)
		input clk_ext1,	// External 1 MHz clock

		input cs,			// Chip Select (Active Low)
		input [3:0] rs,	// Register select
		input wren,			// Write enable (Active low)
		input [7:0] data_in,	// Data bus
		
		output reg [7:0] led // led output
	);
	
	wire chipclk;
	
	assign chipclk = clk_ext1 & ~cs;
	
	reg [7:0] int_reg [15:0]; // 16 8 bit registers
	
	reg [3:0] curr_addr;		// Current address
	reg wr;
	
	reg newdata = 1'b1;
	
	always @ (posedge chipclk) begin
			curr_addr = rs;
	end
	
	always @ (negedge chipclk) begin
			int_reg[curr_addr] = data_in;
			led <= int_reg[curr_addr];
	end
	
	/*
	always @ (posedge cs) begin
		if (~wr) begin
			newdata <= 1'b0;				
			int_reg[curr_addr] = data_in;	// Load data into selected register
			newdata <= 1'b1;				// Then signal that new data has arrived
		end
	end
	
	
	always @ (posedge newdata) begin
		led <= int_reg[4'b0];
	end
	
	*/
	
	
endmodule