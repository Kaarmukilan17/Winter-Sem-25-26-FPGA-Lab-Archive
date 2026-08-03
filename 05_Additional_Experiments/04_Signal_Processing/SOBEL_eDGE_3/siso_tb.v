module siso_tb;
reg clk, rst, sin;
wire sout;
siso uut(clk, rst, sin, sout);
initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end
initial begin
rst = 1'b0; sin = 1'b0;
#5 
rst = 1'b1;
#10 
sin = 1'b1;
#10 
sin = 1'b0;
#10 
sin = 1'b1;
#10 
sin = 1'b1;
#10 
sin = 1'b0;
#50 
$stop();
end
endmodule

