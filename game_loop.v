// Written by Nathan Shreve

module game_loop_control(
	input clk,
	input iReset,
	input iEn,
	
	input iMoveRight,
	input iMoveLeft,
	input iMoveDown,
	input iRotate,
	input iPieceBlockOverlap,
	
	input iGenDone, 						// done generating piece order
	input iUpdateDone,					// done updating piece and grid
	input iNextPiece,						// move to next piece in sequence
	input[2:0] iIndex,					// for iterating through array of pieces
	
	output reg oZeroIndex,				// make index 0
	output reg oIncrementIndex,		// increase index by 1
	
	output reg oGeneratePieceOrder,  // generate new piece order
	output reg oResetPiecePosition,	// move piece to (col, row) = (4,0)
	output reg oUpdatePiece, 			// update piece and grid
	output reg oGameOver
	);				
	
	reg[5:0] next_state, current_state;

	localparam S_GL_1 = 5'd1,
	           S_GL_2 = 5'd2,
	           S_GL_3 = 5'd3,
	           S_GL_4 = 5'd4,
	           S_GL_5 = 5'd5,
	           S_GL_6 = 5'd6,
				  S_GL_7 = 5'd7;
	
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_GL_1;
		else if (iEn) begin
			case (current_state)
				S_GL_1: begin
					if   (iGenDone) next_state = S_GL_2;
					else 			    next_state = S_GL_1;
				end
				
				S_GL_2: next_state = S_GL_3;
				
				S_GL_3: begin
				   /* if      (iPieceBlockOverlap) next_state = S_GL_7;
					else */ if (iUpdateDone) 		  next_state = S_GL_4;
					else 				    			     next_state = S_GL_3;
				end
				
				S_GL_4: begin
					if 	  (iNextPiece) 											 next_state = S_GL_5;
					else if (iMoveRight | iMoveLeft | iMoveDown | iRotate) next_state = S_GL_3;
					else 																	 next_state = S_GL_4;
				end
				
				S_GL_5: next_state = S_GL_6;
				
				S_GL_6: begin
					if   (iIndex == 7) next_state = S_GL_1;
					else 				    next_state = S_GL_2;
				end
				
				default: next_state = current_state;
			endcase
		end
	end // state_table
	
	// output_signals
	always@(*)
	begin: output_signals
		if (iReset) begin
			oGeneratePieceOrder = 0;
			oResetPiecePosition = 0;
			oUpdatePiece		  = 0;
			oZeroIndex 			  = 0;
			oIncrementIndex 	  = 0;
			oGameOver			  = 0;
		end
		
		if (iEn) begin
			oGeneratePieceOrder = 0;
			oUpdatePiece		  = 0;
			oZeroIndex 			  = 0;
			oIncrementIndex 	  = 0;
			oResetPiecePosition = 0;
			oGameOver			  = 0;
			
			case (current_state)
				S_GL_1: begin
					oZeroIndex 			  = 1;
					oGeneratePieceOrder = 1;
				end
				
				S_GL_2: oResetPiecePosition = 1;
				
				S_GL_3: oUpdatePiece = 1;
				
				S_GL_5: oIncrementIndex = 1;
				
				S_GL_7: oGameOver = 1;
			endcase
		end
	end // output_signals
	
	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_GL_1;
		else if (iEn) current_state <= next_state;
   end // state_FFs
endmodule // game_loop_control


module game_loop_datapath(
	input clk,
	input iReset,
	input iEn,
	
	input iZeroIndex,
	input iIncrementIndex,
	
	output reg[2:0] oIndex
	);
	
	// register logic
	always@(posedge clk) begin
		if (iReset) oIndex <= 0;
		else if (iEn) begin
			if (iZeroIndex) oIndex <= 0;
			
			if (iIncrementIndex) oIndex <= oIndex + 1;
		end
	end
endmodule


module game_loop_top_level( // highest-level game loop that speaks to other FSMs
	input clk,
	input iReset,
	input iEn,
	
	input iMoveRight,
	input iMoveLeft,
	input iMoveDown,
	input iRotate,
	
	input iGenDone,
	input iUpdateDone,
	input iNextPiece,
	input iPieceBlockOverlap,
	
	output oGeneratePieceOrder,
	output oResetPiecePosition,
	output oUpdatePiece,
	output[2:0] oIndex,
	output oGameOver
	);
	
	wire zeroIndex;
	wire incrementIndex;
	
	game_loop_control GL_control(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
		
		.iMoveRight(iMoveRight),
		.iMoveLeft(iMoveLeft),
		.iMoveDown(iMoveDown),
		.iRotate(iRotate),
		.iPieceBlockOverlap(iPieceBlockOverlap),
		
		.iGenDone(iGenDone),
		.iUpdateDone(iUpdateDone),
		.iNextPiece(iNextPiece),
		.iIndex(oIndex),
		
		.oZeroIndex(zeroIndex),
		.oIncrementIndex(incrementIndex),
		
		.oGeneratePieceOrder(oGeneratePieceOrder),
		.oResetPiecePosition(oResetPiecePosition),
		.oUpdatePiece(oUpdatePiece),
		.oGameOver(oGameOver)
		);
		
	game_loop_datapath GL_datapath(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
		
		.iZeroIndex(zeroIndex),
		.iIncrementIndex(incrementIndex),
		
		.oIndex(oIndex)
		);
endmodule