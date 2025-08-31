module leds(
	input  logic       clk,
	input  logic       reset,
	input  logic [3:0] s,
	output logic [2:0] led,
	output logic [6:0] seg
);

	logic int_osc;
	logic [31:0] counter;
	// logic [31:0] q;
	
	// 24*10^6 * 430 / 2^32 = 2.402 Hz
	// 24MHz oscillator
	// 2 (up + down), 2.4 Hz goal
	// check 5 MHz = 5,000,000
	
	HSOSC #(.CLKHF_DIV(2'b01))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		
	// localparam p = 430;
		
	// always_ff @(posedge int_osc) begin
	// 	if (reset) 		q <= 0;
	//	else if (q < 32'd13760) 	q <= q+p;
	//	else 	   		q <= 0;
	// end
	
	always_ff @(posedge int_osc) begin
		if (reset == 0) counter <= 0;
		else 			counter <= counter + 1;
	end
			
	assign led[2] = counter[22];
	
	assign led[0] = ~s[0] ^ ~s[1];
	assign led[1] = ~s[2] & ~s[3];
	
endmodule