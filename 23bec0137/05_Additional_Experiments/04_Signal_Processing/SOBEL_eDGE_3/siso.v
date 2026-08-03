module siso(clk, rst, sin, sout);
input clk, rst, sin;
output sout;
wire q1, q2, q3;
wire qb1, qb2, qb3, qb4;
dff d1(sin, clk, rst, q1, qb1);
dff d2(q1, clk, rst, q2, qb2);
dff d3(q2, clk, rst, q3, qb3);
dff d4(q3, clk, rst, sout, qb4);
endmodule

