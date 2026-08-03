module srff_tb;
reg s,r,clk,rst;
wire q,qb;
srff u1(clk,rst,s,r,q,qb);
initial begin
clk=1'b0;
forever
#5
clk=~clk;
end
initial begin

rst=1'b1;s=1'b0;r=1'b1;
#5

s=1'b1;r=1'b0;
#5
s=1'b1;r=1'b1;
#5
s=1'b1;r=1'b1;
#5
$stop();
end
endmodule
