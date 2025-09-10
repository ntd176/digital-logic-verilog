`timescale 1ns/1ns

module timer_counter_tb;
	reg clk_1hz_tb;
	reg reset_tb;
	reg enable_tb;
	
	wire [3:0] sec_unit_tb;
	wire [3:0] sec_tens_tb;
	wire [3:0] min_unit_tb;
	wire [3:0] min_tens_tb;
	
	timer_counter dut (
		.clk_1hz(clk_1hz_tb),
		.reset(reset_tb),
		.enable(enable_tb),
		.sec_unit(sec_unit_tb),
		.sec_tens(sec_tens_tb),
		.min_unit(min_unit_tb),
		.min_tens(min_tens_tb)
	);
	
	parameter clk_1hz_period_tb = 1_000_000;
	
	initial begin
		clk_1hz_tb = 0;
		forever #(clk_1hz_period_tb / 2) clk_1hz_tb = ~clk_1hz_tb;
	end
	
	initial begin
		reset_tb  = 1;
		enable_tb = 0;
		
		#clk_1hz_period_tb;
		reset_tb  = 0;	// pause counter
		
		#(clk_1hz_period_tb * 2);
		enable_tb = 1;	// run counter
		
		#(clk_1hz_period_tb * 5);
		enable_tb = 0;
		
		#(clk_1hz_period_tb *3);
		enable_tb = 1;
		$finish;
	end
endmodule