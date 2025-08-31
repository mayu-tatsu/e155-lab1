module sev_seg(
	input  logic [2:0] s,
	output logic [6:0] seg
);

always_comb
	case(s)
		4'b0000: seg = 7'b0111111;
		4'b0001: seg = 7'b0000110;
		4'b0010: seg = 7'b1011011;
		4'b0011: seg = 7'b1001111;
		4'b0100: seg = 7'b1100110;
		4'b0101: seg = 7'b1101101;
		4'b0110: seg = 7'b1111101;
		4'b0111: seg = 7'b0000111;
		4'b1000: seg = 7'b1111111;
		4'b1001: seg = 7'b1100111;
		4'b1010: seg = 7'b1110111;
		4'b1011: seg = 7'b1111100;
		4'b1100: seg = 7'b0111001;
		4'b1101: seg = 7'b1011110;
		4'b1110: seg = 7'b1111001;
		4'b1111: seg = 7'b1110001;
		default: seg = 7'b0000000;
	endcase
endmodule