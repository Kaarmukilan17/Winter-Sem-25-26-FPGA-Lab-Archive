module fir_filter( 
input clk, // Clock signal 
input reset, // Reset signal (asynchronous) 
input [2:0] x, // Input data (3 bits) 
output reg [5:0] y // Filter output (32 bits, to hold the accumulated result) 
); 
// Parameter: Number of taps in the FIR filter 
parameter N = 4; // Filter with 4 taps 
// Coefficients for the FIR filter (example values, can be adjusted) 
reg signed [2:0] h[0:N-1]; 
// Shift register to store the input samples (delay line) 
reg signed [2:0] x_reg [0:N-1]; 
reg signed [2:0] x_h [0:N-1]; 
//reg [2:0] count; 
// Always block to implement the FIR filter 
always @(posedge clk or posedge reset) begin 
if (reset) begin 
// Reset filter output and shift register 
y <= 32'd0;  
h[0] <= 3'sh4;  
h[1] <= 3'sh3;  
h[2] <= 3'sh2;  
h[3] <= 3'sh1; 
x_reg[0] <= 3'h0;  
x_reg[1] <= 3'h0;  
x_reg[2] <= 3'h0;  
x_reg[3] <= 3'h0; 
x_h[0] <= 3'h0;  
x_h[1] <= 3'h0;  
x_h[2] <= 3'h0;  
x_h[3] <= 3'h0; 
end 
else begin 

x_reg[3] <= x_reg[2]; 
x_reg[2] <= x_reg[1]; 
x_reg[1] <= x_reg[0];  
x_reg[0] <= x; // Store the new input at the first position 



x_h[0] <= x_reg[0]*h[0];  
x_h[1] <= x_reg[1]*h[1];  
x_h[2] <= x_reg[2]*h[2];  
x_h[3] <= x_reg[3]*h[3]; 


y <= x_h[0]+x_h[1]+x_h[2]+x_h[3];
end 
end
endmodule 