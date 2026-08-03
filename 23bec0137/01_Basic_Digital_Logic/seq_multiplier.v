


module seq_multiplier (
    input clk,
    input rst,
    input [3:0] m,
    input [3:0] q,
    output reg [7:0] p);
reg [3:0] a;
reg [3:0] mq;
reg c;
reg [2:0] count;
reg [4:0] s;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a <= 4'd0;
        mq <= q;
        c <= 1'b0;
        count <= 3'd0;
        p <= 8'd0;
    end
    else begin
        if (count < 4) begin
            if (mq[0]) s = a + m;
            else s = {c, a};

            {c, a, mq} <= {s, mq} >> 1;
            count <= count + 1;
        end
        else begin p <= {a, mq};end
    end
end
endmodule

/* -check error ;(

module seq_multiplier (
    input clk,
    input rst,
    
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
    
);

    reg [3:0] multiplicand, multiplier;
    reg [7:0] product;
    reg [2:0] count;
    reg c;

	//assign Q=multiplier[0];


 always @(posedge clk or posedge rst) begin
        if (rst) begin
	    multiplicand <= A;
            multiplier <= B;
            product <= {4'd0,B};
	    c<=0;
count<=0;
	end else if (count<3'd4)begin
		if (product[0]==1) begin 
			{c,product[7:4]}<={c,product[7:4]}+multiplicand;
			end
	     	{c,product}<={c,product}>>1;
		count<=count+1'b1;
             end
else
P<=product;

end
endmodule
*/


/*
module seq_mul (
    input clk,
    input rst,
    input [3:0] m,
    input [3:0] q,
    output reg [7:0] p);
reg [3:0] a;
reg [3:0] mq;
reg c;
reg [2:0] count;
reg [4:0] s;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a <= 4'd0;
        mq <= q;
        c <= 1'b0;
        count <= 3'd0;
        p <= 8'd0;
    end
    else begin
        if (count < 4) begin
            if (mq[0]) s = a + m;
            else s = {c, a};

            {c, a, mq} <= {s, mq} >> 1;
            count <= count + 1;
        end
        else begin p <= {a, mq};end
    end
end
endmodule
*/
/*

`timescale 1 ps/ 1 ps
module seq_multiplier_vlg_vec_tst();
// constants                                           
// general purpose registers
reg [3:0] A;
reg [3:0] B;
reg clk;
reg rst;
// wires                                               
wire [7:0] P;

// assign statements (if any)                          
seq_multiplier i1 (
// port map - connection between master ports and signals/registers   
	.A(A),
	.B(B),
	.P(P),
	.clk(clk),
	.rst(rst)
);
initial 
begin 
#1000000 $stop;
end 
// A[ 3 ]
initial
begin
	A[3] = 1'b1;
end 
// A[ 2 ]
initial
begin
	A[2] = 1'b0;
end 
// A[ 1 ]
initial
begin
	A[1] = 1'b1;
end 
// A[ 0 ]
initial
begin
	A[0] = 1'b1;
end 
// B[ 3 ]
initial
begin
	B[3] = 1'b1;
end 
// B[ 2 ]
initial
begin
	B[2] = 1'b1;
end 
// B[ 1 ]
initial
begin
	B[1] = 1'b0;
end 
// B[ 0 ]
initial
begin
	B[0] = 1'b1;
end 

// clk
always
begin
	clk = 1'b0;
	clk = #10000 1'b1;
	#10000;
end 

// rst
initial
begin
	rst = 1'b1;
	rst = #20000 1'b0;
end 
endmodule
*/
