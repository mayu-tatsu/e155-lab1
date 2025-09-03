`timescale 1 ns / 1 ps

module lab1_mt_testbench();

	logic       clk, reset;
	logic [3:0] s;
	logic [2:0] led, ledexpected;
	logic [6:0] seg, segexpected;
	
	logic [31:0] vectornum, errors;
	logic [13:0]  testvectors[10000:0];
	
	lab1_mt dut(reset, s, led, seg);
	
	// clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
		
	// load vectors and pulse reset
	initial
		begin
			$readmemb("./lab1_mt_testvectors.txt", testvectors);
			vectornum = 0; errors = 0;
			reset = 1; #22 reset = 0;
		end
		
	// only significant inputs (no clk, reset)
	// apply test vectors on rising edge
	always @(posedge clk)
		begin
			#1; {s, ledexpected, segexpected} = testvectors[vectornum];
		end
		
	always @(negedge clk)
		if (~reset) begin
			if (led !== ledexpected) begin
				$display("Error: inputs = %b", {s});
				$display(" outputs = %b (%b expected)", led, ledexpected);
				errors = errors + 1;
			end
			else if (seg !== segexpected) begin
				$display("Error: inputs = %b", {s});
				$display(" outputs = %b (%b expected)", seg, segexpected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 14'bx) begin
				$display("%d tests completed with %d errors",
						 vectornum, errors);
				$stop;
			end
		end	
endmodule