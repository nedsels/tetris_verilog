module hex_decoder(c, enable, display);
    input [3:0] c;
	 input enable;
    output [6:0] display;

    assign display[0] = ~( 
          (~c[0] |  c[1] |  c[2] |  c[3])
	& ( c[0] |  c[1] | ~c[2] |  c[3])
	& (~c[0] | ~c[1] |  c[2] | ~c[3])
	& (~c[0] |  c[1] | ~c[2] | ~c[3])
         & enable);

    assign display[1] = ~(
          (~c[0] |  c[1] | ~c[2] |  c[3])
	& ( c[0] | ~c[1] | ~c[2] |  c[3])
	& (~c[0] | ~c[1] |  c[2] | ~c[3])
	& ( c[0] |  c[1] | ~c[2] | ~c[3])
	& ( c[0] | ~c[1] | ~c[2] | ~c[3])
	& (~c[0] | ~c[1] | ~c[2] | ~c[3])
        & enable);

    assign display[2] = ~(
	  ( c[0] | ~c[1] |  c[2] |  c[3])
	& ( c[0] |  c[1] | ~c[2] | ~c[3])
	& ( c[0] | ~c[1] | ~c[2] | ~c[3])
	& (~c[0] | ~c[1] | ~c[2] | ~c[3])
        & enable);

    assign display[3] = ~(
	  (~c[0] |  c[1] |  c[2] |  c[3])
	& ( c[0] |  c[1] | ~c[2] |  c[3])
	& (~c[0] | ~c[1] | ~c[2] |  c[3])
	& (~c[0] |  c[1] |  c[2] | ~c[3])
	& ( c[0] | ~c[1] |  c[2] | ~c[3])
	& (~c[0] | ~c[1] | ~c[2] | ~c[3])
        & enable);

    assign display[4] = ~(
	  (~c[0] |  c[1] |  c[2] |  c[3])
	& (~c[0] | ~c[1] |  c[2] |  c[3])
	& ( c[0] |  c[1] | ~c[2] |  c[3])
	& (~c[0] |  c[1] | ~c[2] |  c[3])
	& (~c[0] | ~c[1] | ~c[2] |  c[3])
	& (~c[0] |  c[1] |  c[2] | ~c[3])
        & enable);

    assign display[5] = ~(
	  (~c[0] |  c[1] |  c[2] |  c[3])
	& ( c[0] | ~c[1] |  c[2] |  c[3])
	& (~c[0] | ~c[1] |  c[2] |  c[3])
	& (~c[0] | ~c[1] | ~c[2] |  c[3])
	& (~c[0] |  c[1] | ~c[2] | ~c[3])
        & enable);

    assign display[6] = ~(
	  ( c[0] |  c[1] |  c[2] |  c[3])
	& (~c[0] |  c[1] |  c[2] |  c[3])
	& (~c[0] | ~c[1] | ~c[2] |  c[3])
	& ( c[0] |  c[1] | ~c[2] | ~c[3])
        & enable);
endmodule