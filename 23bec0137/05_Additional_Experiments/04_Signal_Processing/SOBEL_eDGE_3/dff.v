module dff(d,clk,rst,q,qb);
input d,clk,rst;
output reg q,qb;
always@(posedge clk ,rst)
begin
if(rst==1'b0)
begin
q=1'b0;
qb=~q;
end
else if(d==1'b0)
begin
q=1'b0;
qb=~q;
end
else if(d==1'b1)
begin
q=1'b1;
qb=~q;
end
end
endmodule
