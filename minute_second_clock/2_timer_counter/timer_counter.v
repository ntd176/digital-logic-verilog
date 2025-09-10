// timer_counter

module timer_counter (
	input clk_1hz,
	input reset,  // key[0]
	input enable, // key[1]
	
	output reg [3:0] sec_unit, // hex[0]
	output reg [3:0] sec_tens, // hex[1]
	output reg [3:0] min_unit, // hex[2]
	output reg [3:0] min_tens // hex[3]
);
	// process overflow BCD // of->overflow
	wire sec_unit_of;
	wire sec_tens_of;
	wire min_unit_of;
	wire min_tens_of;
	//---------------------
	assign sec_unit_of = (sec_unit == 4'h9);
	assign sec_tens_of = (sec_tens == 4'h5 && sec_unit_of); // overflow second if sec_tens = 5 and sec_unit = 9
	assign min_unit_of = (min_unit == 4'h9);
	assign min_tens_of = (min_tens == 4'h5 && min_unit_of); // overflow minute
	
	always @(posedge clk_1hz or posedge reset) begin
		if (reset) begin
			sec_unit <= 4'h0;
			sec_tens <= 4'h0;
			min_unit <= 4'h0;
			min_tens <= 4'h0;
		end else if (enable) begin
			// update sec_unit
			if (sec_unit_of) begin
				sec_unit <= 4'h0;
			end else begin
				sec_unit <= sec_unit + 4'h1;
			end
			// update sec_tens
			if (sec_unit_of) begin
				if (sec_tens_of) begin
					sec_tens <= 4'h0;
				end else begin
					sec_tens <= sec_tens + 4'h1;
				end
			end
			// update min_unit
			if (sec_unit_of && sec_tens_of) begin
				if (min_unit_of) begin
					min_unit <= 4'h0;
				end else begin 
					min_unit <= min_unit + 4'h1;
				end
			end
			// update min_tens
			if (sec_unit_of && sec_tens_of && min_unit_of) begin
				if (min_tens_of) begin
					min_tens <= 4'h0;
				end else begin
					min_tens <= min_tens + 4'h1;
				end
			end
		end
	end
endmodule