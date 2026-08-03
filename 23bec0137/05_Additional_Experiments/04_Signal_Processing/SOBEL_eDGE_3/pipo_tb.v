module pipo_tb;
reg clk, rst;
reg [3:0] pin;
wire [3:0] q;
pipo uut(clk, rst, pin, q);
initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end
initial begin
rst = 1'b0; pin = 4'b0000;
#5 
rst = 1'b1;
#10 
pin = 4'b1010;
#10 
pin = 4'b1101;
#10 
pin = 4'b0111;
#50 
$stop();
end
endmodule

