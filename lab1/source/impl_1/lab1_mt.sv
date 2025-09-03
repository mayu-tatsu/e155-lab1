module lab1_mt(
	input  logic       reset,
	input  logic [3:0] s,
	output logic [2:0] led,
	output logic [6:0] seg
);
	
	leds led1(reset, s, led);
	sev_seg segments(s, seg);
	
	
endmodule