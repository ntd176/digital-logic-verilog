/***************************************************************/
// File			: ALU_tb design
// Author		: Tien Dai Nguyen
// Version		: 1.0
// Date			: 2025/11/27
// Modified Date: 2025/11/27
/***************************************************************/

`timescale 1ns / 1ns

module ALU_tb;

    parameter clk_per = 10; // clk = 10 ns

	// testbench signal
    reg        clk;
    reg        cin;
    reg        en;
    reg  [3:0] op_code;
    reg  [3:0] A;
    reg  [3:0] B;
    wire [3:0] Y;
    
    // testbench variable
    integer 	err_cnt; // error_count
    reg [3:0]   ext_Y; // expected_Y

    ALU dut (
        .clk        (clk),
        .cin        (cin),
        .en         (en),
        .op_code    (op_code),
        .A          (A),
        .B          (B),
        .Y          (Y)
    );

    // clock generator
    initial begin
        clk = 0;
        forever #(clk_per / 2) clk = ~clk;
    end

    // main test
    initial begin
        $display("--------------------------------------------------");
        $display("Starting ALU Testbench Simulation...");
        $display("--------------------------------------------------");

        // Setup for waveform viewing
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, ALU_tb);

        // initial values
        en = 0;
        cin = 0;
        op_code = 4'b0000;
        A = 4'b0000;
        B = 4'b0000;
        err_cnt = 0;
        
        #(clk_per * 2);

        // enable the ALU
        en = 1;

		//-------------------
        // --- TEST CASES ---
		//-------------------
        // Test 1 -> transfer A (op_code=0000, cin=0)
        A = 4'd5;
		B = 4'd10;
		op_code = 4'b0000;
		cin = 1'b0; 
		ext_Y = A;
        run_test;
		//---------------------
        // Test 2 -> increase by 1 (op_code=0000, cin=1)
        A = 4'd9;
		B = 4'd10;
		op_code = 4'b0000;
		cin = 1'b1; 
		ext_Y = A + 1;
        run_test;
		//---------------------
        // Test 3 -> add A + B (op_code=0001, cin=0)
        A = 4'd3;
		B = 4'd4; 
		op_code = 4'b0001; 
		cin = 1'b0; ext_Y = A + B;
        run_test;
		//---------------------
		// Test 4 -> add A + B with carry (op_code=0001, cin=1)
        A = 4'd3;
		B = 4'd4; 
		op_code = 4'b0001; 
		cin = 1'b1; 
		ext_Y = A + B + 1;
        run_test;
		//---------------------
		// Test 5 -> Sub A - B (op_code=0010, cin=0)
        A = 4'd10;
		B = 4'd3; 
		op_code = 4'b0010; 
		cin = 1'b0;
		ext_Y = A - B;
        run_test;
		//---------------------
        // Test 6.1 -> sub A - B with carry (op_code=0010, cin=1)
        A = 4'd10;
		B = 4'd3; 
		op_code = 4'b0010; 
		cin = 1'b1; 
		ext_Y = A - B;
        run_test;
		//---------------------
		// Test 6.2 -> sub A - B with carry (op_code=0010, cin=1)
        A = 4'd5;
		B = 4'd8; 
		op_code = 4'b0010; 
		cin = 1'b1; 
		ext_Y = A - B; // result -3
        run_test;
		//---------------------
        // Test 7.1 -> decrease by 1 (op_code=0011, cin=0)
        A = 4'd7;
		B = 4'd3; 
		op_code = 4'b0011; 
		cin = 1'b0; 
		ext_Y = A - 1;
        run_test;
		//---------------------
        // Test 7.2 -> decrease by 1 (op_code=0011, cin=0)
        A = 4'd0;
		B = 4'd3; 
		op_code = 4'b0011; 
		cin = 1'b0; 
		ext_Y = 4'd15;
        run_test;
		//---------------------
		// Test 8 -> transfer A (op_code=0011, cin=1)
        A = 4'd12;
		B = 4'd3; 
		op_code = 4'b0011; 
		cin = 1'b1; 
		ext_Y = A;
        run_test;
		//---------------------
		// Test 9 -> AND logical (op_code=0100, cin=0)
        A = 4'b1010;
		B = 4'b1100; 
		op_code = 4'b0100; 
		cin = 1'b0; 
		ext_Y = A & B;
        run_test;
		//---------------------
		// Test 10 -> OR logical (op_code=0101, cin=0)
        A = 4'b1010;
		B = 4'b1100; 
		op_code = 4'b0101; 
		cin = 1'b0; 
		ext_Y = A | B;
        run_test;
		//---------------------
		// Test 11 -> XOR (op_code=0110, cin=0)
        A = 4'b1010;
		B = 4'b1100; 
		op_code = 4'b0110; 
		cin = 1'b0; 
		ext_Y = A ^ B;
        run_test;
		//---------------------
		// Test 12 -> NOT (op_code=0111, cin=0)
        A = 4'b1010;
		B = 4'd3; 
		op_code = 4'b0111; 
		cin = 1'b0; 
		ext_Y = ~A;
        run_test;
		//---------------------
		// Test 13 -> clear Y (op_code=1000, cin=0)
        A = 4'd15;
		B = 4'd15; 
		op_code = 4'b1000; 
		cin = 1'b0; 
		ext_Y = 4'd0;
        run_test;
		//---------------------
        // --- SPECIAL CASES ---
		//---------------------
        // Test 14 -> default Case
        $display("\n--- Testing Special Cases ---");
        op_code = 4'b1111;
        #(clk_per);
        #1;
        if (Y === 4'bx) begin
            $display("PASS: Default case. Y is %b as expected.", Y);
        end else begin
            $display("FAIL: Default case. Expected Y=xxxx, but got Y=%b", Y);
            err_cnt = err_cnt + 1;
        end
		//---------------------
        // Test 15 -> enable (en) pin
        en = 0;
        A = 4'd1;
		B = 4'd2; 
		op_code = 4'b0001;
        #(clk_per);
        #1;
        if (Y !== ext_Y) begin 
            $display("PASS: 'en=0' test. Y correctly held its previous value.");
        end else begin
            $display("FAIL: 'en=0' test. Y changed when it should have been disabled.");
            err_cnt = err_cnt + 1;
        end
        en = 1;
        #(clk_per);
        //---------------------
        // --- END OF TESTS ---
        //---------------------
        $display("\n--------------------------------------------------");
        if (err_cnt == 0) begin
            $display("All tests passed! Total errors: %0d", err_cnt);
        end else begin
            $display("Simulation finished with %0d error(s).", err_cnt);
        end
        $display("--------------------------------------------------");      
        $finish;
    end
    
    task run_test;
        begin
            #(clk_per); 
            #1;            
            
            if (Y === ext_Y) begin
                $display("--> PASS. A=%d, B=%d, cin=%b -> Y=%d", A, B, cin, Y);
            end else begin
                $display("--> FAIL. A=%d, B=%d, cin=%b -> expected Y=%d, but got Y=%d", A, B, cin, ext_Y, Y);
                err_cnt = err_cnt + 1;
            end
        end
    endtask
endmodule