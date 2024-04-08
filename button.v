// Written by Nathan Shreve

module button( // control button behaviour
	input clk,
	input iReset,
	
	input iButton,
	input iOffSignal,
	
	output reg oSignal,
	
	output reg[4:0] LEDs
	);
	
	reg[4:0] next_state, current_state;
	
	localparam S_button_1 = 5'd1,
				  S_button_2 = 5'd2,
				  S_button_3 = 5'd3,
				  S_button_4 = 5'd4,
				  S_button_5 = 5'd5;
				  
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_button_1;
		else begin
			case (current_state)
				S_button_1: begin
					if   (iButton) next_state = S_button_2;
					else			   next_state = S_button_1;
				end
				
				S_button_2: begin
					if 	  (iOffSignal & !iButton) next_state = S_button_4;
					else if (iOffSignal) 			  next_state = S_button_5;
					else if (!iButton) 				  next_state = S_button_3;
					else 									  next_state = S_button_2;
				end
				
				S_button_3: begin
					if   (iOffSignal) next_state = S_button_4;
					else				 	next_state = S_button_3;
				end
				
				S_button_4: next_state = S_button_1;
				
				S_button_5: begin
					if   (!iButton) next_state = S_button_1;
					else			    next_state = S_button_5;
				end
				
				default: next_state = S_button_1;
			endcase
		end
	end // state_table
	
	
	// output_signals
	always@(*)
	begin: output_signals
		if 	  (iReset) 																	  oSignal = 0;
		else if (current_state == S_button_2 | current_state == S_button_3) oSignal = 1;
		else																					  oSignal = 0;
	end // output_signals
	
	
	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_button_1;
		else current_state <= next_state;
   end // state_FFs
	
	always@(*) begin
		LEDs = 0;
		case (current_state)
			S_button_1: LEDs[0] = 1;
			S_button_2: LEDs[1] = 1;
			S_button_3: LEDs[2] = 1;
			S_button_4: LEDs[3] = 1;
			S_button_5: LEDs[4] = 1;
		endcase
	end
endmodule