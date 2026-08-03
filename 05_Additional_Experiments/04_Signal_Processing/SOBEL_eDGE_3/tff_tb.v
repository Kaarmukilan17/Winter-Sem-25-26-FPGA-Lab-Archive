module tb_tff;
reg T,clk,rst;
wire q,qb;
tff u1(T,clk,rst,q,qb);
initial begin
clk=1'b0;
forever
#5
clk=~clk;
end
initial begin
rst=1'b0;T=1'b0;
#5 
rst=1'b1;T=1'b0;
#5 
T=1'b0;
#5
T=1'b1;
#5
$stop();
end
endmodule