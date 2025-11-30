/***************************************************************/
// File			: CPU design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/30
// Modified Date: 2025/11/30
/***************************************************************/

module CPU (
	input 		 clk, reset,
	output [3:0] Y,
	output [3:0] a_in, b_in, op_code,
	output 		 c_in
);
wire 		mem_en, alu_en;
wire [2:0]  addr;
wire [12:0] data_frame;

MEM U0 (
	.clk(clk),
	.en(mem_en),
	.addr(addr),
	.data_frame(data_frame);
);

CU U1 (
	.clk(clk),
	.reset(reset),
	.data_frame(data_frame),
	.a_in(a_in), 
	.b_in(b_in),
	.op_code(op_code),
	.addr(addr),
	.alu_en(alu_en),
	.c_in(c_in), 
	.mem_en(mem_en)
);

ALU U2 (
	.clk(clk),
	.c_in(c_in),
	.en(alu_en), 
	.A(a_in),
	.B(b_in),
	.op_code(op_code),
	.Y(Y)
);
endmodule