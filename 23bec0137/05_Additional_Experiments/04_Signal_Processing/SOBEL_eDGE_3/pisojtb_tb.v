module pisojtb_tb;
reg clk,rst,load;
reg[3:0]pin;
wire dout;
pisojtb uut(clk,rst,load,pin,dout);
always #5 clk=~clk;
initial
begin
clk=0;
rst=1;
load=0;
pin=4'b0000;
#10
rst=0;
#10
pin=4'b1100;
load=1;
#10
load=0;
#10
load=0;
#10
load=0;
#10
load=0;
#10

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    $finish;
end
endmodule
