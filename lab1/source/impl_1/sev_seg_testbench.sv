// Mayu Tatsumi; mtatsumi@g.hmc.edu
// 2025-09-01

// Compares outputs of sev_seg module to expected values
// using testvectors stored in sev_seg_testvectors.txt.
// Outputs number of tests and errors to console.

// Note: Input and output are active low.

`timescale 1 ns / 1 ps

module sev_seg_testbench();

	logic       clk, reset;
	logic [3:0] s;
	logic [6:0] seg, segexpected;
	
	logic [31:0] vectornum, errors;
	logic [10:0]  testvectors[10000:0];
	
	sev_seg dut(s, seg);
	
	// clock generation
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
		
	// load vectors and pulse reset
	initial
		begin
			$readmemb("./sev_seg_testvectors.txt", testvectors);
			vectornum = 0; errors = 0;
			reset = 1; #22 reset = 0;
		end
		
	// only significant inputs (n0 reset)
	// apply test vectors on rising edge
	always @(posedge clk)
		begin
			#1; {s, segexpected} = testvectors[vectornum];
		end
		
	// check outputs on falling edge
	always @(negedge clk)
		if (~reset) begin
			if (seg !== segexpected) begin
				$display("Error: inputs = %b", {s});
				$display(" outputs = %b (%b expected)", seg, segexpected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 11'bx) begin
				$display("%d tests completed with %d errors",
						 vectornum, errors);
				$stop;
			end
		end
endmodule