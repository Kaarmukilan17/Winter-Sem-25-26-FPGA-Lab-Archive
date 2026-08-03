module sipo(clk, rst, sin, q);
input clk, rst, sin;
output [3:0] q;
wire q1, q2, q3;
wire qb1, qb2, qb3, qb4;
dff d1(sin, clk, rst, q1, qb1);
dff d2(q1, clk, rst, q2, qb2);
dff d3(q2, clk, rst, q3, qb3);
dff d4(q3, clk, rst, q[0], qb4);
assign q[1] = q1;
assign q[2] = q2;
assign q[3] = q3;
endmodule

