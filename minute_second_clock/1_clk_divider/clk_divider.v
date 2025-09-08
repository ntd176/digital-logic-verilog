// frequency divider

module clk_divider (
	input 	   clk_50mhz,
	input 	   reset,
	output reg tick_1hz
);

	parameter count_max = 50_000_000 - 1; // 49,999,999
	
	reg [25:0] counter;
	
	always @(posedge clk_50mhz or posedge reset) begin
		if (reset) begin
			counter  <= 0;
			tick_1hz <= 0;
		end else begin
			if (counter == count_max) begin
				counter <= 0;
				tick_1hz <= 1;
			end else begin
				counter <= counter + 1'b1;
				tick_1hz <= 0;
			end
		end
	end
endmodule