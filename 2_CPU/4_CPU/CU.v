/***************************************************************/
// File			: CU design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/28
// Modified Date: 2025/11/28
/***************************************************************/

module ControlUnit
(
	input 		 	  clk, reset,
	input  	   [12:0] data_frame,
	output reg [3:0]  a_in, b_in, op_code,
	output reg [2:0]  addr,
	output reg 		  alu_en, c_in, mem_en
);
reg [2:0] addr_in;
reg [1:0] current_state, next_state;
parameter [1:0] Init    = 2'b00,
				Fetch   = 2'b01,
				Execute = 2'b10,
				Done	= 2'b11;
//------------------------------
always @(posedge clk, posedge reset)
if (reset) begin
	current_state <= Init;
	addr <= 3'b000;
end else begin
	current_state <= next_state;
	addr <= addr_in;
end
//------------------------------
/*
	 ---------------------------------------------------------------
	|	A operand	|	B operand	| 	C carry flag	| 	opcode	|
	|	4 bit		|	4 bit		|	1 bit			|	4 bit	|
	 ---------------------------------------------------------------
	| 	bit 12 - 9	|	bit 8 - 5	|	bit 4			| bit 3 - 0	|
	 ---------------------------------------------------------------
*/
always @(*) begin
	a_in 	= data_frame[12:9];
	b_in 	= data_frame[8:5];
	c_in 	= data_frame[4];
	op_code = data_frame[3:0];
	addr_in = addr;
	case (current_state)
		Init: begin
			mem_en = 1'b0;
			alu_en = 1'b0;
			next_state = Fetch;
		end
		//---------------------
		Fetch: begin
			mem_en = 1'b1;
			alu_en = 1'b0;
			next_state = Execute;
		end
		//---------------------
		Execute: begin
			mem_en = 1'b0;
			alu_en = 1'b1;
			next_state = Done;
		end
		//---------------------
		Done: begin
			mem_en = 1'b0;
			alu_en = 1'b0;
			if (addr_in >= 3'b101) begin // if addr greater than or equal to 5 -> STOP
				next_state = Done;
			end else begin
				next_state = Fetch;
				addr_in = addr_in + 1'b1;
			end
		end
		default: begin
			next_state = Init;
			mem_en = 1'b0;
			alu_en = 1'b0;
		end
	endcase
end

/*
waveform simulation
			  clk	__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__
			  
			reset	_|````|_______________________________________________________
			
			 addr	|    		0			  |			1		|		2
			  
		   mem_en	________|`````|___________|`````|___________|`````|___________
				
		   alu_en	______________|`````|___________|`````|___________|`````|_____

	current_state	|   0   |  1  |  2  |  3  |  1  |  2  |  3  |  1  |  2  |  3  |
					   Init  Fetch  Exe   Done Fetch  Exe   Done Fetch  Exe   Done
*/