module dff_tb;
reg d,clk,rst;
wire q,qb;
dff u1(d,clk,rst,q,qb);
initial begin
clk=1'b0;
forever
#5
clk=~clk;
end
initial begin
rst=1'b0;d=1'b0;
#5 
rst=1'b1;d=1'b0;
#5 
d=1'b0;
#5
d=1'b1;
#5
$stop();
end
endmodule
