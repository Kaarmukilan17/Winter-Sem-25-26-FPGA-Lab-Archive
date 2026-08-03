module jkff(clk,rst,j,k,q,qb);
input clk,rst,j,k;
output reg q,qb;
always@(posedge clk ,rst)
begin
if(rst==1'b0)
begin
q=q;
qb=qb;
end
else if(j==1'b0 && k==1'b0)
begin
q=q;
qb=qb;
end
else if(j==1'b0 && k==1'b1)
begin
q=1'b0;
qb=~q;
end
else if(j==1'b1 && k==1'b0)
begin
q=1'b1;
qb=~q;
end
else if(j==1'b1 && k==1'b1)
begin
q=~q;
qb=~qb;
end
end
endmodule
