module counter_up(input clk, reset, output [3:0]counter);

reg [3:0] counter_up;
always @(posedge clk or posedge reset)
begin
if(reset)
counter_up<=4'b0000;
else
counter_up<=counter_up+1'b1;
end
assign counter = counter_up;
endmodule


module tb_counter();
reg clk, reset;
wire [3:0]counter;
counter_up x1(clk, reset, counter);
initial
begin
clk = 0;
forever #5 clk = ~clk;
end
initial

begin
reset = 1;
#20;
reset = 0;

end
endmodule