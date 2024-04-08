// Written by Nathan Shreve

module update_piece_control(
	input clk,
	input iReset,
	input iEn,
	
	input iMoveRight,  							 // User input to move the piece right
	input iMoveLeft,   							 // User input to move the piece left
	input iMoveDown,   							 // Signal to move the piece down
	input iRotate,		 							 // User input to rotate the piece
	input iResetPiecePosition, 				 // Signal to change piece position to initial position at top of grid
	
	input iOutOfBounds,  						 // Piece is out of bounds (too low, far right, or far left)
	input iPieceBlockOverlap, 					 // Piece is inside one of the "fallen blocks"
	input iConvertDone, 							 // Piece's blocks have been converted to "fallen blocks"
	
	output reg oIncrementPiecePositionCol,  // Increment piece's column
	output reg oDecrementPiecePositionCol,  // Decrement piece's column
	output reg oIncrementPiecePositionRow,  // Increment piece's row
	output reg oDecrementPiecePositionRow,  // Decrement piece's row
	output reg oIncrementOrientation,		 // Rotate piece (clockwise or counterclockwise, depending on piece)	
	output reg oDecrementOrientation,		 // Rotate piece opposite direction
	output reg oGoToInitialPosition,        // Change piece position to initial position at top of grid
	
	output reg oConvertToFallen,				 // Convert "falling" piece's blocks to "fallen blocks"
	output reg oUpdateDone						 // Done updating piece
	);
	
	reg[4:0] next_state, current_state;
	
	localparam S_UP_1  = 5'd 1,
				  S_UP_2  = 5'd 2,
				  S_UP_3  = 5'd 3,
				  S_UP_4  = 5'd 4,
				  S_UP_5  = 5'd 5,
				  S_UP_6  = 5'd 6,
				  S_UP_7  = 5'd 7,
				  S_UP_8  = 5'd 8,
				  S_UP_9  = 5'd 9,
				  S_UP_10 = 5'd10,
				  S_UP_11 = 5'd11,
				  S_UP_12 = 5'd12,
				  S_UP_13 = 5'd13,
				  S_UP_14 = 5'd14,
				  
				  S_UP_A_new = 5'd15,
				  S_UP_B_new = 5'd16,
				  S_UP_C_new = 5'd17,
				  S_UP_D_new = 5'd18;
				 
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_UP_A_new;
		else if (iEn) begin
			case (current_state)
				S_UP_1: begin
					if      (iResetPiecePosition) next_state = S_UP_13;
					else if (iMoveRight) 			next_state = S_UP_2;
					else if (iMoveLeft) 				next_state = S_UP_4;
					else if (iMoveDown) 				next_state = S_UP_9;
					else if (iRotate) 				next_state = S_UP_6;
				end
				
				S_UP_2: next_state = S_UP_3;
				
				S_UP_3: begin
					if   (iOutOfBounds | iPieceBlockOverlap) next_state = S_UP_4;
					else 					  							  next_state = S_UP_14;
				end
				
				S_UP_4: next_state = S_UP_5;
				
				S_UP_5: begin
					if   (iOutOfBounds | iPieceBlockOverlap) next_state = S_UP_2;
					else 					 							  next_state = S_UP_14;
				end
				
				S_UP_6: next_state = S_UP_7;
				
				S_UP_7: begin
					if   (iOutOfBounds | iPieceBlockOverlap) next_state = S_UP_8;
					else 								  				  next_state = S_UP_14;
				end
				
				S_UP_8: next_state = S_UP_14;
				
				S_UP_9: next_state = S_UP_10;
				
				S_UP_10: begin
					if   (iOutOfBounds | iPieceBlockOverlap) next_state = S_UP_11;
					else												  next_state = S_UP_14;
				end
				
				S_UP_11: next_state = S_UP_12;
				
				S_UP_12: begin
					if   (iConvertDone) next_state = S_UP_14;
					else					  next_state = S_UP_12;
				end
				
				S_UP_13: next_state = S_UP_14;
				
				S_UP_14: next_state = S_UP_1;
			endcase
		end
	end // state_table
	
	// output_signals
	always@(*)
	begin: output_signals
		if (iReset) begin
			oIncrementPiecePositionCol = 0;
			oDecrementPiecePositionCol = 0;
			oIncrementPiecePositionRow = 0;
			oDecrementPiecePositionRow = 0;
			oIncrementOrientation 		= 0;
			oDecrementOrientation 		= 0;
			oGoToInitialPosition 		= 0;
			oConvertToFallen 				= 0;
			oUpdateDone 					= 0;
		end
		
		if (iEn) begin
			oIncrementPiecePositionCol = 0;
			oDecrementPiecePositionCol = 0;
			oIncrementPiecePositionRow = 0;
			oDecrementPiecePositionRow = 0;
			oIncrementOrientation 		= 0;
			oDecrementOrientation 		= 0;
			oGoToInitialPosition 		= 0;
			oConvertToFallen 				= 0;
			oUpdateDone 					= 0;
			
			case (current_state)
				S_UP_2: oIncrementPiecePositionCol = 1;
				
				S_UP_4: oDecrementPiecePositionCol = 1;
				
				S_UP_6: oIncrementOrientation = 1;
				
				S_UP_8: oDecrementOrientation = 1;
				
				S_UP_9: oIncrementPiecePositionRow = 1;
				
				S_UP_11: oDecrementPiecePositionRow = 1;
				
				S_UP_12: oConvertToFallen = 1;
				
				S_UP_13: oGoToInitialPosition = 1;
				
				S_UP_14: oUpdateDone = 1;
			endcase
		end
	end // output_signals
	
	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_UP_1;
		else if (iEn) current_state <= next_state;
   end // state_FFs
endmodule


module update_piece_datapath(
	input clk,
	input iReset,
	input iEn,
	
	input iMoveRight,
	input iMoveLeft,
	input iRotate,
	
	input iIncrementPiecePositionCol,
	input iDecrementPiecePositionCol,
	input iIncrementPiecePositionRow,
	input iDecrementPiecePositionRow,
	input iIncrementOrientation,
	input iDecrementOrientation,
	input iGoToInitialPosition,
	
	output reg signed[5:0] oPiecePositionCol, // The falling piece's column
	output reg[4:0] oPiecePositionRow,		   // The falling piece's row
	output reg[1:0] oOrientation					// The falling piece's orientation (rotational state)
	);
	
	// register logic
	always@(posedge clk) begin
		if (iReset) begin
			oPiecePositionCol <= 0;
			oPiecePositionRow <= 0;
			oOrientation		<= 0;
		end else if (iEn) begin
			if (iIncrementPiecePositionCol) oPiecePositionCol <= oPiecePositionCol + 1;
			
			if (iDecrementPiecePositionCol) oPiecePositionCol <= oPiecePositionCol - 1;
			
			if (iIncrementPiecePositionRow) oPiecePositionRow <= oPiecePositionRow + 1;
			
			if (iDecrementPiecePositionRow) oPiecePositionRow <= oPiecePositionRow - 1;
			
			if (iIncrementOrientation) oOrientation <= oOrientation + 1;
			
			if (iDecrementOrientation) oOrientation <= oOrientation - 1;
			
			if (iGoToInitialPosition) begin
				oPiecePositionCol <= 4;
				oPiecePositionRow <= 0;
			end
		end
	end
endmodule


module update_piece_top_level( // Update piece based on user input or signal to move down
	input clk,
	input iReset,
	input iEn,
	
	input iMoveRight,
	input iMoveLeft,
	input iMoveDown,
	input iRotate,
	input iResetPiecePosition,
	input iConvertDone,
   input[2:0] iPieceType,
	input[827:0] iFallenBlocks,
	
	output oConvertToFallen,
	output oUpdateDone,
	output[39:0] oFallingBlocks,
	output signed[5:0] oPiecePositionCol,
	output[4:0] oPiecePositionRow,
	output[1:0] oOrientation,
	output reg oPieceBlockOverlap
	);
	
	wire incrementPiecePositionCol;
	wire decrementPiecePositionCol;
	wire incrementPiecePositionRow;
	wire decrementPiecePositionRow;
	wire incrementOrientation;
	wire decrementOrientation;
	wire goToInitialPosition;
	
	genvar i, j, k;
	integer l;
	
	// decode constants from globals
	wire[223:0] offsets_col;
	wire[223:0] offsets_row;
	wire[55:0] rightmostColumns;
	wire[55:0] leftmostColumns;
	wire[55:0] bottomRows;
	
	globals constants(
		.offsets_col(offsets_col),
		.offsets_row(offsets_row),
		.rightmostColumns(rightmostColumns),
		.leftmostColumns(leftmostColumns),
		.bottomRows(bottomRows)
		);
	
	wire[1:0] offsets[1:7][0:3][0:3][0:1];      // The offsets of the blocks of a piece in relation to its position coordinate
															  // In the form offsets[piece_type][orientation][block_#][col_or_row]
															  
	wire signed[2:0] rightmostColumn[1:7][0:3]; // The largest column offset of each block
															  // In the form rightmostColumn[piece_type][orientation]
															  
	wire signed[2:0] leftmostColumn[1:7][0:3]; // The smallest column offset of each block
															 // In the form leftmostColumn[piece_type][orientation]
															 
	wire[1:0] bottomRow[1:7][0:3];				 // The largest row offset of each block
															 // In the form bottomRow[piece_type][orientation]
	
	// See globals.v to understand decoding logic
	generate
		for (i = 1; i < 8; i = i + 1) begin: loop1
			for (j = 0; j < 4; j = j + 1) begin: loop2
				for (k = 0; k < 4; k = k + 1) begin: loop3
					// index = ((i - 1) * 32) + (j * 8) + (k * 2);
					
					assign offsets[i][j][k][0]
								= offsets_col[((((i - 1) * 32) + (j * 8) + (k * 2)) + 1):(((i - 1) * 32) + (j * 8) + (k * 2))];
					assign offsets[i][j][k][1]
								= offsets_row[((((i - 1) * 32) + (j * 8) + (k * 2)) + 1):(((i - 1) * 32) + (j * 8) + (k * 2))];
				end
			end
		end
		
		for (i = 1; i < 8; i = i + 1) begin: loop4
			for (j = 0; j < 4; j = j + 1) begin: loop5
				// index = ((i - 1) * 8) + (j * 2);
				
				assign rightmostColumn[i][j] = rightmostColumns[((((i - 1) * 8) + (j * 2)) + 1):(((i - 1) * 8) + (j * 2))];
				assign leftmostColumn[i][j] = leftmostColumns[((((i - 1) * 8) + (j * 2)) + 1):(((i - 1) * 8) + (j * 2))];
				assign bottomRow[i][j] = bottomRows[((((i - 1) * 8) + (j * 2)) + 1):(((i - 1) * 8) + (j * 2))];
			end
		end
	endgenerate
	
	
	// determine fallingBlocks
	reg[4:0] fallingBlocks[0:3][0:1]; // Coordinates in the form fallingBlocks[block_#][row_or_col]
	always@(*)
	begin: fallingBlocks_alwblk
		for (l = 0; l < 4; l = l + 1) begin: loop5
			fallingBlocks[l][0] = oPiecePositionCol + offsets[iPieceType][oOrientation][l][0];
			fallingBlocks[l][1] = oPiecePositionRow + offsets[iPieceType][oOrientation][l][1];
		end
	end
	
	// encode oFallingBlocks
	assign oFallingBlocks = {
		fallingBlocks[3][1],
		fallingBlocks[3][0],
		fallingBlocks[2][1],
		fallingBlocks[2][0],
		fallingBlocks[1][1],
		fallingBlocks[1][0],
		fallingBlocks[0][1],
		fallingBlocks[0][0]
		};
		

	// decode fallenBlocks
	wire[2:0] fallenBlocks[0:11][0:22]; // Piece type at each coordinate in the form fallenBlocks[col][row]
	generate
		for (i = 0; i < 12; i = i + 1) begin: loop6
			for (j = 0; j < 23; j = j + 1) begin: loop7
				// index = (i * 69) + (j * 3);
				
				assign fallenBlocks[i][j] = iFallenBlocks[(((i * 69) + (j * 3)) + 2):((i * 69) + (j * 3))];
			end
		end
	endgenerate
	
	
	// configure outOfBounds and pieceBlockOverlap
	reg outOfBounds;
	always@(*) begin
		outOfBounds = ((oPiecePositionCol + rightmostColumn[iPieceType][oOrientation] > 10) |
							(oPiecePositionCol + leftmostColumn[iPieceType][oOrientation] < 1) |
							(oPiecePositionRow + bottomRow[iPieceType][oOrientation] > 21))
							? 1 : 0;
		
		oPieceBlockOverlap = ((fallenBlocks[fallingBlocks[0][0]][fallingBlocks[0][1]] == 0) &
									(fallenBlocks[fallingBlocks[1][0]][fallingBlocks[1][1]] == 0) &
									(fallenBlocks[fallingBlocks[2][0]][fallingBlocks[2][1]] == 0) &
									(fallenBlocks[fallingBlocks[3][0]][fallingBlocks[3][1]] == 0))
									? 0 : 1;					
	end
	
	
	update_piece_control UP_control(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
	
		.iMoveRight(iMoveRight),
		.iMoveLeft(iMoveLeft),
		.iMoveDown(iMoveDown),
		.iRotate(iRotate),
		.iResetPiecePosition(iResetPiecePosition),
	
		.iOutOfBounds(outOfBounds),
		.iPieceBlockOverlap(oPieceBlockOverlap),
		.iConvertDone(iConvertDone),
	
		.oIncrementPiecePositionCol(incrementPiecePositionCol),
		.oDecrementPiecePositionCol(decrementPiecePositionCol),
		.oIncrementPiecePositionRow(incrementPiecePositionRow),
		.oDecrementPiecePositionRow(decrementPiecePositionRow),
		.oIncrementOrientation(incrementOrientation),
		.oDecrementOrientation(decrementOrientation),
		.oGoToInitialPosition(goToInitialPosition),
	
		.oConvertToFallen(oConvertToFallen),
		.oUpdateDone(oUpdateDone)
		);
		
	update_piece_datapath UP_datapath(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
		
		.iIncrementPiecePositionCol(incrementPiecePositionCol),
		.iDecrementPiecePositionCol(decrementPiecePositionCol),
		.iIncrementPiecePositionRow(incrementPiecePositionRow),
		.iDecrementPiecePositionRow(decrementPiecePositionRow),
		.iIncrementOrientation(incrementOrientation),
		.iDecrementOrientation(decrementOrientation),
		.iGoToInitialPosition(goToInitialPosition),
	
		.oPiecePositionCol(oPiecePositionCol),
		.oPiecePositionRow(oPiecePositionRow),
		.oOrientation(oOrientation)
		);
endmodule	