// Mayu Tatsumi; mtatsumi@g.hmc.edu
// 2025-09-01

// Compares outputs of leds module to expected values
// using testvectors stored in leds_testvectors.txt.
// Outputs number of tests and errors to console.

// Note: Input s[3:0] is active low.

`timescale 1 ns / 1 ps

module leds_testbench();

	logic       clk, reset;
	logic [3:0] s;
	logic [2:0] led, ledexpected;
	
	logic [31:0] vectornum, errors;
	logic [6:0]  testvectors[10000:0];
	
	leds dut(reset, s, led);
	
	// clock generation
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
		
	// load vectors and pulse reset
	initial
		begin
			$readmemb("./leds_testvectors.txt", testvectors);
			vectornum = 0; errors = 0;
			reset = 1; #22 reset = 0;
		end
		
	// only significant inputs (no reset)
	// apply test vectors on rising edge
	always @(posedge clk)
		begin
			#1; {s, ledexpected} = testvectors[vectornum];
		end
		
	// check outputs on falling edge
	always @(negedge clk)
		if (~reset) begin
			if (led !== ledexpected) begin
				$display("Error: inputs = %b", {s});
				$display(" outputs = %b (%b expected)", led, ledexpected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 7'bx) begin
				$display("%d tests completed with %d errors",
						 vectornum, errors);
				$stop;
			end
		end	
endmodule