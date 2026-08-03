module clock_23BEC0137(
	input CLOCK_50, 
	input reset_n, 
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5
);

reg [5:0] sec;
reg [5:0] min;
reg [4:0] hr;

// CLOCK DIVIDER (1 Hz)
reg [31:0] clk_counter;
reg tick_1s;

always @(posedge CLOCK_50 or negedge reset_n) begin
	if (!reset_n) begin
		clk_counter <= 0;
		tick_1s <= 0;
	end
	else if (clk_counter == 50_000_000 - 1) begin
		clk_counter <= 0;
		tick_1s <= 1;
	end
	else begin
		clk_counter <= clk_counter + 1;
		tick_1s <= 0;
	end
end


// TIME LOGIC
always @(posedge CLOCK_50 or negedge reset_n) begin
	if (!reset_n) begin
		sec <= 0;
		min <= 0;
		hr  <= 0;
	end
	else if (tick_1s) begin
		if (sec == 59) begin
			sec <= 0;

			if (min == 59) begin
				min <= 0;

				if (hr == 23)
					hr <= 0;
				else
					hr <= hr + 1;
			end
			else
				min <= min + 1;
		end
		else
			sec <= sec + 1;
	end
end


// DIGIT SPLIT
wire [3:0] seconds_unit = sec % 10;
wire [3:0] seconds_tens = sec / 10;

wire [3:0] minutes_unit = min % 10;
wire [3:0] minutes_tens = min / 10;

wire [3:0] hours_unit = hr % 10;
wire [3:0] hours_tens = hr / 10;


// KEEPING YOUR ORIGINAL INSTANCE STYLE
segment7 s0({1'b0,seconds_unit}, HEX0);
segment7 s1({1'b0,seconds_tens}, HEX1);
segment7 s2({1'b0,minutes_unit}, HEX2);
segment7 s3({1'b0,minutes_tens}, HEX3);
segment7 s4({1'b0,hours_unit}, HEX4);
segment7 s5({1'b0,hours_tens}, HEX5);

endmodule



module segment7(
 input [3:0] sevenseg,   // renamed from bcd
 output reg [6:0] segments
);
 always @(*) begin
 case (sevenseg)
	 4'd0: segments = 7'b1000000;
	 4'd1: segments = 7'b1111001;
	 4'd2: segments = 7'b0100100;
	 4'd3: segments = 7'b0110000;
	 4'd4: segments = 7'b0011001;
	 4'd5: segments = 7'b0010010;
	 4'd6: segments = 7'b0000010;
	 4'd7: segments = 7'b1111000;
	 4'd8: segments = 7'b0000000;
	 4'd9: segments = 7'b0010000;
	 default: segments = 7'b1111111;
 endcase
 end
endmodule