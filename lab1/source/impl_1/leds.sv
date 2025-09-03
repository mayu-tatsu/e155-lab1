// Mayu Tatsumi; mtatsumi@g.hmc.edu
// 2025-09-01

// Uses a high-speed internal oscillator to blink an LED at ~2.4 Hz.
// Also lights two other LEDs based on the values of a 4-bit input.

// Note: Input s[3:0] is active low.

module leds(
	input  logic       reset,
	input  logic [3:0] s,
	output logic [2:0] led
);

	logic int_osc;
	logic [31:0] counter;
		
	HSOSC #(.CLKHF_DIV(2'b01))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

	// given 2.4 Hz goal, 24 MHz oscillator
	
	// counter = 0 ~ 5,000,000 : OFF
	// counter = 5,000,000 ~ 10,000,000 : ON
		
	always_ff @(posedge int_osc) begin
		if      (reset == 0)             counter <= 1'b0;
		else if (counter < 32'd10000000) counter <= counter + 1;
		else 			                 counter <= 1'b0;
	end
	
	assign led[2] = (counter > 32'd5000000);

	assign led[0] = ~s[0] ^ ~s[1]; // XOR
	assign led[1] = ~s[2] & ~s[3]; // AND
	
endmodule