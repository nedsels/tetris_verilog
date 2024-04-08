// Written by Nathan Shreve

module generate_piece_order_control(
	input clk,
	input iReset,
	input iEn,
	
	input[7:1] iPiecesGenerated,        // Keeps track of which pieces have been generated
													// In the form iPiecesGenerated[piece_type]
	input[2:0] iIndex,						// Number of pieces generated in the order
	input[2:0] iNextPiece,					// Random piece selected to potentially be inserted in the order
	
	output reg oZeroNextPiece,				// set nextPiece to 0
	output reg oZeroPieceOrder,			// set pieceOrder array to 0
	output reg oZeroPiecesGenerated,		// set piecesGenerated array to 0
	output reg oZeroIndex,					// set index to 0
	output reg oIncrementIndex,			// increase index by 1
	output reg oLoadRandomPiece,			// load random 3b' into nextPiece
	output reg oLoadNextPiece,				// place nextPiece into sequence
	output reg oSetPieceGenerated,		// record that piece type has been generated
	
	output reg oGenDone
	);
	
	// configure piecesGenerated
	reg piecesGenerated[7:1];
	integer i;
	always@(*) begin
		for (i = 1; i < 8; i = i + 1) piecesGenerated[i] = iPiecesGenerated[i];
	end
	
	reg[4:0] next_state, current_state;
	
	localparam S_GPO_1 = 5'd1,
				  S_GPO_2 = 5'd2,
				  S_GPO_3 = 5'd3,
				  S_GPO_4 = 5'd4,
				  S_GPO_5 = 5'd5,
				  S_GPO_6 = 5'd6,
				  S_GPO_7 = 5'd7;
	
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_GPO_1;
		else if (iEn) begin
			case (current_state)
				S_GPO_1: next_state = S_GPO_2;
				
				S_GPO_2: next_state = S_GPO_3;
				
				S_GPO_3: begin
					if   (iPiecesGenerated[iNextPiece] | iNextPiece == 0) next_state = S_GPO_2;
					else 																   next_state = S_GPO_4;
				end
				
				S_GPO_4: next_state = S_GPO_5;
				
				S_GPO_5: next_state = S_GPO_6;
				
				S_GPO_6: begin
					if   (iIndex < 7) next_state = S_GPO_2;
					else 				   next_state = S_GPO_7;
				end
					
				S_GPO_7: next_state = S_GPO_1;
			endcase
		end
	end // state_table
	
	// output_signals
	always@(*)
	begin: output_signals
		if (iReset) begin
			oZeroNextPiece 		= 0;
			oZeroPieceOrder 		= 0;
			oZeroPiecesGenerated = 0;
			oZeroIndex 				= 0;
			oIncrementIndex 		= 0;
			oLoadRandomPiece 		= 0;
			oLoadNextPiece 		= 0;
			oSetPieceGenerated 	= 0;
			oIncrementIndex 		= 0;
			oGenDone					= 0;
		end
		
		if (iEn) begin
			oZeroNextPiece 		= 0;
			oZeroPieceOrder 		= 0;
			oZeroPiecesGenerated = 0;
			oZeroIndex 				= 0;
			oIncrementIndex 		= 0;
			oLoadRandomPiece 		= 0;
			oLoadNextPiece 		= 0;
			oSetPieceGenerated 	= 0;
			oIncrementIndex 		= 0;
			oGenDone					= 0;
			
			case (current_state)
				S_GPO_1: begin
					oZeroNextPiece 		= 1;
					oZeroPieceOrder	 	= 1;
					oZeroPiecesGenerated = 1;
					oZeroIndex 				= 1;
				end
				
				S_GPO_2: oLoadRandomPiece = 1;
				
				S_GPO_4: begin
					oLoadNextPiece 	 = 1;
					oSetPieceGenerated = 1;
				end
				
				S_GPO_5: oIncrementIndex = 1;
				
				S_GPO_7: oGenDone = 1;
			endcase
		end
	end // output_signals
	
	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_GPO_1;
		else if (iEn) current_state <= next_state;
   end // state_FFs
endmodule
	

module generate_piece_order_datapath(
	input clk,
	input iReset,
	input iEn,
	
	input iZeroNextPiece,
	input iZeroPieceOrder,
	input iZeroPiecesGenerated,
	input iZeroIndex,
	input iIncrementIndex,
	input iLoadRandomPiece,
	input iLoadNextPiece,
	input iSetPieceGenerated,
	
	output [7:1] oPiecesGenerated,
	output reg[2:0] oIndex,
	output reg[2:0] oNextPiece,
	
	output [20:0] oPieceOrder
	);
	
	
	// encode piecesGenerated
	reg piecesGenerated[7:1];
	assign oPiecesGenerated = {
		piecesGenerated[7],
		piecesGenerated[6],
		piecesGenerated[5],
		piecesGenerated[4],
		piecesGenerated[3],
		piecesGenerated[2],
		piecesGenerated[1]
		};
	
	
	// encode pieceOrder
	reg[2:0] pieceOrder[6:0];
	assign oPieceOrder = {
		pieceOrder[6],
		pieceOrder[5],
		pieceOrder[4],
		pieceOrder[3],
		pieceOrder[2],
		pieceOrder[1],
		pieceOrder[0]
		};
		
		
	// get random number
	wire[2:0] random;
	RNG randomPiece(
		.clk(clk),
		.iReset(iReset),
		
		.oNum(random)
		);
	
	// register logic
	integer i;
	always@(posedge clk) begin
		if (iReset) begin
			for (i = 0; i < 7; i = i + 1) pieceOrder[i] 	  <= 0;
	
			for (i = 1; i < 8; i = i + 1) piecesGenerated[i] <= 0;
			
			oIndex <= 0;
			oNextPiece <= 0;
		end else if (iEn) begin
			if (iZeroNextPiece) oNextPiece <= 0;
			
			if (iZeroPieceOrder) begin
				for (i = 0; i < 7; i = i + 1) pieceOrder[i] <= 0;
			end
			
			if (iZeroPiecesGenerated) begin
				for (i = 1; i < 8; i = i + 1) piecesGenerated[i] <= 0;
			end
			
			if (iZeroIndex) oIndex <= 0;
			
			if (iIncrementIndex) oIndex <= oIndex + 1;
			
			if (iLoadRandomPiece) oNextPiece <= random;
			
			if (iLoadNextPiece) pieceOrder[oIndex] <= oNextPiece;
			
			if (iSetPieceGenerated) piecesGenerated[oNextPiece] <= 1;
		end
	end
endmodule


module generate_piece_order_top_level( // Generate random order of 7 pieces so that none are repeated
	input clk,
	input iReset,
	input iEn,
	
	output[2:0] oPieceOrder0,
	output[2:0] oPieceOrder1,
	output[2:0] oPieceOrder2,
	output[2:0] oPieceOrder3,
	output[2:0] oPieceOrder4,
	output[2:0] oPieceOrder5,
	output[2:0] oPieceOrder6,
	output oGenDone
	);
	
	wire zeroNextPiece;
	wire zeroPieceOrder;
	wire zeroPiecesGenerated;
	wire zeroIndex;
	wire incrementIndex;
	wire loadRandomPiece;
	wire loadNextPiece;
	wire setPieceGenerated;
	wire[6:0] piecesGenerated;
	wire[2:0] index;
	wire[2:0] nextPiece;
	wire[20:0] pieceOrder;
	
	// encode pieceOrder
	assign oPieceOrder0 = pieceOrder[2:0];
	assign oPieceOrder1 = pieceOrder[5:3];
	assign oPieceOrder2 = pieceOrder[8:6];
	assign oPieceOrder3 = pieceOrder[11:9];
	assign oPieceOrder4 = pieceOrder[14:12];
	assign oPieceOrder5 = pieceOrder[17:15];
	assign oPieceOrder6 = pieceOrder[20:18];
	
	generate_piece_order_control GPO_control(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
	
		.iPiecesGenerated(piecesGenerated),
		.iIndex(index),
		.iNextPiece(nextPiece),
	
		.oZeroNextPiece(zeroNextPiece),
		.oZeroPieceOrder(zeroPieceOrder),
		.oZeroPiecesGenerated(zeroPiecesGenerated),
		.oZeroIndex(zeroIndex),
		.oIncrementIndex(incrementIndex),
		.oLoadRandomPiece(loadRandomPiece),
		.oLoadNextPiece(loadNextPiece),
		.oSetPieceGenerated(setPieceGenerated),
	
		.oGenDone(oGenDone)
		);
		
	generate_piece_order_datapath GPO_datapath(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
	
		.iZeroNextPiece(zeroNextPiece),
		.iZeroPieceOrder(zeroPieceOrder),
		.iZeroPiecesGenerated(zeroPiecesGenerated),
		.iZeroIndex(zeroIndex),
		.iIncrementIndex(incrementIndex),
		.iLoadRandomPiece(loadRandomPiece),
		.iLoadNextPiece(loadNextPiece),
		.iSetPieceGenerated(setPieceGenerated),
	
		.oPiecesGenerated(piecesGenerated),
		.oIndex(index),
		.oNextPiece(nextPiece),
	
		.oPieceOrder(pieceOrder)
		);
endmodule
	

module RNG(
	input clk,
	input iReset,
	
	output reg[2:0] oNum
	);
	
	reg[2:0] oNum_next;
	
	always@(*) begin

		oNum_next[2] = oNum[2] ^ oNum[0];
		oNum_next[1] = oNum[1] ^ oNum_next[2];
		oNum_next[0] = oNum[0] ^ oNum_next[1];
	end
	
	always@(posedge clk) begin
		if   (iReset) oNum <= 5'b11111;
		else 			  oNum <= oNum_next;
	end
endmodule
			