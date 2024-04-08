// Written by Nathan Shreve

module draw_control #(
	parameter SCR_WIDTH = 160,
	parameter SCR_HEIGHT = 120
	) (
	input clk,
	input iReset,
	input iEn,
	
	input[10:0] iXIncr,  	 	  // Pixel offset in x direction
	input[10:0] iYIncr,  	 	  // Pixel offset in y direction
	input[4:0] iCol,     	 	  // Current column being checked/drawn
	input[4:0] iRow,     	 	  // Current row being checked/drawn
	input[827:0] iGrid,  	 	  // The current game grid
	input[827:0] iPrevGrid,  	  // The game grid from the previous frame
	
	output reg oResetRow,        // Change row to 2 (not 0, since the grid includes squares that are "out of bounds")
	output reg oResetCol,        // Change column to 1 (not 0, since the grid includes squares that are "out of bounds") 
	output reg oUpdateGrid,      // Load grid from game-logic part of design
	output reg oSetXReg,         // Set x pixel offset to leftmost edge of current position coordinate
	output reg oSetYReg,         // Set y pixel offset to top edge of current position coordinate
	output reg oSetColourReg,    // Set colour to colour of the block at the current position coordinate
	output reg oZeroXIncr,       // Set x pixel offset to 0
	output reg oZeroYIncr,       // Set y pixel offset to 0
	output reg oIncrXIncr,       // Increment x pixel offset
	output reg oIncrYIncr,       // Increment y pixel offset
	output reg oIncrCol,         // Increment column
	output reg oZeroCol,         // Set column to 0
	output reg oIncrRow,         // Increment row
	output reg oUpdatePrevGrid,  // Load grid into prevGrid
	output reg oPlot,            // VGA enable
	
	output reg oFrameDone        // Done drawing frame
	);
	
	localparam SQUARE_SIZE = SCR_HEIGHT / 20;
	localparam LEFT_MARGIN = (SCR_WIDTH / 2) - (SQUARE_SIZE * 5);
			
			
	// decode iGrid
	wire[2:0] grid[0:11][0:22];  // Piece type at position coordinate in the form grid[col][row]
	genvar i, j;
	generate
		for (i = 0; i < 12; i = i + 1) begin: loop1
			for (j = 0; j < 23; j = j + 1) begin: loop2
				// index = (i * 69) + (j * 3);
				
				assign grid[i][j] = iGrid[(((i * 69) + (j * 3)) + 2):((i * 69) + (j * 3))];
			end
		end
	endgenerate
	
	
	// decode iPrevGrid
	wire[2:0] prevGrid[0:11][0:22];  // Piece type at position coordinate in the form prevGrid[col][row]
	generate
		for (i = 0; i < 12; i = i + 1) begin: loop3
			for (j = 0; j < 23; j = j + 1) begin: loop4
				// index = (i * 69) + (j * 3);
				
				assign prevGrid[i][j] = iPrevGrid[(((i * 69) + (j * 3)) + 2):((i * 69) + (j * 3))];
			end
		end
	endgenerate
	
	
	reg[4:0] next_state, current_state;
	
	localparam S_DRAW_1  = 5'd 1,
				  S_DRAW_2  = 5'd 2,
				  S_DRAW_3  = 5'd 3,
				  S_DRAW_4  = 5'd 4,
				  S_DRAW_5  = 5'd 5,
				  S_DRAW_6  = 5'd 6,
				  S_DRAW_7  = 5'd 7,
				  S_DRAW_8  = 5'd 8,
				  S_DRAW_9  = 5'd 9,
				  S_DRAW_10 = 5'd10;
				  
	// state_table
	always@(*)
	begin: state_table
		if (iReset) next_state = S_DRAW_1;
		else if (iEn) begin
			case (current_state)
				S_DRAW_1: next_state = S_DRAW_2;
				
				S_DRAW_2: begin
					if   (grid[iCol][iRow] == prevGrid[iCol][iRow]) next_state = S_DRAW_6;
					else 													 	   next_state = S_DRAW_3;
				end
				
				S_DRAW_3: next_state = S_DRAW_4;
				
				S_DRAW_4: begin
					if      (iXIncr < (SQUARE_SIZE - 1))   											next_state = S_DRAW_4;
					else if ((iXIncr == (SQUARE_SIZE - 1)) & (iYIncr < (SQUARE_SIZE - 1)))  next_state = S_DRAW_5;
					else if ((iXIncr == (SQUARE_SIZE - 1)) & (iYIncr == (SQUARE_SIZE - 1))) next_state = S_DRAW_6;
				end
				
				S_DRAW_5: next_state = S_DRAW_4;
				
				S_DRAW_6: next_state = S_DRAW_7;
				
				S_DRAW_7: begin
					if      ((iCol < 11) & (iRow < 22))  next_state = S_DRAW_2;
					else if ((iCol == 11) & (iRow < 22)) next_state = S_DRAW_8;
					else if (iRow == 22)					  	 next_state = S_DRAW_9;
				end
				
				S_DRAW_8: next_state = S_DRAW_7;
				
				S_DRAW_9: next_state = S_DRAW_10;
				
				S_DRAW_10: next_state = S_DRAW_1;
			endcase
		end
	end // state_table
	
	// output_signals
	always@(*)
	begin: output_signals
		if (iReset) begin
			oResetRow 		 = 0;
			oResetCol 		 = 0;
			oUpdateGrid 	 = 0;
			oSetXReg 		 = 0;
			oSetYReg 		 = 0;
			oSetColourReg	 = 0;
			oZeroXIncr 		 = 0;
			oZeroYIncr 		 = 0;
			oIncrXIncr 		 = 0;
			oIncrYIncr 		 = 0;
			oIncrCol 		 = 0;
			oZeroCol			 = 0;
			oIncrRow 		 = 0;
			oUpdatePrevGrid = 0;
			oPlot				 = 0;
			oFrameDone		 = 0;
		end else if (iEn) begin
			oResetRow 		 = 0;
			oResetCol 		 = 0;
			oUpdateGrid 	 = 0;
			oSetXReg 		 = 0;
			oSetYReg 		 = 0;
			oSetColourReg	 = 0;
			oZeroXIncr 		 = 0;
			oZeroYIncr 		 = 0;
			oIncrXIncr 		 = 0;
			oIncrYIncr 		 = 0;
			oIncrCol 		 = 0;
			oZeroCol			 = 0;
			oIncrRow 		 = 0;
			oUpdatePrevGrid = 0;
			oPlot				 = 0;
			oFrameDone		 = 0;
			
			case (current_state)
				S_DRAW_1: begin
					oResetRow   = 1;
					oResetCol   = 1;
					oUpdateGrid = 1;
				end
				
				S_DRAW_3: begin
					oSetXReg 	  = 1;
					oSetYReg 	  = 1;
					oSetColourReg = 1;
					oZeroXIncr 	  = 1;
					oZeroYIncr 	  = 1;
				end
				
				S_DRAW_4: begin
					oPlot 	  = 1;
					oIncrXIncr = 1;
				end
				
				S_DRAW_5: begin
					oZeroXIncr = 1;
					oIncrYIncr = 1;
				end
				
				S_DRAW_6: oIncrCol = 1;
				
				S_DRAW_8: begin
					oZeroCol = 1;
					oIncrRow = 1;
				end
				
				S_DRAW_9: oUpdatePrevGrid = 1;
				
				S_DRAW_10: oFrameDone = 1;
			endcase
		end
	end // output_signals
	
	// state_FFs
	always@(posedge clk)
   begin: state_FFs
		if (iReset) current_state <= S_DRAW_1;
		else if (iEn) current_state <= next_state;
   end // state_FFs
endmodule

	
module draw_datapath#(
	parameter SCR_WIDTH = 160,
	parameter SCR_HEIGHT = 120
	) (
	input clk,
	input iReset,
	input iEn,
	
	input[39:0] iFallingBlocks,
	input[827:0] iFallenBlocks,
	input[2:0] iPieceType,
	
	input iResetRow,
	input iResetCol,
	input iUpdateGrid,
	input iSetXReg,
	input iSetYReg,
	input iSetColourReg,
	input iZeroXIncr,
	input iZeroYIncr,
	input iIncrXIncr,
	input iIncrYIncr,
	input iIncrCol,
	input iZeroCol,
	input iIncrRow,
	input iUpdatePrevGrid,
	
	output reg[10:0] oXIncr,
	output reg[10:0] oYIncr,
	output reg[4:0] oCol,
	output reg[4:0] oRow,
	output[827:0] oGrid,
	output[827:0] oPrevGrid,
	output[10:0] oX,
	output[10:0] oY,
	output[2:0] oColour
	);
	
	localparam SQUARE_SIZE = SCR_HEIGHT / 20;
	localparam LEFT_MARGIN = (SCR_WIDTH / 2) - (SQUARE_SIZE * 5);
	
	reg[10:0] xReg;
	reg[10:0] yReg;
	reg[2:0] colourReg;
	
	assign oX = xReg + oXIncr;
	assign oY = yReg + oYIncr;
	assign oColour = colourReg;
	
	
	// decode iFallingBlocks
	wire[4:0] fallingBlocks[0:3][0:1];
	genvar i, j;
	generate
		for (i = 0; i < 4; i = i + 1) begin: loop5
			for (j = 0; j < 2; j = j + 1) begin: loop6
				// index = (i * 10) + (j * 5)
				
				assign fallingBlocks[i][j] = iFallingBlocks[(((i * 10) + (j * 5)) + 4):((i * 10) + (j * 5))];
			end
		end
	endgenerate
	
	
	// decode fallenBlocks
	wire[2:0] fallenBlocks[0:11][0:22];
	generate
		for (i = 0; i < 12; i = i + 1) begin: loop7
			for (j = 0; j < 23; j = j + 1) begin: loop8
				// index = (i * 69) + (j * 3);
				
				assign fallenBlocks[i][j] = iFallenBlocks[(((i * 69) + (j * 3)) + 2):((i * 69) + (j * 3))];
			end
		end
	endgenerate
	
	
	// encode oGrid
	reg[2:0] grid[0:11][0:22];
	assign oGrid = {
		grid[11][22],
		grid[11][21],
		grid[11][20],
		grid[11][19],
		grid[11][18],
		grid[11][17],
		grid[11][16],
		grid[11][15],
		grid[11][14],
		grid[11][13],
		grid[11][12],
		grid[11][11],
		grid[11][10],
		grid[11][9],
		grid[11][8],
		grid[11][7],
		grid[11][6],
		grid[11][5],
		grid[11][4],
		grid[11][3],
		grid[11][2],
		grid[11][1],
		grid[11][0],
		
		grid[10][22],
		grid[10][21],
		grid[10][20],
		grid[10][19],
		grid[10][18],
		grid[10][17],
		grid[10][16],
		grid[10][15],
		grid[10][14],
		grid[10][13],
		grid[10][12],
		grid[10][11],
		grid[10][10],
		grid[10][9],
		grid[10][8],
		grid[10][7],
		grid[10][6],
		grid[10][5],
		grid[10][4],
		grid[10][3],
		grid[10][2],
		grid[10][1],
		grid[10][0],
		
		grid[9][22],
		grid[9][21],
		grid[9][20],
		grid[9][19],
		grid[9][18],
		grid[9][17],
		grid[9][16],
		grid[9][15],
		grid[9][14],
		grid[9][13],
		grid[9][12],
		grid[9][11],
		grid[9][10],
		grid[9][9],
		grid[9][8],
		grid[9][7],
		grid[9][6],
		grid[9][5],
		grid[9][4],
		grid[9][3],
		grid[9][2],
		grid[9][1],
		grid[9][0],
		
		grid[8][22],
		grid[8][21],
		grid[8][20],
		grid[8][19],
		grid[8][18],
		grid[8][17],
		grid[8][16],
		grid[8][15],
		grid[8][14],
		grid[8][13],
		grid[8][12],
		grid[8][11],
		grid[8][10],
		grid[8][9],
		grid[8][8],
		grid[8][7],
		grid[8][6],
		grid[8][5],
		grid[8][4],
		grid[8][3],
		grid[8][2],
		grid[8][1],
		grid[8][0],
		
		grid[7][22],
		grid[7][21],
		grid[7][20],
		grid[7][19],
		grid[7][18],
		grid[7][17],
		grid[7][16],
		grid[7][15],
		grid[7][14],
		grid[7][13],
		grid[7][12],
		grid[7][11],
		grid[7][10],
		grid[7][9],
		grid[7][8],
		grid[7][7],
		grid[7][6],
		grid[7][5],
		grid[7][4],
		grid[7][3],
		grid[7][2],
		grid[7][1],
		grid[7][0],
		
		grid[6][22],
		grid[6][21],
		grid[6][20],
		grid[6][19],
		grid[6][18],
		grid[6][17],
		grid[6][16],
		grid[6][15],
		grid[6][14],
		grid[6][13],
		grid[6][12],
		grid[6][11],
		grid[6][10],
		grid[6][9],
		grid[6][8],
		grid[6][7],
		grid[6][6],
		grid[6][5],
		grid[6][4],
		grid[6][3],
		grid[6][2],
		grid[6][1],
		grid[6][0],
		
		grid[5][22],
		grid[5][21],
		grid[5][20],
		grid[5][19],
		grid[5][18],
		grid[5][17],
		grid[5][16],
		grid[5][15],
		grid[5][14],
		grid[5][13],
		grid[5][12],
		grid[5][11],
		grid[5][10],
		grid[5][9],
		grid[5][8],
		grid[5][7],
		grid[5][6],
		grid[5][5],
		grid[5][4],
		grid[5][3],
		grid[5][2],
		grid[5][1],
		grid[5][0],
		
		grid[4][22],
		grid[4][21],
		grid[4][20],
		grid[4][19],
		grid[4][18],
		grid[4][17],
		grid[4][16],
		grid[4][15],
		grid[4][14],
		grid[4][13],
		grid[4][12],
		grid[4][11],
		grid[4][10],
		grid[4][9],
		grid[4][8],
		grid[4][7],
		grid[4][6],
		grid[4][5],
		grid[4][4],
		grid[4][3],
		grid[4][2],
		grid[4][1],
		grid[4][0],
		
		grid[3][22],
		grid[3][21],
		grid[3][20],
		grid[3][19],
		grid[3][18],
		grid[3][17],
		grid[3][16],
		grid[3][15],
		grid[3][14],
		grid[3][13],
		grid[3][12],
		grid[3][11],
		grid[3][10],
		grid[3][9],
		grid[3][8],
		grid[3][7],
		grid[3][6],
		grid[3][5],
		grid[3][4],
		grid[3][3],
		grid[3][2],
		grid[3][1],
		grid[3][0],
		
		grid[2][22],
		grid[2][21],
		grid[2][20],
		grid[2][19],
		grid[2][18],
		grid[2][17],
		grid[2][16],
		grid[2][15],
		grid[2][14],
		grid[2][13],
		grid[2][12],
		grid[2][11],
		grid[2][10],
		grid[2][9],
		grid[2][8],
		grid[2][7],
		grid[2][6],
		grid[2][5],
		grid[2][4],
		grid[2][3],
		grid[2][2],
		grid[2][1],
		grid[2][0],
		
		grid[1][22],
		grid[1][21],
		grid[1][20],
		grid[1][19],
		grid[1][18],
		grid[1][17],
		grid[1][16],
		grid[1][15],
		grid[1][14],
		grid[1][13],
		grid[1][12],
		grid[1][11],
		grid[1][10],
		grid[1][9],
		grid[1][8],
		grid[1][7],
		grid[1][6],
		grid[1][5],
		grid[1][4],
		grid[1][3],
		grid[1][2],
		grid[1][1],
		grid[1][0],
		
		grid[0][22],
		grid[0][21],
		grid[0][20],
		grid[0][19],
		grid[0][18],
		grid[0][17],
		grid[0][16],
		grid[0][15],
		grid[0][14],
		grid[0][13],
		grid[0][12],
		grid[0][11],
		grid[0][10],
		grid[0][9],
		grid[0][8],
		grid[0][7],
		grid[0][6],
		grid[0][5],
		grid[0][4],
		grid[0][3],
		grid[0][2],
		grid[0][1],
		grid[0][0]
		};
		
		
	// encode oPrevGrid
	reg[2:0] prevGrid[0:11][0:22];
	assign oPrevGrid = {
		prevGrid[11][22],
		prevGrid[11][21],
		prevGrid[11][20],
		prevGrid[11][19],
		prevGrid[11][18],
		prevGrid[11][17],
		prevGrid[11][16],
		prevGrid[11][15],
		prevGrid[11][14],
		prevGrid[11][13],
		prevGrid[11][12],
		prevGrid[11][11],
		prevGrid[11][10],
		prevGrid[11][9],
		prevGrid[11][8],
		prevGrid[11][7],
		prevGrid[11][6],
		prevGrid[11][5],
		prevGrid[11][4],
		prevGrid[11][3],
		prevGrid[11][2],
		prevGrid[11][1],
		prevGrid[11][0],
		
		prevGrid[10][22],
		prevGrid[10][21],
		prevGrid[10][20],
		prevGrid[10][19],
		prevGrid[10][18],
		prevGrid[10][17],
		prevGrid[10][16],
		prevGrid[10][15],
		prevGrid[10][14],
		prevGrid[10][13],
		prevGrid[10][12],
		prevGrid[10][11],
		prevGrid[10][10],
		prevGrid[10][9],
		prevGrid[10][8],
		prevGrid[10][7],
		prevGrid[10][6],
		prevGrid[10][5],
		prevGrid[10][4],
		prevGrid[10][3],
		prevGrid[10][2],
		prevGrid[10][1],
		prevGrid[10][0],
		
		prevGrid[9][22],
		prevGrid[9][21],
		prevGrid[9][20],
		prevGrid[9][19],
		prevGrid[9][18],
		prevGrid[9][17],
		prevGrid[9][16],
		prevGrid[9][15],
		prevGrid[9][14],
		prevGrid[9][13],
		prevGrid[9][12],
		prevGrid[9][11],
		prevGrid[9][10],
		prevGrid[9][9],
		prevGrid[9][8],
		prevGrid[9][7],
		prevGrid[9][6],
		prevGrid[9][5],
		prevGrid[9][4],
		prevGrid[9][3],
		prevGrid[9][2],
		prevGrid[9][1],
		prevGrid[9][0],
		
		prevGrid[8][22],
		prevGrid[8][21],
		prevGrid[8][20],
		prevGrid[8][19],
		prevGrid[8][18],
		prevGrid[8][17],
		prevGrid[8][16],
		prevGrid[8][15],
		prevGrid[8][14],
		prevGrid[8][13],
		prevGrid[8][12],
		prevGrid[8][11],
		prevGrid[8][10],
		prevGrid[8][9],
		prevGrid[8][8],
		prevGrid[8][7],
		prevGrid[8][6],
		prevGrid[8][5],
		prevGrid[8][4],
		prevGrid[8][3],
		prevGrid[8][2],
		prevGrid[8][1],
		prevGrid[8][0],
		
		prevGrid[7][22],
		prevGrid[7][21],
		prevGrid[7][20],
		prevGrid[7][19],
		prevGrid[7][18],
		prevGrid[7][17],
		prevGrid[7][16],
		prevGrid[7][15],
		prevGrid[7][14],
		prevGrid[7][13],
		prevGrid[7][12],
		prevGrid[7][11],
		prevGrid[7][10],
		prevGrid[7][9],
		prevGrid[7][8],
		prevGrid[7][7],
		prevGrid[7][6],
		prevGrid[7][5],
		prevGrid[7][4],
		prevGrid[7][3],
		prevGrid[7][2],
		prevGrid[7][1],
		prevGrid[7][0],
		
		prevGrid[6][22],
		prevGrid[6][21],
		prevGrid[6][20],
		prevGrid[6][19],
		prevGrid[6][18],
		prevGrid[6][17],
		prevGrid[6][16],
		prevGrid[6][15],
		prevGrid[6][14],
		prevGrid[6][13],
		prevGrid[6][12],
		prevGrid[6][11],
		prevGrid[6][10],
		prevGrid[6][9],
		prevGrid[6][8],
		prevGrid[6][7],
		prevGrid[6][6],
		prevGrid[6][5],
		prevGrid[6][4],
		prevGrid[6][3],
		prevGrid[6][2],
		prevGrid[6][1],
		prevGrid[6][0],
		
		prevGrid[5][22],
		prevGrid[5][21],
		prevGrid[5][20],
		prevGrid[5][19],
		prevGrid[5][18],
		prevGrid[5][17],
		prevGrid[5][16],
		prevGrid[5][15],
		prevGrid[5][14],
		prevGrid[5][13],
		prevGrid[5][12],
		prevGrid[5][11],
		prevGrid[5][10],
		prevGrid[5][9],
		prevGrid[5][8],
		prevGrid[5][7],
		prevGrid[5][6],
		prevGrid[5][5],
		prevGrid[5][4],
		prevGrid[5][3],
		prevGrid[5][2],
		prevGrid[5][1],
		prevGrid[5][0],
		
		prevGrid[4][22],
		prevGrid[4][21],
		prevGrid[4][20],
		prevGrid[4][19],
		prevGrid[4][18],
		prevGrid[4][17],
		prevGrid[4][16],
		prevGrid[4][15],
		prevGrid[4][14],
		prevGrid[4][13],
		prevGrid[4][12],
		prevGrid[4][11],
		prevGrid[4][10],
		prevGrid[4][9],
		prevGrid[4][8],
		prevGrid[4][7],
		prevGrid[4][6],
		prevGrid[4][5],
		prevGrid[4][4],
		prevGrid[4][3],
		prevGrid[4][2],
		prevGrid[4][1],
		prevGrid[4][0],
		
		prevGrid[3][22],
		prevGrid[3][21],
		prevGrid[3][20],
		prevGrid[3][19],
		prevGrid[3][18],
		prevGrid[3][17],
		prevGrid[3][16],
		prevGrid[3][15],
		prevGrid[3][14],
		prevGrid[3][13],
		prevGrid[3][12],
		prevGrid[3][11],
		prevGrid[3][10],
		prevGrid[3][9],
		prevGrid[3][8],
		prevGrid[3][7],
		prevGrid[3][6],
		prevGrid[3][5],
		prevGrid[3][4],
		prevGrid[3][3],
		prevGrid[3][2],
		prevGrid[3][1],
		prevGrid[3][0],
		
		prevGrid[2][22],
		prevGrid[2][21],
		prevGrid[2][20],
		prevGrid[2][19],
		prevGrid[2][18],
		prevGrid[2][17],
		prevGrid[2][16],
		prevGrid[2][15],
		prevGrid[2][14],
		prevGrid[2][13],
		prevGrid[2][12],
		prevGrid[2][11],
		prevGrid[2][10],
		prevGrid[2][9],
		prevGrid[2][8],
		prevGrid[2][7],
		prevGrid[2][6],
		prevGrid[2][5],
		prevGrid[2][4],
		prevGrid[2][3],
		prevGrid[2][2],
		prevGrid[2][1],
		prevGrid[2][0],
		
		prevGrid[1][22],
		prevGrid[1][21],
		prevGrid[1][20],
		prevGrid[1][19],
		prevGrid[1][18],
		prevGrid[1][17],
		prevGrid[1][16],
		prevGrid[1][15],
		prevGrid[1][14],
		prevGrid[1][13],
		prevGrid[1][12],
		prevGrid[1][11],
		prevGrid[1][10],
		prevGrid[1][9],
		prevGrid[1][8],
		prevGrid[1][7],
		prevGrid[1][6],
		prevGrid[1][5],
		prevGrid[1][4],
		prevGrid[1][3],
		prevGrid[1][2],
		prevGrid[1][1],
		prevGrid[1][0],
		
		prevGrid[0][22],
		prevGrid[0][21],
		prevGrid[0][20],
		prevGrid[0][19],
		prevGrid[0][18],
		prevGrid[0][17],
		prevGrid[0][16],
		prevGrid[0][15],
		prevGrid[0][14],
		prevGrid[0][13],
		prevGrid[0][12],
		prevGrid[0][11],
		prevGrid[0][10],
		prevGrid[0][9],
		prevGrid[0][8],
		prevGrid[0][7],
		prevGrid[0][6],
		prevGrid[0][5],
		prevGrid[0][4],
		prevGrid[0][3],
		prevGrid[0][2],
		prevGrid[0][1],
		prevGrid[0][0]
		};
		
	// get pieceColours from globals
	wire[20:0] pieceColoursOut;
	globals constants(
		.pieceColours(pieceColoursOut)
		);
	
	wire[2:0] pieceColours[0:7];
	assign pieceColours[0] = 0;
	generate
		for (i = 1; i < 8; i = i + 1) begin: loop9
			// index = (i - 1) * 3
			
			assign pieceColours[i] = pieceColoursOut[(((i - 1) * 3) + 2):((i - 1) * 3)];
		end
	endgenerate
	
	// register logic
	integer k, l;
	always@(posedge clk) begin
		if (iReset) begin
			oXIncr 	 <= 0;
			oYIncr 	 <= 0;
			oCol 		 <= 0;
			oRow 		 <= 0;
			xReg 		 <= 0;
			yReg 		 <= 0;
			colourReg <= 0;
			
			for (k = 0; k < 12; k = k + 1) begin: loop10
				for (l = 0; l < 23; l = l + 1) begin: loop11
					grid[k][l] 		<= 0;
					prevGrid[k][l] <= 3'b111;
				end
			end
		end else if (iEn) begin
			if (iResetRow) oRow <= 2;
			
			if (iResetCol) oCol <= 1;
			
			if (iUpdateGrid) begin
				for (l = 0; l < 23; l = l + 1) begin: loop12
					for (k = 0; k < 12; k = k + 1) begin: loop13
						grid[k][l] <= fallenBlocks[k][l];
					end
				end
				
				for (k = 0; k < 4; k = k + 1) begin: loop14
					grid[fallingBlocks[k][0]][fallingBlocks[k][1]] <= iPieceType;
				end
			end
			
			if (iSetXReg) xReg <= LEFT_MARGIN + ((oCol - 1) * SQUARE_SIZE);
			
			if (iSetYReg) yReg <= (oRow - 2) * SQUARE_SIZE;
			
			if (iSetColourReg) colourReg <= pieceColours[grid[oCol][oRow]];
	
			if (iZeroXIncr) oXIncr <= 0;
			
			if (iZeroYIncr) oYIncr <= 0;
			
			if (iIncrXIncr) oXIncr <= oXIncr + 1;
			
			if (iIncrYIncr) oYIncr <= oYIncr + 1;
			
			if (iIncrCol) oCol <= oCol + 1;
			
			if (iZeroCol) oCol <= 0;
			
			if (iIncrRow) oRow <= oRow + 1;
			
			if (iUpdatePrevGrid) begin
				for (k = 0; k < 12; k = k + 1) begin: loop15
					for (l = 0; l < 23; l = l + 1) begin: loop16
						prevGrid[k][l] <= grid[k][l];
					end
				end
			end
		end
	end
endmodule
	
module draw #( // draw changes to VGA
	parameter SCR_WIDTH = 160,
	parameter SCR_HEIGHT = 120
	)(
	input clk,
	input iReset,
	input iEn,
	
	input[39:0] iFallingBlocks,
	input[827:0] iFallenBlocks,
	input[2:0] iPieceType,
	
	output oFrameDone,
	output oPlot,
	output[10:0] oX,
	output[10:0] oY,
	output[2:0] oColour
	);
	
	wire[10:0] xIncr;
	wire[10:0] yIncr;
	wire[4:0] col;
	wire[4:0] row;
	wire[827:0] grid;
	wire[827:0] prevGrid;
	wire resetRow;
	wire resetCol;
	wire updateGrid;
	wire setXReg;
	wire setYReg;
	wire setColourReg;
	wire zeroXIncr;
	wire zeroYIncr;
	wire incrXIncr;
	wire incrYIncr;
	wire incrCol;
	wire zeroCol;
	wire incrRow;
	wire updatePrevGrid;
	
	draw_control #(
		.SCR_WIDTH(SCR_WIDTH),
		.SCR_HEIGHT(SCR_HEIGHT)
		) DRAW_control (
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
	
		.iXIncr(xIncr),
		.iYIncr(yIncr),
		.iCol(col),
		.iRow(row),
		.iGrid(grid),
		.iPrevGrid(prevGrid),
	
		.oResetRow(resetRow),
		.oResetCol(resetCol),
		.oUpdateGrid(updateGrid),
		.oSetXReg(setXReg),
		.oSetYReg(setYReg),
		.oSetColourReg(setColourReg),
		.oZeroXIncr(zeroXIncr),
		.oZeroYIncr(zeroYIncr),
		.oIncrXIncr(incrXIncr),
		.oIncrYIncr(incrYIncr),
		.oIncrCol(incrCol),
		.oZeroCol(zeroCol),
		.oIncrRow(incrRow),
		.oUpdatePrevGrid(updatePrevGrid),
		.oPlot(oPlot),
		
		.oFrameDone(oFrameDone)
		);
		
	draw_datapath #(
		.SCR_WIDTH(SCR_WIDTH),
		.SCR_HEIGHT(SCR_HEIGHT)
		) DRAW_datapath (
		.clk(clk),
		.iReset(iReset),
		.iEn(iEn),
		
		.iFallingBlocks(iFallingBlocks),
		.iFallenBlocks(iFallenBlocks),
		.iPieceType(iPieceType),
	
		.iResetRow(resetRow),
		.iResetCol(resetCol),
		.iUpdateGrid(updateGrid),
		.iSetXReg(setXReg),
		.iSetYReg(setYReg),
		.iSetColourReg(setColourReg),
		.iZeroXIncr(zeroXIncr),
		.iZeroYIncr(zeroYIncr),
		.iIncrXIncr(incrXIncr),
		.iIncrYIncr(incrYIncr),
		.iIncrCol(incrCol),
		.iZeroCol(zeroCol),
		.iIncrRow(incrRow),
		.iUpdatePrevGrid(updatePrevGrid),
	
		.oXIncr(xIncr),
		.oYIncr(yIncr),
		.oCol(col),
		.oRow(row),
		.oGrid(grid),
		.oPrevGrid(prevGrid),
		.oX(oX),
		.oY(oY),
		.oColour(oColour)
		);
endmodule