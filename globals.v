// Written by Nathan Shreve

module globals(  // block- and piece-type constants
	output[223:0] offsets_col,
	output[223:0] offsets_row,

	output[20:0] pieceColours,
	
	output[55:0] rightmostColumns,
	output[55:0] leftmostColumns,
	output[55:0] bottomRows
	);
	
	// offsets are in the format:
	// 	offsets[piece type][orientation][block index][dimension]
	
	// rightmostColumn, leftmostColumn, bottomRow are in the format:
	// 	rightmostColumn[piece type][orientation]
	
	
	// O block
	
	wire[2:0] pieceColours1;
	
	// Rotation 0
	wire[1:0] offsets_1_0_0_col;
	wire[1:0] offsets_1_0_0_row;
	wire[1:0] offsets_1_0_1_col;
	wire[1:0] offsets_1_0_1_row;
	wire[1:0] offsets_1_0_2_col;
	wire[1:0] offsets_1_0_2_row;
	wire[1:0] offsets_1_0_3_col;
	wire[1:0] offsets_1_0_3_row;
	
	wire[1:0] rightmostColumn_1_0;
	wire[1:0] leftmostColumn_1_0;
	wire[1:0] bottomRow_1_0;
	
	// Rotation 1
	wire[1:0] offsets_1_1_0_col;
	wire[1:0] offsets_1_1_0_row;
	wire[1:0] offsets_1_1_1_col;
	wire[1:0] offsets_1_1_1_row;
	wire[1:0] offsets_1_1_2_col;
	wire[1:0] offsets_1_1_2_row;
	wire[1:0] offsets_1_1_3_col;
	wire[1:0] offsets_1_1_3_row;
	
	wire[1:0] rightmostColumn_1_1;
	wire[1:0] leftmostColumn_1_1;
	wire[1:0] bottomRow_1_1;
	
	// Rotation 2
	wire[1:0] offsets_1_2_0_col;
	wire[1:0] offsets_1_2_0_row;
	wire[1:0] offsets_1_2_1_col;
	wire[1:0] offsets_1_2_1_row;
	wire[1:0] offsets_1_2_2_col;
	wire[1:0] offsets_1_2_2_row;
	wire[1:0] offsets_1_2_3_col;
	wire[1:0] offsets_1_2_3_row;
	
	wire[1:0] rightmostColumn_1_2;
	wire[1:0] leftmostColumn_1_2;
	wire[1:0] bottomRow_1_2;
	
	// Rotation 3
	wire[1:0] offsets_1_3_0_col;
	wire[1:0] offsets_1_3_0_row;
	wire[1:0] offsets_1_3_1_col;
	wire[1:0] offsets_1_3_1_row;
	wire[1:0] offsets_1_3_2_col;
	wire[1:0] offsets_1_3_2_row;
	wire[1:0] offsets_1_3_3_col;
	wire[1:0] offsets_1_3_3_row;
	
	wire[1:0] rightmostColumn_1_3;
	wire[1:0] leftmostColumn_1_3;
	wire[1:0] bottomRow_1_3;
	
	
	// I block
	
	wire[2:0] pieceColours2;
	
	// Rotation 0
	wire[1:0] offsets_2_0_0_col;
	wire[1:0] offsets_2_0_0_row;
	wire[1:0] offsets_2_0_1_col;
	wire[1:0] offsets_2_0_1_row;
	wire[1:0] offsets_2_0_2_col;
	wire[1:0] offsets_2_0_2_row;
	wire[1:0] offsets_2_0_3_col;
	wire[1:0] offsets_2_0_3_row;
	
	wire[1:0] rightmostColumn_2_0;
	wire[1:0] leftmostColumn_2_0;
	wire[1:0] bottomRow_2_0;
	
	// Rotation 1
	wire[1:0] offsets_2_1_0_col;
	wire[1:0] offsets_2_1_0_row;
	wire[1:0] offsets_2_1_1_col;
	wire[1:0] offsets_2_1_1_row;
	wire[1:0] offsets_2_1_2_col;
	wire[1:0] offsets_2_1_2_row;
	wire[1:0] offsets_2_1_3_col;
	wire[1:0] offsets_2_1_3_row;
	
	wire[1:0] rightmostColumn_2_1;
	wire[1:0] leftmostColumn_2_1;
	wire[1:0] bottomRow_2_1;
	
	// Rotation 2
	wire[1:0] offsets_2_2_0_col;
	wire[1:0] offsets_2_2_0_row;
	wire[1:0] offsets_2_2_1_col;
	wire[1:0] offsets_2_2_1_row;
	wire[1:0] offsets_2_2_2_col;
	wire[1:0] offsets_2_2_2_row;
	wire[1:0] offsets_2_2_3_col;
	wire[1:0] offsets_2_2_3_row;
	
	wire[1:0] rightmostColumn_2_2;
	wire[1:0] leftmostColumn_2_2;
	wire[1:0] bottomRow_2_2;

	// Rotation 3
	wire[1:0] offsets_2_3_0_col;
	wire[1:0] offsets_2_3_0_row;
	wire[1:0] offsets_2_3_1_col;
	wire[1:0] offsets_2_3_1_row;
	wire[1:0] offsets_2_3_2_col;
	wire[1:0] offsets_2_3_2_row;
	wire[1:0] offsets_2_3_3_col;
	wire[1:0] offsets_2_3_3_row;
	
	wire[1:0] rightmostColumn_2_3;
	wire[1:0] leftmostColumn_2_3;
	wire[1:0] bottomRow_2_3;
	
	
	// S block
	
	wire[2:0] pieceColours3;
	
	// Rotation 0
	wire[1:0] offsets_3_0_0_col;
	wire[1:0] offsets_3_0_0_row;
	wire[1:0] offsets_3_0_1_col;
	wire[1:0] offsets_3_0_1_row;
	wire[1:0] offsets_3_0_2_col;
	wire[1:0] offsets_3_0_2_row;
	wire[1:0] offsets_3_0_3_col;
	wire[1:0] offsets_3_0_3_row;
	
	wire[1:0] rightmostColumn_3_0;
	wire[1:0] leftmostColumn_3_0;
	wire[1:0] bottomRow_3_0;
	
	// Rotation 1
	wire[1:0] offsets_3_1_0_col;
	wire[1:0] offsets_3_1_0_row;
	wire[1:0] offsets_3_1_1_col;
	wire[1:0] offsets_3_1_1_row;
	wire[1:0] offsets_3_1_2_col;
	wire[1:0] offsets_3_1_2_row;
	wire[1:0] offsets_3_1_3_col;
	wire[1:0] offsets_3_1_3_row;
	
	wire[1:0] rightmostColumn_3_1;
	wire[1:0] leftmostColumn_3_1;
	wire[1:0] bottomRow_3_1;

	// Rotation 2
	wire[1:0] offsets_3_2_0_col;
	wire[1:0] offsets_3_2_0_row;
	wire[1:0] offsets_3_2_1_col;
	wire[1:0] offsets_3_2_1_row;
	wire[1:0] offsets_3_2_2_col;
	wire[1:0] offsets_3_2_2_row;
	wire[1:0] offsets_3_2_3_col;
	wire[1:0] offsets_3_2_3_row;
	
	wire[1:0] rightmostColumn_3_2;
	wire[1:0] leftmostColumn_3_2;
	wire[1:0] bottomRow_3_2;
	
	// Rotation 3
	wire[1:0] offsets_3_3_0_col;
	wire[1:0] offsets_3_3_0_row;
	wire[1:0] offsets_3_3_1_col;
	wire[1:0] offsets_3_3_1_row;
	wire[1:0] offsets_3_3_2_col;
	wire[1:0] offsets_3_3_2_row;
	wire[1:0] offsets_3_3_3_col;
	wire[1:0] offsets_3_3_3_row;
	
	wire[1:0] rightmostColumn_3_3;
	wire[1:0] leftmostColumn_3_3;
	wire[1:0] bottomRow_3_3;
	
	
	// Z block
	
	wire[2:0] pieceColours4;
	
	// Rotation 0
	wire[1:0] offsets_4_0_0_col;
	wire[1:0] offsets_4_0_0_row;
	wire[1:0] offsets_4_0_1_col;
	wire[1:0] offsets_4_0_1_row;
	wire[1:0] offsets_4_0_2_col;
	wire[1:0] offsets_4_0_2_row;
	wire[1:0] offsets_4_0_3_col;
	wire[1:0] offsets_4_0_3_row;
	
	wire[1:0] rightmostColumn_4_0;
	wire[1:0] leftmostColumn_4_0;
	wire[1:0] bottomRow_4_0;
	
	// Rotation 1
	wire[1:0] offsets_4_1_0_col;
	wire[1:0] offsets_4_1_0_row;
	wire[1:0] offsets_4_1_1_col;
	wire[1:0] offsets_4_1_1_row;
	wire[1:0] offsets_4_1_2_col;
	wire[1:0] offsets_4_1_2_row;
	wire[1:0] offsets_4_1_3_col;
	wire[1:0] offsets_4_1_3_row;
	
	wire[1:0] rightmostColumn_4_1;
	wire[1:0] leftmostColumn_4_1;
	wire[1:0] bottomRow_4_1;

	// Rotation 2
	wire[1:0] offsets_4_2_0_col;
	wire[1:0] offsets_4_2_0_row;
	wire[1:0] offsets_4_2_1_col;
	wire[1:0] offsets_4_2_1_row;
	wire[1:0] offsets_4_2_2_col;
	wire[1:0] offsets_4_2_2_row;
	wire[1:0] offsets_4_2_3_col;
	wire[1:0] offsets_4_2_3_row;
	
	wire[1:0] rightmostColumn_4_2;
	wire[1:0] leftmostColumn_4_2;
	wire[1:0] bottomRow_4_2;
	
	// Rotation 3
	wire[1:0] offsets_4_3_0_col;
	wire[1:0] offsets_4_3_0_row;
	wire[1:0] offsets_4_3_1_col;
	wire[1:0] offsets_4_3_1_row;
	wire[1:0] offsets_4_3_2_col;
	wire[1:0] offsets_4_3_2_row;
	wire[1:0] offsets_4_3_3_col;
	wire[1:0] offsets_4_3_3_row;
	
	wire[1:0] rightmostColumn_4_3;
	wire[1:0] leftmostColumn_4_3;
	wire[1:0] bottomRow_4_3;
	
	
	// L block
	
	wire[2:0] pieceColours5;
	
	// Rotation 0
	wire[1:0] offsets_5_0_0_col;
	wire[1:0] offsets_5_0_0_row;
	wire[1:0] offsets_5_0_1_col;
	wire[1:0] offsets_5_0_1_row;
	wire[1:0] offsets_5_0_2_col;
	wire[1:0] offsets_5_0_2_row;
	wire[1:0] offsets_5_0_3_col;
	wire[1:0] offsets_5_0_3_row;
	
	wire[1:0] rightmostColumn_5_0;
	wire[1:0] leftmostColumn_5_0;
	wire[1:0] bottomRow_5_0;
	
	// Rotation 1
	wire[1:0] offsets_5_1_0_col;
	wire[1:0] offsets_5_1_0_row;
	wire[1:0] offsets_5_1_1_col;
	wire[1:0] offsets_5_1_1_row;
	wire[1:0] offsets_5_1_2_col;
	wire[1:0] offsets_5_1_2_row;
	wire[1:0] offsets_5_1_3_col;
	wire[1:0] offsets_5_1_3_row;
	
	wire[1:0] rightmostColumn_5_1;
	wire[1:0] leftmostColumn_5_1;
	wire[1:0] bottomRow_5_1;
	
	// Rotation 2
	wire[1:0] offsets_5_2_0_col;
	wire[1:0] offsets_5_2_0_row;
	wire[1:0] offsets_5_2_1_col;
	wire[1:0] offsets_5_2_1_row;
	wire[1:0] offsets_5_2_2_col;
	wire[1:0] offsets_5_2_2_row;
	wire[1:0] offsets_5_2_3_col;
	wire[1:0] offsets_5_2_3_row;
	
	wire[1:0] rightmostColumn_5_2;
	wire[1:0] leftmostColumn_5_2;
	wire[1:0] bottomRow_5_2;
	
	// Rotation 3
	wire[1:0] offsets_5_3_0_col;
	wire[1:0] offsets_5_3_0_row;
	wire[1:0] offsets_5_3_1_col;
	wire[1:0] offsets_5_3_1_row;
	wire[1:0] offsets_5_3_2_col;
	wire[1:0] offsets_5_3_2_row;
	wire[1:0] offsets_5_3_3_col;
	wire[1:0] offsets_5_3_3_row;
	
	wire[1:0] rightmostColumn_5_3;
	wire[1:0] leftmostColumn_5_3;
	wire[1:0] bottomRow_5_3;
	
	
	// J block
	
	wire[2:0] pieceColours6;
	
	// Rotation 0
	wire[1:0] offsets_6_0_0_col;
	wire[1:0] offsets_6_0_0_row;
	wire[1:0] offsets_6_0_1_col;
	wire[1:0] offsets_6_0_1_row;
	wire[1:0] offsets_6_0_2_col;
	wire[1:0] offsets_6_0_2_row;
	wire[1:0] offsets_6_0_3_col;
	wire[1:0] offsets_6_0_3_row;
	
	wire[1:0] rightmostColumn_6_0;
	wire[1:0] leftmostColumn_6_0;
	wire[1:0] bottomRow_6_0;
	
	// Rotation 1
	wire[1:0] offsets_6_1_0_col;
	wire[1:0] offsets_6_1_0_row;
	wire[1:0] offsets_6_1_1_col;
	wire[1:0] offsets_6_1_1_row;
	wire[1:0] offsets_6_1_2_col;
	wire[1:0] offsets_6_1_2_row;
	wire[1:0] offsets_6_1_3_col;
	wire[1:0] offsets_6_1_3_row;
	
	wire[1:0] rightmostColumn_6_1;
	wire[1:0] leftmostColumn_6_1;
	wire[1:0] bottomRow_6_1;
	
	// Rotation 2
	wire[1:0] offsets_6_2_0_col;
	wire[1:0] offsets_6_2_0_row;
	wire[1:0] offsets_6_2_1_col;
	wire[1:0] offsets_6_2_1_row;
	wire[1:0] offsets_6_2_2_col;
	wire[1:0] offsets_6_2_2_row;
	wire[1:0] offsets_6_2_3_col;
	wire[1:0] offsets_6_2_3_row;
	
	wire[1:0] rightmostColumn_6_2;
	wire[1:0] leftmostColumn_6_2;
	wire[1:0] bottomRow_6_2;
	
	// Rotation 3
	wire[1:0] offsets_6_3_0_col;
	wire[1:0] offsets_6_3_0_row;
	wire[1:0] offsets_6_3_1_col;
	wire[1:0] offsets_6_3_1_row;
	wire[1:0] offsets_6_3_2_col;
	wire[1:0] offsets_6_3_2_row;
	wire[1:0] offsets_6_3_3_col;
	wire[1:0] offsets_6_3_3_row;
	
	wire[1:0] rightmostColumn_6_3;
	wire[1:0] leftmostColumn_6_3;
	wire[1:0] bottomRow_6_3;
	
	
	// T block
	
	wire[2:0] pieceColours7;
	
	// Rotation 0
	wire[1:0] offsets_7_0_0_col;
	wire[1:0] offsets_7_0_0_row;
	wire[1:0] offsets_7_0_1_col;
	wire[1:0] offsets_7_0_1_row;
	wire[1:0] offsets_7_0_2_col;
	wire[1:0] offsets_7_0_2_row;
	wire[1:0] offsets_7_0_3_col;
	wire[1:0] offsets_7_0_3_row;
	
	wire[1:0] rightmostColumn_7_0;
	wire[1:0] leftmostColumn_7_0;
	wire[1:0] bottomRow_7_0;
	
	// Rotation 1
	wire[1:0] offsets_7_1_0_col;
	wire[1:0] offsets_7_1_0_row;
	wire[1:0] offsets_7_1_1_col;
	wire[1:0] offsets_7_1_1_row;
	wire[1:0] offsets_7_1_2_col;
	wire[1:0] offsets_7_1_2_row;
	wire[1:0] offsets_7_1_3_col;
	wire[1:0] offsets_7_1_3_row;
	
	wire[1:0] rightmostColumn_7_1;
	wire[1:0] leftmostColumn_7_1;
	wire[1:0] bottomRow_7_1;
	
	// Rotation 2
	wire[1:0] offsets_7_2_0_col;
	wire[1:0] offsets_7_2_0_row;
	wire[1:0] offsets_7_2_1_col;
	wire[1:0] offsets_7_2_1_row;
	wire[1:0] offsets_7_2_2_col;
	wire[1:0] offsets_7_2_2_row;
	wire[1:0] offsets_7_2_3_col;
	wire[1:0] offsets_7_2_3_row;
	
	wire[1:0] rightmostColumn_7_2;
	wire[1:0] leftmostColumn_7_2;
	wire[1:0] bottomRow_7_2;
	
	// Rotation 3
	wire[1:0] offsets_7_3_0_col;
	wire[1:0] offsets_7_3_0_row;
	wire[1:0] offsets_7_3_1_col;
	wire[1:0] offsets_7_3_1_row;
	wire[1:0] offsets_7_3_2_col;
	wire[1:0] offsets_7_3_2_row;
	wire[1:0] offsets_7_3_3_col;
	wire[1:0] offsets_7_3_3_row;
	
	wire[1:0] rightmostColumn_7_3;
	wire[1:0] leftmostColumn_7_3;
	wire[1:0] bottomRow_7_3;
	
	
	
	// O block
	
	assign pieceColours1 = 3'b110; // Yellow
	
	// Rotation 0
	assign offsets_1_0_0_col = 1;
	assign offsets_1_0_0_row = 1;
	assign offsets_1_0_1_col = 2;
	assign offsets_1_0_1_row = 1;
	assign offsets_1_0_2_col = 1;
	assign offsets_1_0_2_row = 2;
	assign offsets_1_0_3_col = 2;
	assign offsets_1_0_3_row = 2;
	
	assign rightmostColumn_1_0 = 2;
	assign leftmostColumn_1_0 = 1;
	assign bottomRow_1_0 = 2;
	
	// Rotation 1
	assign offsets_1_1_0_col = 1;
	assign offsets_1_1_0_row = 1;
	assign offsets_1_1_1_col = 2;
	assign offsets_1_1_1_row = 1;
	assign offsets_1_1_2_col = 1;
	assign offsets_1_1_2_row = 2;
	assign offsets_1_1_3_col = 2;
	assign offsets_1_1_3_row = 2;
	
	assign rightmostColumn_1_1 = 2;
	assign leftmostColumn_1_1 = 1;
	assign bottomRow_1_1 = 2;
	
	// Rotation 2
	assign offsets_1_2_0_col = 1;
	assign offsets_1_2_0_row = 1;
	assign offsets_1_2_1_col = 2;
	assign offsets_1_2_1_row = 1;
	assign offsets_1_2_2_col = 1;
	assign offsets_1_2_2_row = 2;
	assign offsets_1_2_3_col = 2;
	assign offsets_1_2_3_row = 2;
	
	assign rightmostColumn_1_2 = 2;
	assign leftmostColumn_1_2 = 1;
	assign bottomRow_1_2 = 2;
	
	// Rotation 3
	assign offsets_1_3_0_col = 1;
	assign offsets_1_3_0_row = 1;
	assign offsets_1_3_1_col = 2;
	assign offsets_1_3_1_row = 1;
	assign offsets_1_3_2_col = 1;
	assign offsets_1_3_2_row = 2;
	assign offsets_1_3_3_col = 2;
	assign offsets_1_3_3_row = 2;
	
	assign rightmostColumn_1_3 = 2;
	assign leftmostColumn_1_3 = 1;
	assign bottomRow_1_3 = 2;
	
	
	// I block
	
	assign pieceColours2 = 3'b111; // White
	
	// Rotation 0
	assign offsets_2_0_0_col = 0;
	assign offsets_2_0_0_row = 1;
	assign offsets_2_0_1_col = 1;
	assign offsets_2_0_1_row = 1;
	assign offsets_2_0_2_col = 2;
	assign offsets_2_0_2_row = 1;
	assign offsets_2_0_3_col = 3;
	assign offsets_2_0_3_row = 1;
	
	assign rightmostColumn_2_0 = 3;
	assign leftmostColumn_2_0 = 0;
	assign bottomRow_2_0 = 1;
	
	// Rotation 1
	assign offsets_2_1_0_col = 2;
	assign offsets_2_1_0_row = 0;
	assign offsets_2_1_1_col = 2;
	assign offsets_2_1_1_row = 1;
	assign offsets_2_1_2_col = 2;
	assign offsets_2_1_2_row = 2;
	assign offsets_2_1_3_col = 2;
	assign offsets_2_1_3_row = 3;
	
	assign rightmostColumn_2_1 = 2;
	assign leftmostColumn_2_1 = 2;
	assign bottomRow_2_1 = 3;
	
	// Rotation 2
	assign offsets_2_2_0_col = 0;
	assign offsets_2_2_0_row = 1;
	assign offsets_2_2_1_col = 1;
	assign offsets_2_2_1_row = 1;
	assign offsets_2_2_2_col = 2;
	assign offsets_2_2_2_row = 1;
	assign offsets_2_2_3_col = 3;
	assign offsets_2_2_3_row = 1;
	
	assign rightmostColumn_2_2 = 3;
	assign leftmostColumn_2_2 = 0;
	assign bottomRow_2_2 = 1;

	// Rotation 3
	assign offsets_2_3_0_col = 2;
	assign offsets_2_3_0_row = 0;
	assign offsets_2_3_1_col = 2;
	assign offsets_2_3_1_row = 1;
	assign offsets_2_3_2_col = 2;
	assign offsets_2_3_2_row = 2;
	assign offsets_2_3_3_col = 2;
	assign offsets_2_3_3_row = 3;
	
	assign rightmostColumn_2_3 = 2;
	assign leftmostColumn_2_3 = 2;
	assign bottomRow_2_3 = 3;
	
	
	// S block
	
	assign pieceColours3 = 3'b010; // Green
	
	// Rotation 0
	assign offsets_3_0_0_col = 2;
	assign offsets_3_0_0_row = 1;
	assign offsets_3_0_1_col = 3;
	assign offsets_3_0_1_row = 1;
	assign offsets_3_0_2_col = 1;
	assign offsets_3_0_2_row = 2;
	assign offsets_3_0_3_col = 2;
	assign offsets_3_0_3_row = 2;
	
	assign rightmostColumn_3_0 = 3;
	assign leftmostColumn_3_0 = 1;
	assign bottomRow_3_0 = 2;
	
	// Rotation 1
	assign offsets_3_1_0_col = 2;
	assign offsets_3_1_0_row = 0;
	assign offsets_3_1_1_col = 2;
	assign offsets_3_1_1_row = 1;
	assign offsets_3_1_2_col = 3;
	assign offsets_3_1_2_row = 1;
	assign offsets_3_1_3_col = 3;
	assign offsets_3_1_3_row = 2;
	
	assign rightmostColumn_3_1 = 3;
	assign leftmostColumn_3_1 = 2;
	assign bottomRow_3_1 = 2;

	// Rotation 2
	assign offsets_3_2_0_col = 2;
	assign offsets_3_2_0_row = 1;
	assign offsets_3_2_1_col = 3;
	assign offsets_3_2_1_row = 1;
	assign offsets_3_2_2_col = 1;
	assign offsets_3_2_2_row = 2;
	assign offsets_3_2_3_col = 2;
	assign offsets_3_2_3_row = 2;
	
	assign rightmostColumn_3_2 = 3;
	assign leftmostColumn_3_2 = 1;
	assign bottomRow_3_2 = 2;
	
	// Rotation 3
	assign offsets_3_3_0_col = 2;
	assign offsets_3_3_0_row = 0;
	assign offsets_3_3_1_col = 2;
	assign offsets_3_3_1_row = 1;
	assign offsets_3_3_2_col = 3;
	assign offsets_3_3_2_row = 1;
	assign offsets_3_3_3_col = 3;
	assign offsets_3_3_3_row = 2;
	
	assign rightmostColumn_3_3 = 3;
	assign leftmostColumn_3_3 = 2;
	assign bottomRow_3_3 = 2;
	
	
	// Z block
	
	assign pieceColours4 = 3'b100; // Red
	
	// Rotation 0
	assign offsets_4_0_0_col = 1;
	assign offsets_4_0_0_row = 1;
	assign offsets_4_0_1_col = 2;
	assign offsets_4_0_1_row = 1;
	assign offsets_4_0_2_col = 2;
	assign offsets_4_0_2_row = 2;
	assign offsets_4_0_3_col = 3;
	assign offsets_4_0_3_row = 2;
	
	assign rightmostColumn_4_0 = 3;
	assign leftmostColumn_4_0 = 1;
	assign bottomRow_4_0 = 2;
	
	// Rotation 1
	assign offsets_4_1_0_col = 3;
	assign offsets_4_1_0_row = 0;
	assign offsets_4_1_1_col = 2;
	assign offsets_4_1_1_row = 1;
	assign offsets_4_1_2_col = 3;
	assign offsets_4_1_2_row = 1;
	assign offsets_4_1_3_col = 2;
	assign offsets_4_1_3_row = 2;
	
	assign rightmostColumn_4_1 = 3;
	assign leftmostColumn_4_1 = 2;
	assign bottomRow_4_1 = 2;

	// Rotation 2
	assign offsets_4_2_0_col = 1;
	assign offsets_4_2_0_row = 1;
	assign offsets_4_2_1_col = 2;
	assign offsets_4_2_1_row = 1;
	assign offsets_4_2_2_col = 2;
	assign offsets_4_2_2_row = 2;
	assign offsets_4_2_3_col = 3;
	assign offsets_4_2_3_row = 2;
	
	assign rightmostColumn_4_2 = 3;
	assign leftmostColumn_4_2 = 1;
	assign bottomRow_4_2 = 2;
	
	// Rotation 3
	assign offsets_4_3_0_col = 3;
	assign offsets_4_3_0_row = 0;
	assign offsets_4_3_1_col = 2;
	assign offsets_4_3_1_row = 1;
	assign offsets_4_3_2_col = 3;
	assign offsets_4_3_2_row = 1;
	assign offsets_4_3_3_col = 2;
	assign offsets_4_3_3_row = 2;
 	
	assign rightmostColumn_4_3 = 3;
	assign leftmostColumn_4_3 = 2;
	assign bottomRow_4_3 = 2;
	
	
	// L block
	
	assign pieceColours5 = 3'b011; // Cyan
	
	// Rotation 0
	assign offsets_5_0_0_col = 1;
	assign offsets_5_0_0_row = 1;
	assign offsets_5_0_1_col = 2;
	assign offsets_5_0_1_row = 1;
	assign offsets_5_0_2_col = 3;
	assign offsets_5_0_2_row = 1;
	assign offsets_5_0_3_col = 1;
	assign offsets_5_0_3_row = 2;
	
	assign rightmostColumn_5_0 = 3;
	assign leftmostColumn_5_0 = 1;
	assign bottomRow_5_0 = 2;
	
	// Rotation 1
	assign offsets_5_1_0_col = 2;
	assign offsets_5_1_0_row = 0;
	assign offsets_5_1_1_col = 2;
	assign offsets_5_1_1_row = 1;
	assign offsets_5_1_2_col = 2;
	assign offsets_5_1_2_row = 2;
	assign offsets_5_1_3_col = 3;
	assign offsets_5_1_3_row = 2;
	
	assign rightmostColumn_5_1 = 3;
	assign leftmostColumn_5_1 = 2;
	assign bottomRow_5_1 = 2;
	
	// Rotation 2
	assign offsets_5_2_0_col = 3;
	assign offsets_5_2_0_row = 0;
	assign offsets_5_2_1_col = 1;
	assign offsets_5_2_1_row = 1;
	assign offsets_5_2_2_col = 2;
	assign offsets_5_2_2_row = 1;
	assign offsets_5_2_3_col = 3;
	assign offsets_5_2_3_row = 1;
	
	assign rightmostColumn_5_2 = 3;
	assign leftmostColumn_5_2 = 1;
	assign bottomRow_5_2 = 1;
	
	// Rotation 3
	assign offsets_5_3_0_col = 1;
	assign offsets_5_3_0_row = 0;
	assign offsets_5_3_1_col = 2;
	assign offsets_5_3_1_row = 0;
	assign offsets_5_3_2_col = 2;
	assign offsets_5_3_2_row = 1;
	assign offsets_5_3_3_col = 2;
	assign offsets_5_3_3_row = 2;
	
	assign rightmostColumn_5_3 = 2;
	assign leftmostColumn_5_3 = 1;
	assign bottomRow_5_3 = 2;
	
	
	// J block
	
	assign pieceColours6 = 3'b001; // Blue
	
	// Rotation 0
	assign offsets_6_0_0_col = 1;
	assign offsets_6_0_0_row = 1;
	assign offsets_6_0_1_col = 2;
	assign offsets_6_0_1_row = 1;
	assign offsets_6_0_2_col = 3;
	assign offsets_6_0_2_row = 1;
	assign offsets_6_0_3_col = 3;
	assign offsets_6_0_3_row = 2;
	
	assign rightmostColumn_6_0 = 3;
	assign leftmostColumn_6_0 = 1;
	assign bottomRow_6_0 = 2;
	
	// Rotation 1
	assign offsets_6_1_0_col = 2;
	assign offsets_6_1_0_row = 0;
	assign offsets_6_1_1_col = 3;
	assign offsets_6_1_1_row = 0;
	assign offsets_6_1_2_col = 2;
	assign offsets_6_1_2_row = 1;
	assign offsets_6_1_3_col = 2;
	assign offsets_6_1_3_row = 2;
	
	assign rightmostColumn_6_1 = 3;
	assign leftmostColumn_6_1 = 2;
	assign bottomRow_6_1 = 2;
	
	// Rotation 2
	assign offsets_6_2_0_col = 1;
	assign offsets_6_2_0_row = 0;
	assign offsets_6_2_1_col = 1;
	assign offsets_6_2_1_row = 1;
	assign offsets_6_2_2_col = 2;
	assign offsets_6_2_2_row = 1;
	assign offsets_6_2_3_col = 3;
	assign offsets_6_2_3_row = 1;
	
	assign rightmostColumn_6_2 = 3;
	assign leftmostColumn_6_2 = 1;
	assign bottomRow_6_2 = 1;
	
	// Rotation 3
	assign offsets_6_3_0_col = 2;
	assign offsets_6_3_0_row = 0;
	assign offsets_6_3_1_col = 2;
	assign offsets_6_3_1_row = 1;
	assign offsets_6_3_2_col = 1;
	assign offsets_6_3_2_row = 2;
	assign offsets_6_3_3_col = 2;
	assign offsets_6_3_3_row = 2;
	
	assign rightmostColumn_6_3 = 2;
	assign leftmostColumn_6_3 = 1;
	assign bottomRow_6_3 = 2;
	
	
	// T block
	
	assign pieceColours7 = 3'b101; // Magenta
	
	// Rotation 0
	assign offsets_7_0_0_col = 1;
	assign offsets_7_0_0_row = 1;
	assign offsets_7_0_1_col = 2;
	assign offsets_7_0_1_row = 1;
	assign offsets_7_0_2_col = 3;
	assign offsets_7_0_2_row = 1;
	assign offsets_7_0_3_col = 2;
	assign offsets_7_0_3_row = 2;
	
	assign rightmostColumn_7_0 = 3;
	assign leftmostColumn_7_0 = 1;
	assign bottomRow_7_0 = 2;
	
	// Rotation 1
	assign offsets_7_1_0_col = 2;
	assign offsets_7_1_0_row = 0;
	assign offsets_7_1_1_col = 2;
	assign offsets_7_1_1_row = 1;
	assign offsets_7_1_2_col = 3;
	assign offsets_7_1_2_row = 1;
	assign offsets_7_1_3_col = 2;
	assign offsets_7_1_3_row = 2;
	
	assign rightmostColumn_7_1 = 3;
	assign leftmostColumn_7_1 = 2;
	assign bottomRow_7_1 = 2;
	
	// Rotation 2
	assign offsets_7_2_0_col = 2;
	assign offsets_7_2_0_row = 0;
	assign offsets_7_2_1_col = 1;
	assign offsets_7_2_1_row = 1;
	assign offsets_7_2_2_col = 2;
	assign offsets_7_2_2_row = 1;
	assign offsets_7_2_3_col = 3;
	assign offsets_7_2_3_row = 1;
	
	assign rightmostColumn_7_2 = 3;
	assign leftmostColumn_7_2 = 1;
	assign bottomRow_7_2 = 1;
	
	// Rotation 3
	assign offsets_7_3_0_col = 2;
	assign offsets_7_3_0_row = 0;
	assign offsets_7_3_1_col = 1;
	assign offsets_7_3_1_row = 1;
	assign offsets_7_3_2_col = 2;
	assign offsets_7_3_2_row = 1;
	assign offsets_7_3_3_col = 2;
	assign offsets_7_3_3_row = 2;
	
	assign rightmostColumn_7_3 = 2;
	assign leftmostColumn_7_3 = 1;
	assign bottomRow_7_3 = 2;
	
	
	
	// OUTPUT ASSIGNMENTS
	assign pieceColours = {
		pieceColours7,
		pieceColours6,
		pieceColours5,
		pieceColours4,
		pieceColours3,
		pieceColours2,
		pieceColours1
		};
		
	assign offsets_col = {
		offsets_7_3_3_col,
		offsets_7_3_2_col,
		offsets_7_3_1_col,
		offsets_7_3_0_col,
		offsets_7_2_3_col,
		offsets_7_2_2_col,
		offsets_7_2_1_col,
		offsets_7_2_0_col,
		offsets_7_1_3_col,
		offsets_7_1_2_col,
		offsets_7_1_1_col,
		offsets_7_1_0_col,
		offsets_7_0_3_col,
		offsets_7_0_2_col,
		offsets_7_0_1_col,
		offsets_7_0_0_col,
		
		offsets_6_3_3_col,
		offsets_6_3_2_col,
		offsets_6_3_1_col,
		offsets_6_3_0_col,
		offsets_6_2_3_col,
		offsets_6_2_2_col,
		offsets_6_2_1_col,
		offsets_6_2_0_col,
		offsets_6_1_3_col,
		offsets_6_1_2_col,
		offsets_6_1_1_col,
		offsets_6_1_0_col,
		offsets_6_0_3_col,
		offsets_6_0_2_col,
		offsets_6_0_1_col,
		offsets_6_0_0_col,
		
		offsets_5_3_3_col,
		offsets_5_3_2_col,
		offsets_5_3_1_col,
		offsets_5_3_0_col,
		offsets_5_2_3_col,
		offsets_5_2_2_col,
		offsets_5_2_1_col,
		offsets_5_2_0_col,
		offsets_5_1_3_col,
		offsets_5_1_2_col,
		offsets_5_1_1_col,
		offsets_5_1_0_col,
		offsets_5_0_3_col,
		offsets_5_0_2_col,
		offsets_5_0_1_col,
		offsets_5_0_0_col,
		
		offsets_4_3_3_col,
		offsets_4_3_2_col,
		offsets_4_3_1_col,
		offsets_4_3_0_col,
		offsets_4_2_3_col,
		offsets_4_2_2_col,
		offsets_4_2_1_col,
		offsets_4_2_0_col,
		offsets_4_1_3_col,
		offsets_4_1_2_col,
		offsets_4_1_1_col,
		offsets_4_1_0_col,
		offsets_4_0_3_col,
		offsets_4_0_2_col,
		offsets_4_0_1_col,
		offsets_4_0_0_col,
		
		offsets_3_3_3_col,
		offsets_3_3_2_col,
		offsets_3_3_1_col,
		offsets_3_3_0_col,
		offsets_3_2_3_col,
		offsets_3_2_2_col,
		offsets_3_2_1_col,
		offsets_3_2_0_col,
		offsets_3_1_3_col,
		offsets_3_1_2_col,
		offsets_3_1_1_col,
		offsets_3_1_0_col,
		offsets_3_0_3_col,
		offsets_3_0_2_col,
		offsets_3_0_1_col,
		offsets_3_0_0_col,
		
		offsets_2_3_3_col,
		offsets_2_3_2_col,
		offsets_2_3_1_col,
		offsets_2_3_0_col,
		offsets_2_2_3_col,
		offsets_2_2_2_col,
		offsets_2_2_1_col,
		offsets_2_2_0_col,
		offsets_2_1_3_col,
		offsets_2_1_2_col,
		offsets_2_1_1_col,
		offsets_2_1_0_col,
		offsets_2_0_3_col,
		offsets_2_0_2_col,
		offsets_2_0_1_col,
		offsets_2_0_0_col,
		
		offsets_1_3_3_col,
		offsets_1_3_2_col,
		offsets_1_3_1_col,
		offsets_1_3_0_col,
		offsets_1_2_3_col,
		offsets_1_2_2_col,
		offsets_1_2_1_col,
		offsets_1_2_0_col,
		offsets_1_1_3_col,
		offsets_1_1_2_col,
		offsets_1_1_1_col,
		offsets_1_1_0_col,
		offsets_1_0_3_col,
		offsets_1_0_2_col,
		offsets_1_0_1_col,
		offsets_1_0_0_col
		};

	assign offsets_row = {
		offsets_7_3_3_row,
		offsets_7_3_2_row,
		offsets_7_3_1_row,
		offsets_7_3_0_row,
		offsets_7_2_3_row,
		offsets_7_2_2_row,
		offsets_7_2_1_row,
		offsets_7_2_0_row,
		offsets_7_1_3_row,
		offsets_7_1_2_row,
		offsets_7_1_1_row,
		offsets_7_1_0_row,
		offsets_7_0_3_row,
		offsets_7_0_2_row,
		offsets_7_0_1_row,
		offsets_7_0_0_row,
		
		offsets_6_3_3_row,
		offsets_6_3_2_row,
		offsets_6_3_1_row,
		offsets_6_3_0_row,
		offsets_6_2_3_row,
		offsets_6_2_2_row,
		offsets_6_2_1_row,
		offsets_6_2_0_row,
		offsets_6_1_3_row,
		offsets_6_1_2_row,
		offsets_6_1_1_row,
		offsets_6_1_0_row,
		offsets_6_0_3_row,
		offsets_6_0_2_row,
		offsets_6_0_1_row,
		offsets_6_0_0_row,
		
		offsets_5_3_3_row,
		offsets_5_3_2_row,
		offsets_5_3_1_row,
		offsets_5_3_0_row,
		offsets_5_2_3_row,
		offsets_5_2_2_row,
		offsets_5_2_1_row,
		offsets_5_2_0_row,
		offsets_5_1_3_row,
		offsets_5_1_2_row,
		offsets_5_1_1_row,
		offsets_5_1_0_row,
		offsets_5_0_3_row,
		offsets_5_0_2_row,
		offsets_5_0_1_row,
		offsets_5_0_0_row,
		
		offsets_4_3_3_row,
		offsets_4_3_2_row,
		offsets_4_3_1_row,
		offsets_4_3_0_row,
		offsets_4_2_3_row,
		offsets_4_2_2_row,
		offsets_4_2_1_row,
		offsets_4_2_0_row,
		offsets_4_1_3_row,
		offsets_4_1_2_row,
		offsets_4_1_1_row,
		offsets_4_1_0_row,
		offsets_4_0_3_row,
		offsets_4_0_2_row,
		offsets_4_0_1_row,
		offsets_4_0_0_row,
		
		offsets_3_3_3_row,
		offsets_3_3_2_row,
		offsets_3_3_1_row,
		offsets_3_3_0_row,
		offsets_3_2_3_row,
		offsets_3_2_2_row,
		offsets_3_2_1_row,
		offsets_3_2_0_row,
		offsets_3_1_3_row,
		offsets_3_1_2_row,
		offsets_3_1_1_row,
		offsets_3_1_0_row,
		offsets_3_0_3_row,
		offsets_3_0_2_row,
		offsets_3_0_1_row,
		offsets_3_0_0_row,
		
		offsets_2_3_3_row,
		offsets_2_3_2_row,
		offsets_2_3_1_row,
		offsets_2_3_0_row,
		offsets_2_2_3_row,
		offsets_2_2_2_row,
		offsets_2_2_1_row,
		offsets_2_2_0_row,
		offsets_2_1_3_row,
		offsets_2_1_2_row,
		offsets_2_1_1_row,
		offsets_2_1_0_row,
		offsets_2_0_3_row,
		offsets_2_0_2_row,
		offsets_2_0_1_row,
		offsets_2_0_0_row,
		
		offsets_1_3_3_row,
		offsets_1_3_2_row,
		offsets_1_3_1_row,
		offsets_1_3_0_row,
		offsets_1_2_3_row,
		offsets_1_2_2_row,
		offsets_1_2_1_row,
		offsets_1_2_0_row,
		offsets_1_1_3_row,
		offsets_1_1_2_row,
		offsets_1_1_1_row,
		offsets_1_1_0_row,
		offsets_1_0_3_row,
		offsets_1_0_2_row,
		offsets_1_0_1_row,
		offsets_1_0_0_row
		};

	assign rightmostColumns = {
		rightmostColumn_7_3,
		rightmostColumn_7_2,
		rightmostColumn_7_1,
		rightmostColumn_7_0,
		
		rightmostColumn_6_3,
		rightmostColumn_6_2,
		rightmostColumn_6_1,
		rightmostColumn_6_0,
		
		rightmostColumn_5_3,
		rightmostColumn_5_2,
		rightmostColumn_5_1,
		rightmostColumn_5_0,
		
		rightmostColumn_4_3,
		rightmostColumn_4_2,
		rightmostColumn_4_1,
		rightmostColumn_4_0,
		
		rightmostColumn_3_3,
		rightmostColumn_3_2,
		rightmostColumn_3_1,
		rightmostColumn_3_0,
		
		rightmostColumn_2_3,
		rightmostColumn_2_2,
		rightmostColumn_2_1,
		rightmostColumn_2_0,
		
		rightmostColumn_1_3,
		rightmostColumn_1_2,
		rightmostColumn_1_1,
		rightmostColumn_1_0
		};
		
	assign leftmostColumns = {
		leftmostColumn_7_3,
		leftmostColumn_7_2,
		leftmostColumn_7_1,
		leftmostColumn_7_0,
		
		leftmostColumn_6_3,
		leftmostColumn_6_2,
		leftmostColumn_6_1,
		leftmostColumn_6_0,
		
		leftmostColumn_5_3,
		leftmostColumn_5_2,
		leftmostColumn_5_1,
		leftmostColumn_5_0,
		
		leftmostColumn_4_3,
		leftmostColumn_4_2,
		leftmostColumn_4_1,
		leftmostColumn_4_0,
		
		leftmostColumn_3_3,
		leftmostColumn_3_2,
		leftmostColumn_3_1,
		leftmostColumn_3_0,
		
		leftmostColumn_2_3,
		leftmostColumn_2_2,
		leftmostColumn_2_1,
		leftmostColumn_2_0,
		
		leftmostColumn_1_3,
		leftmostColumn_1_2,
		leftmostColumn_1_1,
		leftmostColumn_1_0
		};
		
	assign bottomRows = {
		bottomRow_7_3,
		bottomRow_7_2,
		bottomRow_7_1,
		bottomRow_7_0,
		
		bottomRow_6_3,
		bottomRow_6_2,
		bottomRow_6_1,
		bottomRow_6_0,
		
		bottomRow_5_3,
		bottomRow_5_2,
		bottomRow_5_1,
		bottomRow_5_0,
		
		bottomRow_4_3,
		bottomRow_4_2,
		bottomRow_4_1,
		bottomRow_4_0,
		
		bottomRow_3_3,
		bottomRow_3_2,
		bottomRow_3_1,
		bottomRow_3_0,
		
		bottomRow_2_3,
		bottomRow_2_2,
		bottomRow_2_1,
		bottomRow_2_0,
		
		bottomRow_1_3,
		bottomRow_1_2,
		bottomRow_1_1,
		bottomRow_1_0
		};
		
endmodule