`timescale 1ns/1ps

module tb_dpram;
reg clk;
reg [7:0] din;
reg [4:0] raddr;
reg [4:0] waddr;
reg we;
wire [7:0] q;

dp_ram_ip U1 (
    .clock(clk),
    .data(din),
    .rdaddress(raddr),
    .wraddress(waddr),
    .wren(we),
    .q(q)
);
always #5 clk = ~clk;
initial begin
    clk = 0;
    din = 0;
    raddr = 0;
    waddr = 0;
    we = 0;
    // WRITE
    #10 we = 1; waddr = 5'd1;  din = 8'h11;
    #10 we = 1; waddr = 5'd5;  din = 8'h55;
    #10 we = 1; waddr = 5'd10; din = 8'hAA;
    // READ
    #10 we = 0; raddr = 5'd1;
    #10 raddr = 5'd5;
    #10 raddr = 5'd10;
    // SIMULTANEOUS READ + WRITE
    #10 we = 1; waddr = 5'd15; din = 8'hF0;
        raddr = 5'd5;
    // SAME ADDRESS
    #10 waddr = 5'd20; raddr = 5'd20; din = 8'h77;
    #10 we = 0;
    #20 $finish;
end
endmodule