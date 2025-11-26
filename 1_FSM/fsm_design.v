/***************************************************************/
// File			: fsm design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/26
// Modified Date: 2025/11/26
/***************************************************************/
module fsm_design
(
	input 	clk,
	input 	reset,
	input 	run,
	output 	Y
);
reg [1:0]	current_state, next_state;
parameter [1:0]		Init = 2'b00, A = 2'b01, B = 2'b10;
//-----------------------------------------------------
always @(posedge clk, posedge reset)
	if (reset)
		current_state <= Init;
	else
		current_state <= next_state;
//-----------------------------------------------------
always @(run, current_state)
	case (current_state)
		Init: 
			if (run)
				next_state <= A;
			else 
				next_state <= Init;
		A:
			if (run)
				next_state <= B;
			else 
				next_state <= A;
		B:
			if (run)
				next_state <= Init;
			else 
				next_state <= B;
		default:
			next_state <= 2'bxx;
	endcase
//-----------------------------------------------------
assign Y = (current_state == B);
endmodule

/*
waveform simulation
			  clk	__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__|``|__
			  
			reset	_|````|____________________________|`````|____________________
			
			  run	______|``````````|_____|``````````````````````````````````````
			  
				Y	______________|```````````|_______________________|`````|_____
				
	current_state  |   00   | 01  |     10    | 00 |01|    00   |  01 |  10 |  00
				   |  Init  |  A  |      B    |Init| A|   Init  |   A |   B | Init
*/