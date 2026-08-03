module tff(T,clk,rst,q,qb);
input T,clk,rst;
output reg q,qb;
always@(posedge clk , rst)
begin
if(rst==1'b0)
begin
q=1'b0;
qb=~q;
end
else if(T==1'b0)
begin
q=q;
qb=~q;
end
else
begin
q=~q;
qb=~qb;
end
end
endmodule
