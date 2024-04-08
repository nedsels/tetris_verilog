// Brian Pham

module DE1_SoC_Audio_Example (
// Inputs
CLOCK_50,
KEY,

AUD_ADCDAT,

// Bidirectionals
AUD_BCLK,
AUD_ADCLRCK,
AUD_DACLRCK,

FPGA_I2C_SDAT,

// Outputs
AUD_XCK,
AUD_DACDAT,

FPGA_I2C_SCLK,
SW,

//Added
LEDR,
lineClear ///////////////////////////////////////////////////////////////////////////////////TO BE ADDED
);

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
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input CLOCK_50;
input [3:0] KEY;
input [9:0] SW;
input lineClear; ///////////////////////////////////////////////////////////////////////////////////TO BE ADDED
output [9:0] LEDR;

input AUD_ADCDAT;

// Bidirectionals
inout AUD_BCLK;
inout AUD_ADCLRCK;
inout AUD_DACLRCK;

inout FPGA_I2C_SDAT;

// Outputs
output AUD_XCK;
output AUD_DACDAT;

output FPGA_I2C_SCLK;

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
 reg [27:0] counter;
 initial begin counter = 27'd0; end
 
 reg LED8;
 reg LED7;
 initial begin LED7 = 1'd1;end
 assign LEDR[7] = LED7;
 assign LEDR[8] = LED8;

 
always @(posedge CLOCK_50) begin
//delay = {1'd0, SW[3:0], 15'd3000};

 if (lineClear) begin
 counter = counter + 27'd1;
 end
 
 if (counter > 27'd0) begin
	counter = counter + 27'd1;
	 LED8 = 1;
 end

 if (counter > 27'd25000000) begin
 counter = 27'd0;
 LED8 = 0;
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

wire [31:0] sound = (counter == 27'd0 /*&& playSongNote == 0*/) ? 0 : snd ? 32'd10000000 : -32'd10000000; //Change SW[9] to lineClear


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

module SongRate(input clock, output pulse);
	
	reg [28:0] counter;
	
	always@(posedge clock) begin
		if(counter == 29'd0) begin	
			counter <= (50000000/3)-1;
		end else begin
				counter <= counter - 1;
		end
	end
		
		assign pulse = (counter == 0)? 1'b1: 1'b0;
		
endmodule

module TetrisSong(input STARTGAME, clock, output reg [19:0] songNote, output reg playSongNote);

wire pulse;
SongRate u1(.clock(clock), .pulse(pulse));

reg [17:0] y, Y;

localparam A5 = 50000000/440/2; //56818.18182
localparam G5 = 50000000/783.99;//63776.32368
localparam F5 = 50000000/698.46;//71586.06076
localparam E5 = 50000000/659.3; //75843.76185
localparam D5 = 50000000/587.33;//85131.01663
localparam C5 = 50000000/523.25;//95556.6173
localparam B4 = 50000000/493.9; //101239.1674
localparam A4 = 50000000/440;	//113636.3636

//FSM datapath
always@(*) begin
	case(y)
	1: begin // E5 quarter note
		if (pulse) Y <= 2;
		else if (!pulse) Y <= 1;
		songNote <= E5;
	end
	2: begin // E5 quarter
		if (pulse) Y <= 3;
		else if (!pulse) Y <= 2;
		songNote <= E5;
	end
	3: begin // B4 eighth
		if (pulse) Y <= 4;
		else if (!pulse) Y <= 3;
		songNote <= B4;
	end
	4: begin // C5 eighth
		if (pulse) Y <= 5;
		else if (!pulse) Y <= 4;
		songNote <= C5;
	end
	5: begin // D5 quarter
		if (pulse) Y <= 6;
		else if (!pulse) Y <= 5;
		songNote <= D5;
	end
	6: begin // D5 quarter
		if (pulse) Y <= 7;
		else if (!pulse) Y <= 6;
		songNote <= D5;
	end
	7: begin // C5 eighth
		if (pulse) Y <= 8;
		else if (!pulse) Y <= 7;
		songNote <= C5;
	end
	8: begin // B4 eighth
		if (pulse) Y <= 7;
		else if (!pulse) Y <= 8;
		songNote <= B4;
	end
	9: begin // A4 quarter
		if (pulse) Y <= 10;
		else if (!pulse) Y <= 9;
		songNote <= A4;
	end
	10: begin // A4 quarter
		if (pulse) Y <= 11;
		else if (!pulse) Y <= 10;
		songNote <= A4;
	end
	//A4 eighth
	11: begin
		if (pulse) Y <= 12;
		else if (!pulse) Y <= 11;
		songNote <= A4;
	end
	//C5 eighth
	12: begin
		if (pulse) Y <= 13;
		else if (!pulse) Y <= 12;
		songNote <= C5;
	end
	//E5 quarter
	13: begin
		if (pulse) Y <= 14;
		else if (!pulse) Y <= 13;
		songNote <= E5;
	end
	//E5 quarter
	14: begin
		if (pulse) Y <= 15;
		else if (!pulse) Y <= 14;
		songNote <= E5;
	end
	//D5 eighth
	15: begin
		if (pulse) Y <= 16;
		else if (!pulse) Y <= 15;
		songNote <= D5;
	end
	//C5 eighth
	16: begin
		if (pulse) Y <= 17;
		else if (!pulse) Y <= 16;
		songNote <= C5;
	end
	//B4 quarter
	17: begin
		if (pulse) Y <= 18;
		else if (!pulse) Y <= 17;
		songNote <= B4;
	end
	//B4 quarter
	18: begin
		if (pulse) Y <= 19;
		else if (!pulse) Y <= 18;
		songNote <= B4;
	end
	//C5 eighth
	19: begin
		if (pulse) Y <= 20;
		else if (!pulse) Y <= 19;
		songNote <= C5;
	end
	//D5 quarter
	20: begin
		if (pulse) Y <= 21;
		else if (!pulse) Y <= 20;
		songNote <= D5;
	end
	//D5 quarter
	21: begin
		if (pulse) Y <= 22;
		else if (!pulse) Y <= 21;
		songNote <= D5;
	end
	//E5 quarter
	22: begin
		if (pulse) Y <= 23;
		else if (!pulse) Y <= 22;
		songNote <= E5;
	end
	//E5 quarter
	23: begin
		if (pulse) Y <= 24;
		else if (!pulse) Y <= 23;
		songNote <= E5;
	end
	//C5 quarter
	24: begin
		if (pulse) Y <= 25;
		else if (!pulse) Y <= 24;
		songNote <= C5;
	end
	//C5 quarter
	25: begin
		if (pulse) Y <= 26;
		else if (!pulse) Y <= 25;
		songNote <= C5;
	end
	//A4 quarter
	26: begin
		if (pulse) Y <= 27;
		else if (!pulse) Y <= 26;
		songNote <= A4;
	end
	//A4 quarter
	27: begin
		if (pulse) Y <= 28;
		else if (!pulse) Y <= 27;
		songNote <= A4;
	end
//////////////
//variation
//////////////
	//eighth rest (or A4 eighth)
	28: begin
		if (pulse) Y <= 29;
		else if (!pulse) Y <= 28;
		songNote <= 20'b0;
	end
	//A4 eighth
	29: begin
		if (pulse) Y <= 30;
		else if (!pulse) Y <= 29;
		songNote <= A4;
	end
	//B4 eighth
	30: begin
		if (pulse) Y <= 31;
		else if (!pulse) Y <= 30;
		songNote <= B4;
	end
	//C5 eighth
	31: begin
		if (pulse) Y <= 32;
		else if (!pulse) Y <= 31;
		songNote <= C5;
	end
	//D5 dotted quarter
	32: begin
		if (pulse) Y <= 33;
		else if (!pulse) Y <= 32;
		songNote <= D5;
	end
	//D5 dotted quarter
	33: begin
		if (pulse) Y <= 34;
		else if (!pulse) Y <= 33;
		songNote <= D5;
	end
	//D5 dotted quarter
	34: begin
		if (pulse) Y <= 35;
		else if (!pulse) Y <= 34;
		songNote <= D5;
	end
	//F5 eighth
	35: begin
		if (pulse) Y <= 36;
		else if (!pulse) Y <= 35;
		songNote <= F5;
	end
	//A5 quarter
	36: begin
		if (pulse) Y <= 37;
		else if (!pulse) Y <= 36;
		songNote <= A5;
	end
	//A5 quarter
	37: begin
		if (pulse) Y <= 38;
		else if (!pulse) Y <= 37;
		songNote <= A5;
	end
	//G5 eighth
	38: begin
		if (pulse) Y <= 39;
		else if (!pulse) Y <= 38;
		songNote <= G5;
	end
	//F5 eighth
	39: begin
		if (pulse) Y <= 40;
		else if (!pulse) Y <= 39;
		songNote <= F5;
	end
	//E5 dotted quarter
	40: begin
		if (pulse) Y <= 41;
		else if (!pulse) Y <= 40;
		songNote <= E5;
	end
	//E5 dotted quarter
	41: begin
		if (pulse) Y <= 42;
		else if (!pulse) Y <= 41;
		songNote <= E5;
	end
	//E5 dotted quarter
	42: begin
		if (pulse) Y <= 43;
		else if (!pulse) Y <= 42;
		songNote <= E5;
	end
	//C5 eighth
	43: begin
		if (pulse) Y <= 44;
		else if (!pulse) Y <= 43;
		songNote <= C5;
	end
	//E5 quarter
	44: begin
		if (pulse) Y <= 45;
		else if (!pulse) Y <= 44;
		songNote <= E5;
	end
	//E5 quarter
	45: begin
		if (pulse) Y <= 46;
		else if (!pulse) Y <= 45;
		songNote <= E5;
	end
	//D5 eighth
	46: begin
		if (pulse) Y <= 47;
		else if (!pulse) Y <= 46;
		songNote <= D5;
	end
	//C5 eighth
	47: begin
		if (pulse) Y <= 48;
		else if (!pulse) Y <= 47;
		songNote <= C5;
	end
	//B4 quarter
	48: begin
		if (pulse) Y <= 49;
		else if (!pulse) Y <= 48;
		songNote <= B4;
	end
	//B4 quarter
	49: begin
		if (pulse) Y <= 50;
		else if (!pulse) Y <= 49;
		songNote <= B4;
	end
	//B4 eighth
	50: begin
		if (pulse) Y <= 51;
		else if (!pulse) Y <= 50;
		songNote <= B4;
	end
	//C5 eighth
	51: begin
		if (pulse) Y <= 52;
		else if (!pulse) Y <= 51;
		songNote <= C5;
	end
	//D5 quarter
	52: begin
		if (pulse) Y <= 53;
		else if (!pulse) Y <= 52;
		songNote <= D5;
	end
	//D5 quarter
	53: begin
		if (pulse) Y <= 54;
		else if (!pulse) Y <= 53;
		songNote <= D5;
	end
	//E5 quarter
	54: begin
		if (pulse) Y <= 55;
		else if (!pulse) Y <= 54;
		songNote <= E5;
	end
	//E5 quarter
	55: begin
		if (pulse) Y <= 56;
		else if (!pulse) Y <= 55;
		songNote <= E5;
	end
	//C5 quarter
	56: begin
		if (pulse) Y <= 57;
		else if (!pulse) Y <= 56;
		songNote <= C5;
	end
	//C5 quarter
	57: begin
		if (pulse) Y <= 58;
		else if (!pulse) Y <= 57;
		songNote <= C5;
	end
	//A4 quarter
	58: begin
		if (pulse) Y <= 59;
		else if (!pulse) Y <= 58;
		songNote <= A4;
	end
	//A4 quarter
	59: begin
		if (pulse) Y <= 60;
		else if (!pulse) Y <= 59;
		songNote <= A4;
	end
	//A4 quarter
	60: begin
		if (pulse) Y <= 61;
		else if (!pulse) Y <= 60;
		songNote <= A4;
	end
	//A4 quarter
	61: begin
		if (pulse) Y <= 62;
		else if (!pulse) Y <= 61;
		songNote <= A4;
	end
	//quarter rest
	62: begin
		if (pulse) Y <= 63;
		else if (!pulse) Y <= 62;
		songNote <= 20'b0;
	end
	//quarter rest
	63: begin
		if (pulse) Y <= 1;
		else if (!pulse) Y <= 63;
		songNote <= 20'b0;
	end

	endcase
end

//FSM logic
always@(posedge clock) begin
	if(STARTGAME) begin //must be pulse otherwise stuck on first note
		playSongNote <= 1'b1;
		y = 1;
	end else begin
		y = Y;
	end
	if(y == 28 || y == 62 || y == 63) begin
		playSongNote <= 1'b0;
	end else if(y != 28 || y != 62 || y != 63) begin //else if?
		playSongNote <= 1'b1;
	end
end

endmodule
