/***************************************************************/
// File			: ALU design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/27
// Modified Date: 2025/11/27
/***************************************************************/
module ALU
(
	input 				clk, cin, en,
	input 	   [3:0]	op_code, A, B,
	output reg [3:0] 	Y
);
wire [5:0] OPCODE_CIN;
//--------------------
assign OPCODE_CIN = {op_code, cin};
always @(posedge clk)
	if (en==1'b1)
		case (OPCODE_CIN)
			5'b00000: Y = A;
			5'b00001: Y = A + 1'b1;		// arithmetic operation
			5'b00010: Y = A + B;
			5'b00011: Y = A + B + 1'b1;
			5'b00100: Y = A + ~B + 1'b1;
			5'b00101: Y = A + ~B + 1'b1;
			5'b00110: Y = A - 1'b1;
			5'b00111: Y = A;
			5'b01000: Y = A & B;	// logic operation
			5'b01010: Y = A | B;
			5'b01100: Y = A ^ B;
			5'b01110: Y = ~A;
			5'b10000: Y = 4'b0;
			default:
				Y = 4'bx;
		endcase
endmodule