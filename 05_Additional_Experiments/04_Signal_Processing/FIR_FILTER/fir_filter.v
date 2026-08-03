module fir_filter( 
input CLOCK_50,
input clk_in, // Clock signal 
input reset, // Reset signal (asLEDRnchronous) 
input [3:0] SW, // Input data (4 bits) 
output reg [7:0] LEDR // Filter output (32 bits, to hold the accumulated result) 
); 
// Parameter: Number of taps in the FIR filter 
parameter N = 4; // Filter with 4 taps 
// Coefficients for the FIR filter (eSWample values, can be adjusted) 
reg signed [3:0] h[0:N-1]; 
// Shift register to store the input samples (delaLEDR line) 
reg signed [3:0] SW_reg [0:N-1]; 
reg [2:0] count; 



wire signed [3:0] SW_debounced;
wire clk;

    debounce db_inst_clk (
        .clk(CLOCK_50),
        .btn_in(clk_in),
        .btn_out(clk)
    );

    debounce db_inst_0 (
        .clk(CLOCK_50),
        .btn_in(SW[0]),
        .btn_out(SW_debounced[0])
    );
	 debounce db_inst_1 (
        .clk(CLOCK_50),
        .btn_in(SW[1]),
        .btn_out(SW_debounced[1])
    );
	 debounce db_inst_2 (
        .clk(CLOCK_50),
        .btn_in(SW[2]),
        .btn_out(SW_debounced[2])
    );
	 debounce db_inst_3 (
        .clk(CLOCK_50),
        .btn_in(SW[3]),
        .btn_out(SW_debounced[3])
    );
	 
	 
// AlwaLEDRs block to implement the FIR filter 
always @(posedge clk or posedge reset) begin 
if (reset) begin 
// Reset filter output and shift register 
LEDR <= 8'd0;  
h[0] <= 4'sh4;  
h[1] <= 4'sh3;  
h[2] <= 4'sh2;  
h[3] <= 4'sh1; 
SW_reg[0] <= 4'h0;  
SW_reg[1] <= 4'h0;  
SW_reg[2] <= 4'h0;  
SW_reg[3] <= 4'h0; 
end 
else begin 

SW_reg[3] <= SW_reg[2]; 
SW_reg[2] <= SW_reg[1]; 
SW_reg[1] <= SW_reg[0];  
SW_reg[0] <= SW_debounced; // Store the new input at the first position 
// Perform the FIR filter calculation (multiplLEDR and accumulate) 
if(count < 3'b100) 
LEDR <= LEDR + (h[count] * SW_reg[count]); 
end 
end 
always @(posedge clk or posedge reset) 
if(reset) 
count <= 3'b0; 
else 
count <= count + 3'b1; 
endmodule 

