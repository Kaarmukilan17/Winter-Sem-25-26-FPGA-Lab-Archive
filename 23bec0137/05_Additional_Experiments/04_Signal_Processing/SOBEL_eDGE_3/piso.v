module piso(clk, rst, load, pin, sout);
input clk, rst, load;
input [3:0] pin;
output sout;
reg [3:0] temp;
always @(posedge clk or negedge rst)
begin
if(rst == 1'b0)
temp = 4'b0000;
else if(load == 1'b1)
temp = pin;            
else
temp = {1'b0, temp[3:1]};
end
assign sout = temp[0];
endmodule

