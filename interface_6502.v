module interface_6502 (
		input clk_int50,	// Internal 50MHz clock (phi2)
		input clk_ext1,	// External 1 MHz clock

		input cs,			// Chip Select (Active Low)
		input [3:0] rs,	// Register select
		input wren,			// Write enable (Active low)
		inout [7:0] data_bi,	// Data bus
		
		output reg [7:0] led // led output
	);

	reg [7:0] data_out;	// Data output register. Don't need input register, can read from bus
	
	assign data_bi = wr ? data_out : 8'bZ;	// If WR is low, output to DB. Otherwise, high Z for input
	
	reg [7:0] int_reg [15:0]; // 16 8 bit registers
	
	reg [3:0] curr_addr;		// Current address
	reg wr;
	
	reg newdata = 1'b1;
	
	/*  At a positive clock edge while selected,
	    Get the current address and wr bit       */
	always @ (posedge clk_ext1 & ~(cs)) begin
		wr <= wren;	
		curr_addr <= rs;
	end
	
	always @ (negedge clk_ext1 & ~(cs)) begin
		if (~wr) begin
			newdata <= 1'b0;				
			int_reg[curr_addr] = data_bi;	// Load data into selected register
			newdata <= 1'b1;				// Then signal that new data has arrived
		end
		
		if (wr) begin
			data_out = int_reg[curr_addr];
		end
	end
	
	
	always @ (posedge newdata) begin
		led <= int_reg[4'b0];
	end
	
	
endmodule