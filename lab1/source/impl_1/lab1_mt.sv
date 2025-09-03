// Mayu Tatsumi; mtatsumi@g.hmc.edu
// 2025-09-01

// Instantiates leds and sev_seg modules using same s input.

// Note: Input s[3:0] and output seg[6:0] are active low.

module lab1_mt(
	input  logic       reset,
	input  logic [3:0] s,
	output logic [2:0] led,
	output logic [6:0] seg
);
	
	leds led1(reset, s, led);
	sev_seg segments(s, seg);
	
	
endmodule