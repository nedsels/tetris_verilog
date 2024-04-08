// Written by Nathan Shreve

module convert_to_fallen_control(
	input clk,
	input iReset,
	input iEn,
	
	input[2:0] iFilledRows,  			 // Number of filled rows
	input[5:0] iRowIndex,    			 // Current row being checked to see if it's full
	input[199:0] iRows,      			 // See below
	
	output reg oResetRowIndex,  		 // Set row index to 21 (start from the bottom and go up)
	output reg oZeroFilledRows, 		 // Set number of filled rows to 0
	output reg oConvertFallingBlocks, // Convert "falling" piece's blocks to "fallen" blocks
	output reg oMoveRowDown,  			 // Move row of blocks down to replace filled row
	output reg oIncreaseScore, 		 // Increase player score based on number of rows cleared
	output reg oIncrementFilledRows,  // Increase number of filled rows
	output reg oDecrementRowIndex, 	 // Decrement row index (moving upwards)
	output reg oClearRow, 				 // Clear filled row
	
	output reg oConvertDone,			 // Done converting piece and updating filled rows, etc.
	output reg oNextPiece,            // Make the "falling" piece the next one in the order and reset its position
	output reg oSound
	);
	
	// decode iRows
	wire[10:1] rows[2:21]; // In each row, which coordinates (columns) of "fallen" blocks are present in the form rows[row]
	genvar i;
	generate
		for (i = 2; i < 22; i = i + 1) begin: loop1
			// index = (i - 2) * 10
			
			assign rows[i] = iRows[(((i - 2) * 10) + 9):((i - 2) * 10)];
		end
	endgenerate
	
	reg[4:0] next_state, current_state;
	
	localparam S_CTF_1 = 5'd1,
				  S_CTF_2 = 5'd2,
				  S_CTF_3 = 5'd3,
				  S_CTF_4 = 5'd4,
				  S_CTF_5 = 5'd5,
				  S_CTF_6 = 5'd6,
				  S_CTF_7 = 5'd7,
				  S_CTF_8 = 5'd8;
	
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_CTF_1;
		else if (iEn) begin
			case (current_state)
				S_CTF_1: next_state = S_CTF_2;
				
				S_CTF_2: begin
					if      (iRowIndex == 1) 	next_state = S_CTF_7;
					else if (&rows[iRowIndex]) next_state = S_CTF_3;
					else if (iFilledRows > 0) 	next_state = S_CTF_4;
					else								next_state = S_CTF_6;
				end
				
				S_CTF_3: next_state = S_CTF_6;
				
				S_CTF_4: next_state = S_CTF_5;
				
				S_CTF_5: next_state = S_CTF_6;
				
				S_CTF_6: next_state = S_CTF_2;
				
				S_CTF_7: next_state = S_CTF_8;
				
				S_CTF_8: next_state = S_CTF_1;
			endcase
		end
	end // state_table
	
	// output_signals
	always@(*)
	begin: output_signals
		if (iReset) begin
			oResetRowIndex 		 = 0;
			oZeroFilledRows 		 = 0;
			oConvertFallingBlocks = 0;
			oMoveRowDown 			 = 0;
			oIncreaseScore 		 = 0;
			oIncrementFilledRows  = 0;
			oDecrementRowIndex 	 = 0;
			oClearRow 				 = 0;
			oConvertDone 			 = 0;
			oNextPiece 				 = 0;
			oSound 					 = 0;
		end
		
		if (iEn) begin
			oResetRowIndex 		 = 0;
			oZeroFilledRows 		 = 0;
			oConvertFallingBlocks = 0;
			oMoveRowDown 			 = 0;
			oIncreaseScore 		 = 0;
			oIncrementFilledRows  = 0;
			oDecrementRowIndex 	 = 0;
			oClearRow 				 = 0;
			oConvertDone 			 = 0;
			oNextPiece 				 = 0;
			oSound 					 = 0;
			
			case (current_state)
				S_CTF_1: begin
					oZeroFilledRows 		 = 1;
					oResetRowIndex 		 = 1;
					oConvertFallingBlocks = 1;
				end
				
				S_CTF_3: oIncrementFilledRows = 1;
				
				S_CTF_4: oMoveRowDown = 1;
				
				S_CTF_5: oClearRow = 1;
				
				S_CTF_6: oDecrementRowIndex = 1;
				
				S_CTF_7: oIncreaseScore = 1;
				
				S_CTF_8: begin
					oConvertDone = 1;
					oNextPiece 	 = 1;
					oSound 		 = (iFilledRows > 0);
				end
			endcase
		end
	end // output_signals

	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_CTF_1;
		else if (iEn) current_state <= next_state;
   end // state_FFs	
endmodule
	
	
module convert_to_fallen_datapath(
	input clk,
	input iReset,
	input iEn,
	
	input[7:0] iScoreIncreaseAmount,
	input[39:0] iFallingBlocks,
	input[2:0] iPieceType,
	input iResetRowIndex,
	input iZeroFilledRows,
	input iConvertFallingBlocks,
	input iMoveRowDown,
	input iIncreaseScore,
	input iIncrementFilledRows,
	input iDecrementRowIndex,
	input iClearRow,
	
	output reg[5:0] oRowIndex,
	output reg[17:0] oScore,
	output reg[2:0] oFilledRows,
	output[827:0] oFallenBlocks
	);
	
	// encode oFallingBlocks
	reg[2:0] fallenBlocks[0:11][0:22];  // Piece type at each coordinate in the form fallenBlocks[col][row]
	assign oFallenBlocks = {
		fallenBlocks[11][22],
		fallenBlocks[11][21],
		fallenBlocks[11][20],
		fallenBlocks[11][19],
		fallenBlocks[11][18],
		fallenBlocks[11][17],
		fallenBlocks[11][16],
		fallenBlocks[11][15],
		fallenBlocks[11][14],
		fallenBlocks[11][13],
		fallenBlocks[11][12],
		fallenBlocks[11][11],
		fallenBlocks[11][10],
		fallenBlocks[11][9],
		fallenBlocks[11][8],
		fallenBlocks[11][7],
		fallenBlocks[11][6],
		fallenBlocks[11][5],
		fallenBlocks[11][4],
		fallenBlocks[11][3],
		fallenBlocks[11][2],
		fallenBlocks[11][1],
		fallenBlocks[11][0],
		
		fallenBlocks[10][22],
		fallenBlocks[10][21],
		fallenBlocks[10][20],
		fallenBlocks[10][19],
		fallenBlocks[10][18],
		fallenBlocks[10][17],
		fallenBlocks[10][16],
		fallenBlocks[10][15],
		fallenBlocks[10][14],
		fallenBlocks[10][13],
		fallenBlocks[10][12],
		fallenBlocks[10][11],
		fallenBlocks[10][10],
		fallenBlocks[10][9],
		fallenBlocks[10][8],
		fallenBlocks[10][7],
		fallenBlocks[10][6],
		fallenBlocks[10][5],
		fallenBlocks[10][4],
		fallenBlocks[10][3],
		fallenBlocks[10][2],
		fallenBlocks[10][1],
		fallenBlocks[10][0],
		
		fallenBlocks[9][22],
		fallenBlocks[9][21],
		fallenBlocks[9][20],
		fallenBlocks[9][19],
		fallenBlocks[9][18],
		fallenBlocks[9][17],
		fallenBlocks[9][16],
		fallenBlocks[9][15],
		fallenBlocks[9][14],
		fallenBlocks[9][13],
		fallenBlocks[9][12],
		fallenBlocks[9][11],
		fallenBlocks[9][10],
		fallenBlocks[9][9],
		fallenBlocks[9][8],
		fallenBlocks[9][7],
		fallenBlocks[9][6],
		fallenBlocks[9][5],
		fallenBlocks[9][4],
		fallenBlocks[9][3],
		fallenBlocks[9][2],
		fallenBlocks[9][1],
		fallenBlocks[9][0],
		
		fallenBlocks[8][22],
		fallenBlocks[8][21],
		fallenBlocks[8][20],
		fallenBlocks[8][19],
		fallenBlocks[8][18],
		fallenBlocks[8][17],
		fallenBlocks[8][16],
		fallenBlocks[8][15],
		fallenBlocks[8][14],
		fallenBlocks[8][13],
		fallenBlocks[8][12],
		fallenBlocks[8][11],
		fallenBlocks[8][10],
		fallenBlocks[8][9],
		fallenBlocks[8][8],
		fallenBlocks[8][7],
		fallenBlocks[8][6],
		fallenBlocks[8][5],
		fallenBlocks[8][4],
		fallenBlocks[8][3],
		fallenBlocks[8][2],
		fallenBlocks[8][1],
		fallenBlocks[8][0],
		
		fallenBlocks[7][22],
		fallenBlocks[7][21],
		fallenBlocks[7][20],
		fallenBlocks[7][19],
		fallenBlocks[7][18],
		fallenBlocks[7][17],
		fallenBlocks[7][16],
		fallenBlocks[7][15],
		fallenBlocks[7][14],
		fallenBlocks[7][13],
		fallenBlocks[7][12],
		fallenBlocks[7][11],
		fallenBlocks[7][10],
		fallenBlocks[7][9],
		fallenBlocks[7][8],
		fallenBlocks[7][7],
		fallenBlocks[7][6],
		fallenBlocks[7][5],
		fallenBlocks[7][4],
		fallenBlocks[7][3],
		fallenBlocks[7][2],
		fallenBlocks[7][1],
		fallenBlocks[7][0],
		
		fallenBlocks[6][22],
		fallenBlocks[6][21],
		fallenBlocks[6][20],
		fallenBlocks[6][19],
		fallenBlocks[6][18],
		fallenBlocks[6][17],
		fallenBlocks[6][16],
		fallenBlocks[6][15],
		fallenBlocks[6][14],
		fallenBlocks[6][13],
		fallenBlocks[6][12],
		fallenBlocks[6][11],
		fallenBlocks[6][10],
		fallenBlocks[6][9],
		fallenBlocks[6][8],
		fallenBlocks[6][7],
		fallenBlocks[6][6],
		fallenBlocks[6][5],
		fallenBlocks[6][4],
		fallenBlocks[6][3],
		fallenBlocks[6][2],
		fallenBlocks[6][1],
		fallenBlocks[6][0],
		
		fallenBlocks[5][22],
		fallenBlocks[5][21],
		fallenBlocks[5][20],
		fallenBlocks[5][19],
		fallenBlocks[5][18],
		fallenBlocks[5][17],
		fallenBlocks[5][16],
		fallenBlocks[5][15],
		fallenBlocks[5][14],
		fallenBlocks[5][13],
		fallenBlocks[5][12],
		fallenBlocks[5][11],
		fallenBlocks[5][10],
		fallenBlocks[5][9],
		fallenBlocks[5][8],
		fallenBlocks[5][7],
		fallenBlocks[5][6],
		fallenBlocks[5][5],
		fallenBlocks[5][4],
		fallenBlocks[5][3],
		fallenBlocks[5][2],
		fallenBlocks[5][1],
		fallenBlocks[5][0],
		
		fallenBlocks[4][22],
		fallenBlocks[4][21],
		fallenBlocks[4][20],
		fallenBlocks[4][19],
		fallenBlocks[4][18],
		fallenBlocks[4][17],
		fallenBlocks[4][16],
		fallenBlocks[4][15],
		fallenBlocks[4][14],
		fallenBlocks[4][13],
		fallenBlocks[4][12],
		fallenBlocks[4][11],
		fallenBlocks[4][10],
		fallenBlocks[4][9],
		fallenBlocks[4][8],
		fallenBlocks[4][7],
		fallenBlocks[4][6],
		fallenBlocks[4][5],
		fallenBlocks[4][4],
		fallenBlocks[4][3],
		fallenBlocks[4][2],
		fallenBlocks[4][1],
		fallenBlocks[4][0],
		
		fallenBlocks[3][22],
		fallenBlocks[3][21],
		fallenBlocks[3][20],
		fallenBlocks[3][19],
		fallenBlocks[3][18],
		fallenBlocks[3][17],
		fallenBlocks[3][16],
		fallenBlocks[3][15],
		fallenBlocks[3][14],
		fallenBlocks[3][13],
		fallenBlocks[3][12],
		fallenBlocks[3][11],
		fallenBlocks[3][10],
		fallenBlocks[3][9],
		fallenBlocks[3][8],
		fallenBlocks[3][7],
		fallenBlocks[3][6],
		fallenBlocks[3][5],
		fallenBlocks[3][4],
		fallenBlocks[3][3],
		fallenBlocks[3][2],
		fallenBlocks[3][1],
		fallenBlocks[3][0],
		
		fallenBlocks[2][22],
		fallenBlocks[2][21],
		fallenBlocks[2][20],
		fallenBlocks[2][19],
		fallenBlocks[2][18],
		fallenBlocks[2][17],
		fallenBlocks[2][16],
		fallenBlocks[2][15],
		fallenBlocks[2][14],
		fallenBlocks[2][13],
		fallenBlocks[2][12],
		fallenBlocks[2][11],
		fallenBlocks[2][10],
		fallenBlocks[2][9],
		fallenBlocks[2][8],
		fallenBlocks[2][7],
		fallenBlocks[2][6],
		fallenBlocks[2][5],
		fallenBlocks[2][4],
		fallenBlocks[2][3],
		fallenBlocks[2][2],
		fallenBlocks[2][1],
		fallenBlocks[2][0],
		
		fallenBlocks[1][22],
		fallenBlocks[1][21],
		fallenBlocks[1][20],
		fallenBlocks[1][19],
		fallenBlocks[1][18],
		fallenBlocks[1][17],
		fallenBlocks[1][16],
		fallenBlocks[1][15],
		fallenBlocks[1][14],
		fallenBlocks[1][13],
		fallenBlocks[1][12],
		fallenBlocks[1][11],
		fallenBlocks[1][10],
		fallenBlocks[1][9],
		fallenBlocks[1][8],
		fallenBlocks[1][7],
		fallenBlocks[1][6],
		fallenBlocks[1][5],
		fallenBlocks[1][4],
		fallenBlocks[1][3],
		fallenBlocks[1][2],
		fallenBlocks[1][1],
		fallenBlocks[1][0],
		
		fallenBlocks[0][22],
		fallenBlocks[0][21],
		fallenBlocks[0][20],
		fallenBlocks[0][19],
		fallenBlocks[0][18],
		fallenBlocks[0][17],
		fallenBlocks[0][16],
		fallenBlocks[0][15],
		fallenBlocks[0][14],
		fallenBlocks[0][13],
		fallenBlocks[0][12],
		fallenBlocks[0][11],
		fallenBlocks[0][10],
		fallenBlocks[0][9],
		fallenBlocks[0][8],
		fallenBlocks[0][7],
		fallenBlocks[0][6],
		fallenBlocks[0][5],
		fallenBlocks[0][4],
		fallenBlocks[0][3],
		fallenBlocks[0][2],
		fallenBlocks[0][1],
		fallenBlocks[0][0]
		};
	
	
	// decode iFallingBlocks
	wire[4:0] fallingBlocks[0:3][0:1];  // Coordinates in the form fallingBlocks[block_#][row_or_col]
	genvar i, j;
	generate
		for (i = 0; i < 4; i = i + 1) begin: loop2
			for (j = 0; j < 2; j = j + 1) begin: loop3
				// index = (i * 10) + (j * 5)
				
				assign fallingBlocks[i][j] = iFallingBlocks[(((i * 10) + (j * 5)) + 4):((i * 10) + (j * 5))];
			end
		end
	endgenerate
	
	
	// register logic
	integer k, l;
	always@(posedge clk) begin
		if (iReset) begin
			oRowIndex 	  <= 0;
			oScore 		  <= 0;
			oFilledRows   <= 0;
			
			for (k = 0; k < 12; k = k + 1) begin: loop4
				for (l = 0; l < 23; l = l + 1) begin: loop5
					fallenBlocks[k][l] <= 0;
				end
			end
		end else if (iEn) begin
			if (iResetRowIndex) oRowIndex <= 21;
			
			if (iZeroFilledRows) oFilledRows <= 0;
			
			if (iConvertFallingBlocks) begin
				for (k = 0; k < 4; k = k + 1) begin: loop6
					fallenBlocks[fallingBlocks[k][0]][fallingBlocks[k][1]] <= iPieceType;
				end
			end
			
			if (iMoveRowDown) begin
				for (k = 1; k < 11; k = k + 1) begin: loop7
					fallenBlocks[k][oRowIndex + oFilledRows] <= fallenBlocks[k][oRowIndex];
				end
			end
			
			if (iIncreaseScore) oScore <= oScore + iScoreIncreaseAmount;
			
			if (iIncrementFilledRows) oFilledRows <= oFilledRows + 1;
			
			if (iDecrementRowIndex) oRowIndex <= oRowIndex - 1;
			
			if (iClearRow) begin
				for (k = 0; k < 4; k = k + 1) begin: loop8
					fallenBlocks[k][oRowIndex] <= 0;
				end
			end
		end
	end
endmodule	
	
	
module convert_to_fallen_top_level(
	input clk,
	input iReset,
	input iEn,
	
	input[39:0] iFallingBlocks,
	input[2:0] iPieceType,
	
	output[827:0] oFallenBlocks,
	output oConvertDone,
	output oNextPiece,
	output[17:0] oScore,
	output oSound
	);
	
	wire resetRowIndex;
	wire zeroFilledRows;
	wire convertFallingBlocks;
	wire moveRowDown;
	wire increaseScore;
	wire incrementFilledRows;
	wire decrementRowIndex;
	wire clearRow;
	wire[2:0] filledRows;
	wire[5:0] rowIndex;
	
	
	// configureScoreIncreaseAmountIn
	wire[7:0] scoreIncreaseAmount[0:4]; // based on number of rows filled simultaneously
	assign scoreIncreaseAmount[0] = 0;
	assign scoreIncreaseAmount[1] = 10;
	assign scoreIncreaseAmount[2] = 25;
	assign scoreIncreaseAmount[3] = 50;
	assign scoreIncreaseAmount[4] = 90;
	
	reg[7:0] scoreIncreaseAmountIn;
	always@(*) begin
		scoreIncreaseAmountIn = scoreIncreaseAmount[filledRows];
	end
	
	
	// decode oFallenBlocks
	wire[2:0] fallenBlocks[0:11][0:22];
	genvar i, j;
	generate
		for (i = 0; i < 12; i = i + 1) begin: loop9
			for (j = 0; j < 23; j = j + 1) begin: loop10
				// index = (i * 69) + (j * 3);
				
				assign fallenBlocks[i][j] = oFallenBlocks[(((i * 69) + (j * 3)) + 2):((i * 69) + (j * 3))];
			end
		end
	endgenerate 
	
	// configure rows
	reg[10:1] rows[2:21];
	integer k;
	always@(*) begin
		for (k = 2; k < 22; k = k + 1) begin: loop11
			rows[k][1]  = (!(fallenBlocks[1][k]  == 0)) ? 1 : 0;
			rows[k][2]  = (!(fallenBlocks[2][k]  == 0)) ? 1 : 0;
			rows[k][3]  = (!(fallenBlocks[3][k]  == 0)) ? 1 : 0;
			rows[k][4]  = (!(fallenBlocks[4][k]  == 0)) ? 1 : 0;
			rows[k][5]  = (!(fallenBlocks[5][k]  == 0)) ? 1 : 0;
			rows[k][6]  = (!(fallenBlocks[6][k]  == 0)) ? 1 : 0;
			rows[k][7]  = (!(fallenBlocks[7][k]  == 0)) ? 1 : 0;
			rows[k][8]  = (!(fallenBlocks[8][k]  == 0)) ? 1 : 0;
			rows[k][9]  = (!(fallenBlocks[9][k]  == 0)) ? 1 : 0;
			rows[k][10] = (!(fallenBlocks[10][k] == 0)) ? 1 : 0;
		end
	end
	
	// encode rowsIn
	wire[199:0] rowsIn;
	assign rowsIn = {
		rows[21][10],
		rows[21][9],
		rows[21][8],
		rows[21][7],
		rows[21][6],
		rows[21][5],
		rows[21][4],
		rows[21][3],
		rows[21][2],
		rows[21][1],
		
		rows[20][10],
		rows[20][9],
		rows[20][8],
		rows[20][7],
		rows[20][6],
		rows[20][5],
		rows[20][4],
		rows[20][3],
		rows[20][2],
		rows[20][1],
	
		rows[19][10],
		rows[19][9],
		rows[19][8],
		rows[19][7],
		rows[19][6],
		rows[19][5],
		rows[19][4],
		rows[19][3],
		rows[19][2],
		rows[19][1],
		
		rows[18][10],
		rows[18][9],
		rows[18][8],
		rows[18][7],
		rows[18][6],
		rows[18][5],
		rows[18][4],
		rows[18][3],
		rows[18][2],
		rows[18][1],
		
		rows[17][10],
		rows[17][9],
		rows[17][8],
		rows[17][7],
		rows[17][6],
		rows[17][5],
		rows[17][4],
		rows[17][3],
		rows[17][2],
		rows[17][1],
	
		rows[16][10],
		rows[16][9],
		rows[16][8],
		rows[16][7],
		rows[16][6],
		rows[16][5],
		rows[16][4],
		rows[16][3],
		rows[16][2],
		rows[16][1],
		
		rows[15][10],
		rows[15][9],
		rows[15][8],
		rows[15][7],
		rows[15][6],
		rows[15][5],
		rows[15][4],
		rows[15][3],
		rows[15][2],
		rows[15][1],
		
		rows[14][10],
		rows[14][9],
		rows[14][8],
		rows[14][7],
		rows[14][6],
		rows[14][5],
		rows[14][4],
		rows[14][3],
		rows[14][2],
		rows[14][1],
	
		rows[13][10],
		rows[13][9],
		rows[13][8],
		rows[13][7],
		rows[13][6],
		rows[13][5],
		rows[13][4],
		rows[13][3],
		rows[13][2],
		rows[13][1],
		
		rows[12][10],
		rows[12][9],
		rows[12][8],
		rows[12][7],
		rows[12][6],
		rows[12][5],
		rows[12][4],
		rows[12][3],
		rows[12][2],
		rows[12][1],
		
		rows[11][10],
		rows[11][9],
		rows[11][8],
		rows[11][7],
		rows[11][6],
		rows[11][5],
		rows[11][4],
		rows[11][3],
		rows[11][2],
		rows[11][1],
		
		rows[10][10],
		rows[10][9],
		rows[10][8],
		rows[10][7],
		rows[10][6],
		rows[10][5],
		rows[10][4],
		rows[10][3],
		rows[10][2],
		rows[10][1],
		
		rows[9][10],
		rows[9][9],
		rows[9][8],
		rows[9][7],
		rows[9][6],
		rows[9][5],
		rows[9][4],
		rows[9][3],
		rows[9][2],
		rows[9][1],
		
		rows[8][10],
		rows[8][9],
		rows[8][8],
		rows[8][7],
		rows[8][6],
		rows[8][5],
		rows[8][4],
		rows[8][3],
		rows[8][2],
		rows[8][1],
		
		rows[7][10],
		rows[7][9],
		rows[7][8],
		rows[7][7],
		rows[7][6],
		rows[7][5],
		rows[7][4],
		rows[7][3],
		rows[7][2],
		rows[7][1],
		
		rows[6][10],
		rows[6][9],
		rows[6][8],
		rows[6][7],
		rows[6][6],
		rows[6][5],
		rows[6][4],
		rows[6][3],
		rows[6][2],
		rows[6][1],
		
		rows[5][10],
		rows[5][9],
		rows[5][8],
		rows[5][7],
		rows[5][6],
		rows[5][5],
		rows[5][4],
		rows[5][3],
		rows[5][2],
		rows[5][1],
		
		rows[4][10],
		rows[4][9],
		rows[4][8],
		rows[4][7],
		rows[4][6],
		rows[4][5],
		rows[4][4],
		rows[4][3],
		rows[4][2],
		rows[4][1],
		
		rows[3][10],
		rows[3][9],
		rows[3][8],
		rows[3][7],
		rows[3][6],
		rows[3][5],
		rows[3][4],
		rows[3][3],
		rows[3][2],
		rows[3][1],
		
		rows[2][10],
		rows[2][9],
		rows[2][8],
		rows[2][7],
		rows[2][6],
		rows[2][5],
		rows[2][4],
		rows[2][3],
		rows[2][2],
		rows[2][1]
		};
	
	convert_to_fallen_control CTF_control(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
	
		.iFilledRows(filledRows),
		.iRowIndex(rowIndex),
		.iRows(rowsIn),
	
		.oResetRowIndex(resetRowIndex),
		.oZeroFilledRows(zeroFilledRows),
		.oConvertFallingBlocks(convertFallingBlocks),
		.oMoveRowDown(moveRowDown),
		.oIncreaseScore(increaseScore),
		.oIncrementFilledRows(incrementFilledRows),
		.oDecrementRowIndex(decrementRowIndex),
		.oClearRow(clearRow),
	
		.oConvertDone(oConvertDone),
		.oNextPiece(oNextPiece),
		.oSound(oSound)
		);
		
	convert_to_fallen_datapath CTF_datapath(
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
		
		.iScoreIncreaseAmount(scoreIncreaseAmountIn),
		.iFallingBlocks(iFallingBlocks),
		.iPieceType(iPieceType),
		.iResetRowIndex(resetRowIndex),
		.iZeroFilledRows(zeroFilledRows),
		.iConvertFallingBlocks(convertFallingBlocks),
		.iMoveRowDown(moveRowDown),
		.iIncreaseScore(increaseScore),
		.iIncrementFilledRows(incrementFilledRows),
		.iDecrementRowIndex(decrementRowIndex),
		.iClearRow(clearRow),
	
		.oRowIndex(rowIndex),
		.oScore(oScore),
		.oFilledRows(filledRows),
		.oFallenBlocks(oFallenBlocks)
		);
endmodule