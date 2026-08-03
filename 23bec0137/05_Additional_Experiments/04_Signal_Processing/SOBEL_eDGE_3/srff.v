module srff(clk,rst,s,r,q,qb);
input clk,rst,s,r;
output reg q,qb;
always@(posedge clk , rst)
begin
if(rst==1'b0)
begin
q=q;
qb=qb;
end
else if(s==1'b0 && r==1'b0)
begin
q=q;
qb=qb;
end
else if(s==1'b0 && r==1'b1)
begin
q=1'b0;
qb= ~q;
end
else if(s==1'b1 && r==1'b0)
begin
q=1'b1;
qb=~q;
end
else if(s==1'b1 && r==1'b1)
begin
q=1'bX;qb=~q;
end
end
endmodule

