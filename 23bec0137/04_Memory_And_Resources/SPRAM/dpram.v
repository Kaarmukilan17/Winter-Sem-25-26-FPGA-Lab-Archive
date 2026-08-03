
module dpram(clk,rst,wren,datain,addr,dataout);


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


module spram_tb();

reg clk,rst,wren;
reg [9:0] addr;
reg [7:0] datain;
wire [7:0] dataout;

spram DUT (clk,rst,wren,datain,addr,dataout);


always #5 clk=~clk;

initial

begin

clk=0;
rst=1;
addr=10'h000;datain=8'h00;
#20;
rst=0;
//WRITE 
#10 wren=1'b1;addr=10'h001;datain=8'h02;
#10 wren=1'b1;addr=10'h037;datain=8'h20;
#10 wren=1'b1;addr=10'h032;datain=8'h23;


//read
#10 wren=1'b0;addr=10'h037;datain=8'hff;
#10 wren=1'b0;addr=10'h001;datain=8'hff;
#10 wren=1'b0;addr=10'h032;datain=8'hff;

$finish;
end








endmodule