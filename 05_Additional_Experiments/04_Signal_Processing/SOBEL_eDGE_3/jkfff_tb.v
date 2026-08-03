module jkfff_tb;
reg j,k,clk,rst;
wire q,qb;
jkff u1(clk,rst,j,k,q,qb);
initial begin
clk=1'b0;
forever
#5
clk=~clk;
end
initial begin
rst=1'b0;j=1'b0;k=1'b0;
#5 
rst=1'b1;j=1'b0;k=1'b0;
#5 
j=1'b0;k=1'b1;
#5
j=1'b1;k=1'b0;
#5
j=1'b1;k=1'b1;
#5
$stop();
end
endmodule
