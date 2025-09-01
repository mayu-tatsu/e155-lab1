`timescale 1 ns / 1 ps

module leds_testbench();

	logic       clk, reset;
	logic [3:0] s;
	logic [2:0] led, ledexpected;
	
	logic [31:0] vectornum, errors;
	logic [6:0]  testvectors[10000:0];
	
	leds dut(clk, reset, s, led);
	
	// clock
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
		
	// only significant inputs (no clk, reset)
	// apply test vectors on rising edge
	always @(posedge clk)
		begin
			#1; {s, ledexpected} = testvectors[vectornum];
		end
		
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