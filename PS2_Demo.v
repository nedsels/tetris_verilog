//Brian Pham

module PS2_Demo (
	// Inputs
	CLOCK_50,
	KEY,
	reset,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	key_A,
	key_D,
	key_Enter,
	key_Escape,
	key_Space,
	////////
	LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;
input				reset;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;
output reg			key_A;
output reg			key_D;
output reg			key_Enter;
output reg			key_Escape;
output reg			key_Space;
output 		[4:0] LEDR; 

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 assign LEDR[0] = key_A;
 assign LEDR[1] = key_D;
 assign LEDR[2] = key_Enter;
 assign LEDR[3] = key_Space;
 assign LEDR[4] = key_Escape;
 
 /* assign LEDR[5] = last_data_received == 8'h1C;
 assign LEDR[6] = last_data_received == 8'h23;
 assign LEDR[7] = last_data_received == 8'h5A;
 assign LEDR[8] = last_data_received == 8'h76;
 assign LEDR[9] = last_data_received == 8'h29; */
 
 reg [9:0] ignoreBreak;
 initial begin ignoreBreak = 10'd0; end

always @(posedge CLOCK_50)
begin
	if (reset) begin
		last_data_received <= 8'h00;
	end else if (ps2_key_pressed == 1'b1)
		last_data_received <= ps2_key_data;
			

	    /* if (ps2_key_pressed == 1'b1)
    begin
	 key_A <= 0;
	 key_D <= 0;
	 key_Enter <= 0;
	 key_Escape <= 0;
	 key_Space <= 0; */
        case(last_data_received)
            // Check for key 'A'
            8'h1C: begin
                key_D <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
                key_Space <= 0;
					key_A <= 1;
				end
            // Check for key 'D'
            8'h23: begin
				key_A <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
                key_Space <= 0;
				key_D <= 1;
					 end

            // Check for Enter key
            8'h5A: begin
				key_Enter <= 1;
				key_A <= 0;
                key_D <= 0;
                key_Escape <= 0;
                key_Space <= 0;
					 end

            // Check for Escape key
            8'h76: begin
				key_Escape <= 1;
				key_A <= 0;
                key_D <= 0;
                key_Enter <= 0;
                key_Space <= 0;
				end

            // Check for Space key
            8'h29: begin
				key_Space <= 1;
				key_A <= 0;
                key_D <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
				end

			//Check for break
			8'hF0: begin
                key_A <= 0;
                key_D <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
                key_Space <= 0;
//					 ignoreBreak = 10'd1;
			end
			
//			if (ignoreBreak > 10'd10) begin
//				ignoreBreak = 10'd0;
//			end
//			
//			if (ignoreBreak > 10'd0) begin
//				ignoreBreak = ignoreBreak + 10'd1;
//				last_data_received = 8'h00;
//			end

            default: begin	// No recognized key pressed
                key_A <= 0;
                key_D <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
                key_Space <= 0;
			end
        endcase
		  
		  /* if (ps2_key_pressed == 1'b0) begin
                key_A <= 0;
                key_D <= 0;
                key_Enter <= 0;
                key_Escape <= 0;
                key_Space <= 0;
			end */
		  
	// end
	// else begin
	// 	        key_A <= 0;
    //             key_D <= 0;
    //             key_Enter <= 0;
    //             key_Escape <= 0;
    //             key_Space <= 0;
	// end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(reset),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX1)
);


endmodule
