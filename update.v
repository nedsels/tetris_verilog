// Written by Nathan Shreve

module update #(parameter CLOCK_FREQUENCY = 40) ( // integrates all game-logic FSMs
	input clk,
	input iReset,
	
	input iStartGame,  					  // Enable signal
	input iMoveRight,	 					  // User input to move the piece right
	input iMoveLeft,   					  // User input to move the piece left
	input iRotate,		 					  // User input to rotate the piece
	
	output[17:0] oScore,					  // Player score
	output wire[827:0] oFallenBlocks,  // Blocks that have already fallen
	output wire[39:0] oFallingBlocks,  // Blocks of the user-controlled falling piece
	output reg[2:0] oCurrentPiece,	  // Piece type of falling piece
	output oUpdateDone,					  // Done updating piece
	output oSound							  // Play sound for cleared row
	);
	
	wire genDone;
	wire generatePieceOrder;
	wire updatePiece;
	wire[2:0] index;
	wire[2:0] pieceOrder0;
	wire[2:0] pieceOrder1;
	wire[2:0] pieceOrder2;
	wire[2:0] pieceOrder3;
	wire[2:0] pieceOrder4;
	wire[2:0] pieceOrder5;
	wire[2:0] pieceOrder6;
	wire convertDone;
	wire convertToFallen;
	wire signed [5:0] piecePositionCol;
	wire[4:0] piecePositionRow;
	wire[1:0] orientation;
	wire pieceBlockOverlap;
	wire gameOver;
	
	
	// determine current piece
	always@(*) begin
		case (index)
			0: oCurrentPiece = pieceOrder0;
			1: oCurrentPiece = pieceOrder1;
			2: oCurrentPiece = pieceOrder2;
			3: oCurrentPiece = pieceOrder3;
			4: oCurrentPiece = pieceOrder4;
			5: oCurrentPiece = pieceOrder5;
			6: oCurrentPiece = pieceOrder6;
		endcase
	end
		
		
	// configure toggles
	wire toggle_resetPiecePosition;
	reg resetPiecePosition;
	always@(posedge clk) begin
		if 	  (iReset | oUpdateDone)		resetPiecePosition = 0;
		else if (toggle_resetPiecePosition) resetPiecePosition = 1;
	end
	
	wire toggle_moveDown;
	reg moveDown;
	always@(posedge clk) begin
		if 	  (iReset | oUpdateDone) moveDown = 0;
		else if (toggle_moveDown) 		 moveDown = 1;
	end
	
	wire toggle_nextPiece;
	reg nextPiece;
	always@(posedge clk) begin
		if 	  (iReset | generatePieceOrder | resetPiecePosition) nextPiece = 0;
		else if (toggle_nextPiece) 					 					  nextPiece = 1;
	end
	
	
	// determine moveDown
	rateDivider #(
		.CLOCK_FREQUENCY(CLOCK_FREQUENCY),
		.PULSES_PER_SECOND(2)
		) moveDownPulse(
		.clk(clk),
		.iReset(iReset),
		.iEn(iStartGame),
		
		.oPulse(toggle_moveDown)
		);
		
	
	game_loop_top_level GL(
		.clk(clk),
		.iReset(iReset),
		.iEn(iStartGame),
		
		.iMoveRight(iMoveRight),
		.iMoveLeft(iMoveLeft),
		.iMoveDown(moveDown),
		.iRotate(iRotate),
		
		.iGenDone(genDone),
		.iUpdateDone(oUpdateDone),
		.iNextPiece(nextPiece),
		.iPieceBlockOverlap(pieceBlockOverlap),
		
		.oGeneratePieceOrder(generatePieceOrder),
		.oResetPiecePosition(toggle_resetPiecePosition),
		.oUpdatePiece(updatePiece),
		.oIndex(index),
		.oGameOver(gameOver)
		);
		
	generate_piece_order_top_level GPO(
		.clk(clk),
		.iReset(iReset),
		.iEn(generatePieceOrder),
		
		.oPieceOrder0(pieceOrder0),
		.oPieceOrder1(pieceOrder1),
		.oPieceOrder2(pieceOrder2),
		.oPieceOrder3(pieceOrder3),
		.oPieceOrder4(pieceOrder4),
		.oPieceOrder5(pieceOrder5),
		.oPieceOrder6(pieceOrder6),
		.oGenDone(genDone)
		);
		
	update_piece_top_level UP(
		.clk(clk),
		.iReset(iReset),
		.iEn(updatePiece),
		
		.iMoveRight(iMoveRight),
		.iMoveLeft(iMoveLeft),
		.iMoveDown(moveDown),
		.iRotate(iRotate),
		.iResetPiecePosition(resetPiecePosition),
		.iConvertDone(convertDone),
		.iPieceType(oCurrentPiece),
		.iFallenBlocks(oFallenBlocks),
		
		.oConvertToFallen(convertToFallen),
		.oUpdateDone(oUpdateDone),
		.oFallingBlocks(oFallingBlocks),
		.oPiecePositionCol(piecePositionCol),
		.oPiecePositionRow(piecePositionRow),
		.oOrientation(orientation),
		.oPieceBlockOverlap(pieceBlockOverlap)
		);
		
	convert_to_fallen_top_level CTF(
		.clk(clk),
		.iReset(iReset),
		.iEn(convertToFallen),
		
		.iFallingBlocks(oFallingBlocks),
		.iPieceType(oCurrentPiece),
		
		.oFallenBlocks(oFallenBlocks),
		.oConvertDone(convertDone),
		.oNextPiece(toggle_nextPiece),
		.oScore(oScore),
		.oSound(oSound)
		);
endmodule