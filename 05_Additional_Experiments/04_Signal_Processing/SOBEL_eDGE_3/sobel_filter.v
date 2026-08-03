
module sobel_edge_detection #(parameter WIDTH = 8) ( 
input wire clk, // Clock signal 
input wire rst, // Reset signal 
input wire [WIDTH-1:0] pixel_in, // Input pixel (current pixel) 
input wire [WIDTH-1:0] pixel_in_top, // Pixel above the current pixel 
input wire [WIDTH-1:0] pixel_in_bottom, // Pixel below the current pixel 
input wire [WIDTH-1:0] pixel_in_left, // Pixel to the left 
input wire [WIDTH-1:0] pixel_in_right, // Pixel to the right 
input wire [WIDTH-1:0] pixel_in_tl, // Top-left corner pixel 
input wire [WIDTH-1:0] pixel_in_tr, // Top-right corner pixel 
input wire [WIDTH-1:0] pixel_in_bl, // Bottom-left corner pixel 
input wire [WIDTH-1:0] pixel_in_br, // Bottom-right corner pixel 
output reg [WIDTH-1:0] edge_out, // Output edge strength 
output reg ready // Ready signal indicating output is valid 
); 
// Sobel kernels for X and Y direction 
// Sobel X kernel 
reg signed [WIDTH-1:0] sobel_x [0:2][0:2]; // 3x3 kernel for X direction 
// Sobel Y kernel 
reg signed [WIDTH-1:0] sobel_y [0:2][0:2]; // 3x3 kernel for Y direction 
// Temporary variables to hold the gradient sums 
reg signed [15:0] gradient_x; 
reg signed [15:0] gradient_y; 
reg signed [15:0] gradient_magnitude; 
// Process the input on each clock cycle 
always @(posedge clk or posedge rst) begin 
if (rst) begin // Initialize Sobel kernels 
sobel_x[0][0] = -1; sobel_x[0][1] = 0; sobel_x[0][2] = 1; //Sobel X kernel for detecting horizontal edges 
sobel_x[1][0] = -2; sobel_x[1][1] = 0; sobel_x[1][2] = 2; 
sobel_x[2][0] = -1; sobel_x[2][1] = 0; sobel_x[2][2] = 1; 
sobel_y[0][0] = -1; sobel_y[0][1] = -2; sobel_y[0][2] = -1; // Sobel Y kernel for detecting vertical edges 
sobel_y[1][0] = 0; sobel_y[1][1] = 0; sobel_y[1][2] = 0; 
sobel_y[2][0] = 1; sobel_y[2][1] = 2; sobel_y[2][2] = 1; 
gradient_x <= 0; 
gradient_y <= 0; 
gradient_magnitude <= 0; 
edge_out <= 0; 
ready <= 0; 
end 
else begin 
// Calculate the gradient in X direction 
gradient_x <= (sobel_x[0][0] * pixel_in_tl) + (sobel_x[0][1] * pixel_in_top) + (sobel_x[0][2] * 
pixel_in_tr) + 
(sobel_x[1][0] * pixel_in_left) + (sobel_x[1][1] * pixel_in) + (sobel_x[1][2] * pixel_in_right) + 
(sobel_x[2][0] * pixel_in_bl) + (sobel_x[2][1] * pixel_in_bottom) + (sobel_x[2][2] * pixel_in_br); 
// Calculate the gradient in Y direction 
gradient_y <= (sobel_y[0][0] * pixel_in_tl) + (sobel_y[0][1] * pixel_in_top) + (sobel_y[0][2] * 
pixel_in_tr) + 
(sobel_y[1][0] * pixel_in_left) + (sobel_y[1][1] * pixel_in) + (sobel_y[1][2] * pixel_in_right) + 
(sobel_y[2][0] * pixel_in_bl) + (sobel_y[2][1] * pixel_in_bottom) + (sobel_y[2][2] * pixel_in_br); 
// Calculate the gradient magnitude (simplified: no square root) 
gradient_magnitude <= (gradient_x * gradient_x) + (gradient_y * gradient_y); 
edge_out <= (gradient_magnitude[15:8] > 8'd255) ? 8'd255 : gradient_magnitude[15:8]; // Saturate if 255 
// Signal that the result is ready 
ready <= 1; 
end 
end 
endmodule


`timescale 1ns / 1ps

module tb_sobel_edge_detection;

    
    parameter WIDTH = 8;

   
    reg clk;
    reg rst;
    reg [WIDTH-1:0] pixel_in;
    reg [WIDTH-1:0] pixel_in_top;
    reg [WIDTH-1:0] pixel_in_bottom;
    reg [WIDTH-1:0] pixel_in_left;
    reg [WIDTH-1:0] pixel_in_right;
    reg [WIDTH-1:0] pixel_in_tl;
    reg [WIDTH-1:0] pixel_in_tr;
    reg [WIDTH-1:0] pixel_in_bl;
    reg [WIDTH-1:0] pixel_in_br;

    
    wire [WIDTH-1:0] edge_out;
    wire ready;

    
    sobel_edge_detection #(WIDTH) uut (
        .clk(clk), 
        .rst(rst), 
        .pixel_in(pixel_in), 
        .pixel_in_top(pixel_in_top), 
        .pixel_in_bottom(pixel_in_bottom), 
        .pixel_in_left(pixel_in_left), 
        .pixel_in_right(pixel_in_right), 
        .pixel_in_tl(pixel_in_tl), 
        .pixel_in_tr(pixel_in_tr), 
        .pixel_in_bl(pixel_in_bl), 
        .pixel_in_br(pixel_in_br), 
        .edge_out(edge_out), 
        .ready(ready)
    );

    
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
       
        clk = 0;
        rst = 1;
        pixel_in = 0; pixel_in_top = 0; pixel_in_bottom = 0;
        pixel_in_left = 0; pixel_in_right = 0;
        pixel_in_tl = 0; pixel_in_tr = 0; pixel_in_bl = 0; pixel_in_br = 0;

        
        #20 rst = 0;
        #10;

        
        $display("Test Case 1:");
        pixel_in = 100; pixel_in_top = 100; pixel_in_bottom = 100;
        pixel_in_left = 100; pixel_in_right = 100;
        pixel_in_tl = 100; pixel_in_tr = 100; pixel_in_bl = 100; pixel_in_br = 100;
        #50; 

        
        $display(" Test Case 2: Vertical Edge");
        pixel_in_tl = 10; pixel_in_top = 10; pixel_in_tr = 200;
        pixel_in_left = 10; pixel_in = 10; pixel_in_right = 200;
        pixel_in_bl = 10; pixel_in_bottom = 10; pixel_in_br = 200;
        #50;

        $display(" Test Case 3: Horizontal Edge");
        pixel_in_tl = 10; pixel_in_top = 10; pixel_in_tr = 10;
        pixel_in_left = 10; pixel_in = 10; pixel_in_right = 10;
        pixel_in_bl = 200; pixel_in_bottom = 200; pixel_in_br = 200;
        #50;

       
        pixel_in = 0; pixel_in_top = 0; pixel_in_bottom = 0;
        pixel_in_left = 0; pixel_in_right = 0;
        pixel_in_tl = 0; pixel_in_tr = 0; pixel_in_bl = 0; pixel_in_br = 0;

       
        #50;

        
        $display("Simulation Complete.");
        $finish;
    end

    

endmodule