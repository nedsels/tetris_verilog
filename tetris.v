// Written by Nathan Shreve
//Written by Brian starting line 314

module tetris(
	input CLOCK_50,

	input[3:0] KEY,
	input[9:0] SW,
	
	input AUD_ADCDAT,
	
	output[6:0] HEX0,
	output[6:0] HEX1,
	output[6:0] HEX2,
	output[6:0] HEX3,
	output[6:0] HEX4,
	output[6:0] HEX5,
	output[9:0] LEDR,
	
	output oFrameDone,
	
	inout PS2_CLK,
	inout PS2_DAT,
	inout AUD_BCLK,
	inout AUD_ADCLRCK,
	inout AUD_DACLRCK,
	inout FPGA_I2C_SDAT,

	output VGA_CLK,   					//	VGA Clock
	output VGA_HS,							//	VGA H_SYNC
	output VGA_VS,							//	VGA V_SYNC
	output VGA_BLANK_N,					//	VGA BLANK
	output VGA_SYNC_N,					//	VGA SYNC
	output[7:0] VGA_R,   				//	VGA Red[9:0]
	output[7:0] VGA_G,	 				//	VGA Green[9:0]
	output[7:0] VGA_B,   				//	VGA Blue[9:0]
	
	output AUD_XCK,
	output AUD_DACDAT,
	output FPGA_I2C_SCLK
	);
	
	localparam CLOCK_FREQUENCY = 50000000;
	localparam FRAME_RATE = 60;
	
	wire[17:0] score;
	wire[827:0] fallenBlocks;
	wire[39:0] fallingBlocks;
	wire[2:0] currentPiece;
	wire playSound;
	
	/* reg pause;
	always@(posedge CLOCK_50) begin
		if   	  (reset) pause = 0;
		else if (SPACE) pause = ~pause;
	end */
	
	wire[2:0] colour;
	wire[7:0] x;
	wire[6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
		.resetn(~reset),
		.clock(CLOCK_50),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(writeEn),
		// Signals for the DAC to drive the monitor.
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK)
		);
		
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	// inputs
	wire A, D, Escape, Enter, Space;
	PS2_Demo keyboard(
		.CLOCK_50(CLOCK_50),
		.reset(Escape),

		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),
		
		.key_A(A),
		.key_D(D),
		.key_Enter(Enter),
		.key_Escape(Escape),
		.key_Space(Space),
		
		.LEDR(LEDR[4:0])
	);
	
	wire reset;
	assign reset = Escape;
	// assign reset = ~KEY[0];
	
	wire updateDone;
	wire RIGHT, LEFT, ROTATE;
	// configure right button
	button moveRightButton(
		.clk(CLOCK_50),
		.iReset(reset),
		
		.iButton(D),
		.iOffSignal(updateDone),
		
		.oSignal(RIGHT)
		);
		
	// configure left button
	button moveLeftButton(
		.clk(CLOCK_50),
		.iReset(reset),
		
		.iButton(A),
		.iOffSignal(updateDone),
		
		.oSignal(LEFT),
		);
		
	// configure rotate button
	button rotateButton(
		.clk(CLOCK_50),
		.iReset(reset),
		
		.iButton(Enter),
		.iOffSignal(updateDone),
		
		.oSignal(ROTATE)
		);
		
		
	// configure score output
	reg[23:0] scoreBase10;
	wire enableDigit1;
	wire enableDigit2;
	wire enableDigit3;
	wire enableDigit4;
	wire enableDigit5;
	always@(*) begin	
		scoreBase10[3:0]   =  score		     % 10;
		scoreBase10[7:4]   = (score /     10) % 10;
		scoreBase10[11:8]  = (score /    100) % 10;
		scoreBase10[15:12] = (score /   1000) % 10;
		scoreBase10[19:16] = (score /  10000) % 10;
		scoreBase10[23:19] = (score / 100000) % 10;
	end
	
	assign enableDigit1 = (score >     9);
	assign enableDigit2 = (score >    99);
	assign enableDigit3 = (score >   999);
	assign enableDigit4 = (score >  9999);
	assign enableDigit5 = (score > 99999);
	
	hex_decoder digit0(
		.c(scoreBase10[3:0]),
		.enable(1),
		.display(HEX0)
		);
		
	hex_decoder digit1(
		.c(scoreBase10[7:4]),
		.enable(enableDigit1),
		.display(HEX1)
		);
		
	hex_decoder digit2(
		.c(scoreBase10[11:8]),
		.enable(enableDigit2),
		.display(HEX2)
		);
		
	hex_decoder digit3(
		.c(scoreBase10[15:12]),
		.enable(enableDigit3),
		.display(HEX3)
		);
		
	hex_decoder digit4(
		.c(scoreBase10[19:16]),
		.enable(enableDigit4),
		.display(HEX4)
		);
		
	hex_decoder digit5(
		.c(scoreBase10[23:19]),
		.enable(enableDigit5),
		.display(HEX5)
		);
		
		
	// generate frame rate
	wire toggleDraw;
	reg draw;
	always@(posedge CLOCK_50) begin
		if   	  (reset) 		draw = 0;
		else if (toggleDraw) draw = 1;
		else if (oFrameDone) draw = 0;
	end
	
	rateDivider #(
		.CLOCK_FREQUENCY(CLOCK_FREQUENCY),
		.PULSES_PER_SECOND(FRAME_RATE)
		) frameRate (
		.clk(CLOCK_50),
		.iReset(reset),
		.iEn(1),
		
		.oPulse(toggleDraw)
		);

		
	// update and draw	
	update #(
		.CLOCK_FREQUENCY(CLOCK_FREQUENCY)
		) TETRIS_update (
		.clk(CLOCK_50),
		.iReset(reset),
		
		.iStartGame(SW[0]),
		.iMoveRight(RIGHT),
		.iMoveLeft(LEFT),
		.iRotate(ROTATE),
		
		.oScore(score),
		.oFallenBlocks(fallenBlocks),
		.oFallingBlocks(fallingBlocks),
		.oCurrentPiece(currentPiece),
		.oUpdateDone(updateDone),
		.oSound(playSound)
		);
		
			//For testing that playSound works
	reg soundreg;
	reg [27:0] counter;
	initial begin counter = 27'd0; end
	wire LEDIndicator;
	assign LEDIndicator = soundreg;
	
	always@(posedge CLOCK_50) begin
		if (reset) begin
			soundreg = 0;
			counter = 27'd0;
		end
		if (playSound) begin
			soundreg = 1;
			counter = 27'd1;
		end
		
		if (counter > 27'd0) begin
			counter = counter + 27'd1;
		end
		
		if (counter > 27'd25000000) begin
			counter = 27'd0;
			soundreg = 0;
		end
		
	end
	
	assign LEDR[9] = LEDIndicator;
		
		
			// sound for line clear
	
//	DE1_SoC_Audio_Example lineClear(
//		.CLOCK_50(CLOCK_50),
//		.AUD_ADCDAT(AUD_ADCDAT),
//		.AUD_BCLK(AUD_BCLK),
//		.AUD_ADCLRCK(AUD_ADCLRCK),
//		.AUD_DACLRCK(AUD_DACLRCK),
//		.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
//		.AUD_XCK(AUD_XCK),
//		.AUD_DACDAT(AUD_DACDAT),
//		.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
//		.lineClear(playSound)
//	);

	
	draw #(
		.SCR_WIDTH(160),
		.SCR_HEIGHT(120)
		) TETRIS_draw (
		.clk(CLOCK_50),
		.iReset(reset),
		.iEn(draw),
		
		.iFallingBlocks(fallingBlocks),
		.iFallenBlocks(fallenBlocks),
		.iPieceType(currentPiece),
		
		.oFrameDone(oFrameDone),
		.oPlot(writeEn),
		.oX(x),
		.oY(y),
		.oColour(colour)
		);
		
		////////////////////////////////////////////////////////////////
		// Brian Pham

//		//For testing that playSound works
//	reg soundreg;
//	reg [27:0] counter;
//	initial begin counter = 27'd0; end
//	wire LEDIndicator;
//	assign LEDIndicator = soundreg;
//	
//	always@(posedge CLOCK_50) begin
//		if (reset) begin
//			soundreg = 0;
//			counter = 27'd0;
//		end
//		if (playSound) begin
//			soundreg = 1;
//			counter = 27'd1;
//		end
//		
//		if (counter > 27'd0) begin
//			counter = counter + 27'd1;
//		end
//		
//		if (counter > 27'd25000000) begin
//			counter = 27'd0;
//			soundreg = 0;
//		end
//		
//	end
//	
//	assign LEDR[9] = LEDIndicator;
	
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter A5 = 50000000/440/2; //56818.18182
parameter G5 = 50000000/783.99;//63776.32368
parameter F5 = 50000000/698.46;//71586.06076
parameter E5 = 50000000/659.3; //75843.76185
parameter D5 = 50000000/587.33;//85131.01663
parameter C5 = 50000000/523.25;//95556.6173
parameter B4 = 50000000/493.9; //101239.1674
parameter A4 = 50000000/440;	//113636.3636


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire audio_in_available;
wire [31:0] left_channel_audio_in;
wire [31:0] right_channel_audio_in;
wire read_audio_in;

wire audio_out_allowed;
wire [31:0] left_channel_audio_out;
wire [31:0] right_channel_audio_out;
wire write_audio_out;

// Internal Registers

reg [19:0] delay_cnt;
reg [19:0] delay;

reg snd;
wire songNote;
wire playSongNote;
//wire lineClear;/////////////////////////////////////////////////////////////////////////////////TO BE REMOVED

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

//assign lineClear = SW[9];
 
// TetrisSong u1(.STARTGAME(lineClear), .clock(CLOCK_50), .songNote(songNote), .playSongNote(playSongNote));
 
 //////////////////////Beep for 1/2 second
 initial delay = A4;
 reg [27:0] counterSound;
 initial begin counterSound = 27'd0; end
// reg LED8;
// reg LED7;
// initial begin LED7 = 1'd1;end
// assign LEDR[7] = LED7;
// assign LEDR[8] = LED8;

 
always @(posedge CLOCK_50) begin
//delay = {1'd0, SW[3:0], 15'd3000};


//counterSound != causes a sound to play, happens when a line is cleared
 if (playSound) begin
 counterSound <= counterSound + 27'd1;
 end
 
 if (counterSound > 27'd0) begin
	counterSound <= counterSound + 27'd1;
//	 LED8 = 1;
 end

 if (counterSound > 27'd25000000) begin
 counterSound <= 27'd0;
// LED8 = 0;
 end

if(delay_cnt == delay) begin
delay_cnt <= 0;
snd <= !snd;
end else delay_cnt <= delay_cnt + 1;
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 
//assign delay = {1'd0, SW[3:0], 15'd3000};

//wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;

wire [31:0] sound = (counterSound == 27'd0 /*&& playSongNote == 0*/) ? 0 : snd ? 32'd10000000 : -32'd10000000; //Change SW[9] to lineClear


assign read_audio_in = audio_in_available & audio_out_allowed;

assign left_channel_audio_out = left_channel_audio_in+sound;
assign right_channel_audio_out = right_channel_audio_in+sound;
assign write_audio_out = audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
// Inputs
.CLOCK_50 (CLOCK_50),
.reset (~KEY[0]),

.clear_audio_in_memory (),
.read_audio_in (read_audio_in),

.clear_audio_out_memory (),
.left_channel_audio_out (left_channel_audio_out),
.right_channel_audio_out (right_channel_audio_out),
.write_audio_out (write_audio_out),

.AUD_ADCDAT (AUD_ADCDAT),

// Bidirectionals
.AUD_BCLK (AUD_BCLK),
.AUD_ADCLRCK (AUD_ADCLRCK),
.AUD_DACLRCK (AUD_DACLRCK),


// Outputs
.audio_in_available (audio_in_available),
.left_channel_audio_in (left_channel_audio_in),
.right_channel_audio_in (right_channel_audio_in),

.audio_out_allowed (audio_out_allowed),

.AUD_XCK (AUD_XCK),
.AUD_DACDAT (AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
.FPGA_I2C_SCLK (FPGA_I2C_SCLK),
.FPGA_I2C_SDAT (FPGA_I2C_SDAT),
.CLOCK_50 (CLOCK_50),
.reset (~KEY[0])
);

endmodule
