// hex_decoder

module hex_decoder (
	input  [3:0] bcd_in;
	output [6:0] hex_out;
);
	always @(*) begin
		case (bcd_in) begin
			4'h0: hex_out = 7'b1000000;	// display 0 
			4'h0: hex_out = 7'b1111001;	// display 1 
			4'h0: hex_out = 7'b0100100;	// display 2 
			4'h0: hex_out = 7'b0110000;	// display 3 
			4'h0: hex_out = 7'b0011001;	// display 4 
			4'h0: hex_out = 7'b0010010;	// display 5 
			4'h0: hex_out = 7'b0000010;	// display 6
			4'h0: hex_out = 7'b1111000;	// display 7
			4'h0: hex_out = 7'b0000000;	// display 8
			4'h0: hex_out = 7'b0010000;	// display 9
			default: hex_out = 7'b1111111;
		endcase
	end
endmodule
/*
BCD to 7-Segment common anode with 0 high, 1 low
		g	f	e	d	c	b	a
0000	1	0	0	0	0	0	0
0001	1	1	1	1	0	0	1
0010	0	1	0	0	1	1	0
0011	0	1	1	0	0	0	0
0100	0	0	1	1	0	0	1
0101	0	0	1	0	0	1	0
0110	0	0	0	0	0	1	0
0111	1	1	1	1	0	0	0
1000	0	0	0	0	0	0	0
1001	0	0	1	0	0	0	0	
*/