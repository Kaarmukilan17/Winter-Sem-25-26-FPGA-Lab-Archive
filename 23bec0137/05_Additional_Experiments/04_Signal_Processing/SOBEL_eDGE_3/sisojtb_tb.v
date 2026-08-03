module sisojtb_tb;
reg clk,rst,din;
wire dout;
sisojtb uut(clk,rst,din,dout);
always #5 clk=~clk;
initial
begin
clk=0;
rst=1;
din=0;
#10
rst=0;
#10
din=0;
#10
din=0;
#10
din=1;
#10
din=1;
#10
din=0;
#10
din=0;
#10
din=0;
#10
din=0;

#20
$finish;
end
endmodule

