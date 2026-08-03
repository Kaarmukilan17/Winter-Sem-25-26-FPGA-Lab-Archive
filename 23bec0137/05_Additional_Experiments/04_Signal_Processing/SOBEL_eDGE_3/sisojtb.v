module sisojtb(clk,rst,din,dout);
input clk,rst,din;
output dout;
reg[3:0]shift_reg;
always@(posedge clk or posedge rst)

begin
if(rst)
begin
shift_reg<=4'b0000;
end
else 
begin
shift_reg<={din,shift_reg[3:1]};
end
end
assign dout=shift_reg[0];
endmodule
