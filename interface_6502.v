module interface_6502 (
		input clk_int50,	// Internal 50MHz clock (phi2)
		input clk_ext1,	// External 1 MHz clock

		input cs,			// Chip Select (Active Low)
		input [3:0] rs,	// Register select
		input wren,			// Write enable (Active low)
		inout [7:0] data,	// Data bus
		
		output reg [7:0] led // led output
	);
	
	reg [7:0] curr_data;
	reg [3:0] curr_addr;
	reg rw;
	
	reg newdata = 1'b1;
	
	/*  At a positive clock edge while selected,
	    Get the current address and wr bit       */
	always @ (posedge clk_ext1 & ~(cs)) begin
		rw <= wren;	
		curr_addr <= rs;
	end
	
	always @ (posedge cs) begin
		curr_data <= data;
	end
	
	
endmodule