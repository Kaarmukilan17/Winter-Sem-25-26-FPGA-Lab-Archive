
//code
module dpram(clk,rst,datain,rdaddr,rden,wraddr,wren,dataout);

input clk,rst,wren,rden;
input [9:0] rdaddr,wraddr;
input [7:0] datain;
output [7:0] dataout;

reg [7:0] mem [0:1023];

assign dataout = (rden) ? mem[rdaddr] : 8'hzz;

integer i;

always @(posedge clk)
begin
    if (rst)
    begin
        for (i=0;i<=1023;i=i+1)
            mem[i] <= 8'h0;
    end
    else if (wren)
    begin
        mem[wraddr] <= datain;
    end
end

endmodule


//testbench