module piso_tb;
reg clk, rst, load;
reg [3:0] pin;
wire sout;
piso uut(clk, rst, load, pin, sout);
initial begin
clk = 1'b0;
forever 
#5 
clk = ~clk;
end
initial begin
rst = 1'b0; load = 1'b0; pin = 4'b0000;
#5 
rst = 1'b1;
#10 
load = 1'b1; pin = 4'b1011; 
#10 
load = 1'b0;                
#50 
$stop();
end
endmodule

