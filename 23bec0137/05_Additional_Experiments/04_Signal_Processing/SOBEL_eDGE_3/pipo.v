module pipo(clk, rst, pin, q);
input clk, rst;
input [3:0] pin;
output reg [3:0] q;
always @(posedge clk or negedge rst)
begin
if(rst == 1'b0)
q = 4'b0000;
else
q = pin;  
end
endmodule

