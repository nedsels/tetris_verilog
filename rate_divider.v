// Written by Nathan Shreve

module rateDivider #(
	parameter CLOCK_FREQUENCY = 600000,
	parameter PULSES_PER_SECOND = 60
	) (
	input clk,
	input iReset,
	input iEn,
	
	output oPulse
	);
	
	
	reg[($clog2(CLOCK_FREQUENCY / PULSES_PER_SECOND) - 1):0] counter;
	
	
	assign oPulse = (counter == 'b0) ? 'b1 : 'b0;
	
	always@(posedge clk) begin
		if (iReset) counter <= 0;
		else if (iEn) begin
			if   (counter >= (CLOCK_FREQUENCY / PULSES_PER_SECOND) - 1) counter <= 0;
			else 																		   counter <= counter + 1;
		end
	end
endmodule