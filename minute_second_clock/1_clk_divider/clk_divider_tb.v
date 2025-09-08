`timescale 1ns/1ns

module clk_divider_tb;
	reg  clk_50mhz_tb;
	reg  reset_tb;
	wire tick_1hz_tb;
	
	clk_divider dut (
		.clk_50mhz(clk_50mhz_tb),
		.reset(reset_tb),
		.tick_1hz(tick_1hz_tb)
	);
	
	// define parameter for time delays
	parameter time time_hold_reset = 200;
	parameter time time_3s = 64'd3000000000;
	parameter time time_5s = 64'd5000000000;
	
	// counter tick_1hz appear
	integer tick_count;
	
	// period clock 20ns <=> freq clk 50MHz
	initial begin
		clk_50mhz_tb = 0;
		forever #10 clk_50mhz_tb = ~ clk_50mhz_tb;
	end
	
	always @(posedge tick_1hz_tb) begin
		tick_count = tick_count + 1;
	end
	
	initial begin
		reset_tb   = 1;
		tick_count = 0;
		#time_hold_reset; // hold reset in 10 per clk_50mhz
		reset_tb   = 0;
		#time_5s; // 5s for look 5 tick_1hz
		reset_tb   = 1;
		#time_hold_reset;
		reset_tb   = 0;
		#time_3s; 
		$finish;
	end
endmodule

/* 
counter 50M period of clk_50MHz we have 1 second
1 period clk_50mhz = 20ns => 50M period (1 second) = 50M * 20ns = 1,000,000,000 ns
*/