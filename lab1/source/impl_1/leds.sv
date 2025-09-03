module leds(
	input  logic       reset,
	input  logic [3:0] s,
	output logic [2:0] led
);

	logic int_osc;
	logic [31:0] counter;
	
	// given 2.4 Hz goal, 24 MHz oscillator
	// need 2 oscillations
	// 24 * 10^6 / 2.4 / 2 = 5,000,000
	
	// counter = 0 ~ 5,000,000 : OFF
	// counter = 5,000,000 ~ 10,000,000 : ON
		
	HSOSC #(.CLKHF_DIV(2'b01))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		
	always_ff @(posedge int_osc) begin
		if      (reset == 0)             counter <= 1'b0;
		else if (counter < 32'd10000000) counter <= counter + 1;
		else 			                 counter <= 1'b0;
	end
	
	assign led[2] = (counter > 32'd5000000);

	assign led[0] = ~s[0] ^ ~s[1];
	assign led[1] = ~s[2] & ~s[3];
	
endmodule