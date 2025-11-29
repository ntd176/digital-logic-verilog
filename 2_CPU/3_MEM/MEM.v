/***************************************************************/
// File			: Memory design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/29
// Modified Date: 2025/11/29
/***************************************************************/

module Mem
(
	input 		 	  clk, en,
	input 	   [2:0]  addr,
	output reg [12:0] data_frame;
);
always @(posedge clk) begin
	if (en)
		case (addr)
		// a_in		b_in	c_in	op_code
			3'b000: data_frame = 13'b0010_1000_1_0000; // A + 1, 2+1=3 
			3'b001: data_frame = 13'b0010_0111_0_0001; // A + B, 2+7=9 
			3'b010: data_frame = 13'b0100_0011_0_0001; // A + B, 4+3=7 
			3'b011: data_frame = 13'b1000_0010_1_0010; // A - B, 8-2=6 
			3'b100: data_frame = 13'b0111_1010_0_0100; // A AND B = 0010 = 2
			3'b101: data_frame = 13'b0001_1000_0_0111; // ~A = 1110 = 4
			default: data_frame = 13'bx;
		endcase
end
endmodule