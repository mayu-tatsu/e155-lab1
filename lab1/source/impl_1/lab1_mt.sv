module lab1_mt(
	input  logic       clk,
	input  logic [3:0] s,
	output logic [2:0] led,
	output logic [6:0] seg
);

	logic reset;
	
	leds led1(clk, reset, s, led, seg);
	sev_seg segments(s, seg);
	
	
endmodule