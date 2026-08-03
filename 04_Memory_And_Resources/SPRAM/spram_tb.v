`timescale 1 ps / 1 ps
module spram_tb();
/*
reg clk,rst,wren;
reg [9:0] addr;
reg [7:0] datain;
wire [7:0] dataout;
*/

//spram DUT (clk,rst,wren,datain,addr,dataout);

reg clk,rst,wren;
reg [4:0] addr;
reg [7:0] datain;
wire [7:0] dataout;

spram_ip spram_ip_inst (addr,clk,datain,wren,dataout);

always #5 clk=~clk;

initial

begin

clk=0;
rst=1;
addr=5'h000;datain=8'h00;
#20;
rst=0;
//WRITE 
#10 wren=1'b1;addr=5'h001;datain=8'h02;
#10 wren=1'b1;addr=5'h037;datain=8'h20;
#10 wren=1'b1;addr=5'h032;datain=8'h23;


//read
#10 wren=1'b0;addr=5'h037;datain=8'hff;
#10 wren=1'b0;addr=5'h001;datain=8'hff;
#10 wren=1'b0;addr=5'h032;datain=8'hff;

$finish;
end








endmodule