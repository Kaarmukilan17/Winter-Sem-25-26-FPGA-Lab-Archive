module counter_down(input clk, reset, output [3:0]counter);

reg [3:0] counter_down;
always @(posedge clk or posedge reset)
begin
if(reset)
counter_down<=4'b0000;
else
counter_down<=counter_down-1'b1;
end
assign counter = counter_down;
endmodule


module tb_counter_down();
reg clk, reset;
wire [3:0]counter;
counter_down x1(clk, reset, counter);
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
