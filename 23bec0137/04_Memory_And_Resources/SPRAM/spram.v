
module spram(clk,rst,wren,datain,addr,dataout);


input clk,rst,wren;
input [9:0] addr;
input [7:0] datain;
output [7:0] dataout;

reg [7:0] mem [0:1023];

//reg [7:0] temp;
assign dataout=(wren)?(8'hzz):(mem[addr]);

//assign dataout= mem[addr];
integer i;
always @(posedge clk)
begin
	if (rst)
		begin
		for (i=0;i<=1023;i=i+1) begin
			mem[i]<=8'h0;
				end
		end

	else if (wren) begin
		mem[addr]<=datain;
	end	

end

endmodule


