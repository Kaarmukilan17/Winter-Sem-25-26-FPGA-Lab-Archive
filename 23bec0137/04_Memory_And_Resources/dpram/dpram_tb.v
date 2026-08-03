
module dpram_tb();

reg clk,rst,wren,rden;
reg [9:0] rdaddr,wraddr;
reg [7:0] datain;
wire [7:0] dataout;

dpram DUT (clk,rst,datain,rdaddr,rden,wraddr,wren,dataout);

always #5 clk=~clk;

initial
begin

clk=0;
rst=1;
rdaddr=10'h000;
wraddr=10'h000;
datain=8'h00;
rden=0;
wren=0;

#20;
rst=0;


// WRITE ONLY (01)

#10 wren=1'b1; rden=0; wraddr=10'h001; datain=8'h02;
#10 wren=1'b1; rden=0; wraddr=10'h037; datain=8'h20;
#10 wren=1'b1; rden=0; wraddr=10'h032; datain=8'h23;


// READ ONLY (10)

#10 wren=0; rden=1'b1; rdaddr=10'h037;
#10 rdaddr=10'h001;
#10 rdaddr=10'h032;

// SIMULTANEOUS (11)

#10 wren=1'b1; rden=1'b1;
wraddr=10'h050; datain=8'hAA;
rdaddr=10'h037;


//SAME ADDRESS CONFLICT
#10 wraddr=10'h060; rdaddr=10'h060;
datain=8'hBB;

// no read/write
#10 wren=0; rden=0;

$finish;

end

endmodule