module SEQ_MUL ( 
    input        clk, 
    input        rst, 
    input  [3:0] A, 
    input  [3:0] B, 
    output reg [7:0] Z 
); 
    reg [3:0] M;        
    reg [3:0] Acc;      
    reg [3:0] Q;        
    reg       C;        
    reg [3:0] count; 
    always @(posedge clk or posedge rst) begin 
        if (rst) begin 
            Acc   <= 0; 
            Q     <= B; 
            M     <= A; 
            C     <= 0; 
            count <= 0; 
            Z     <= 0; 
        end 
        else if (count < 4) begin 
             
            if (Q[0]) 
                {C, Acc, Q} <= ({1'b0, Acc, Q} + {1'b0, 
M, 4'b0}) >> 1; 
            else 
                {C, Acc, Q} <= {1'b0, Acc, Q} >> 1; 
 
            count <= count + 1; 
        end 
        else begin 
            Z <= {Acc, Q}; 
        end 
    end 
endmodule 
 
//23bec0137 KAARMUKILAN A G 
`timescale 1ns/1ps 
 
module tb_SEQ_MUL; 
    reg clk; 
    reg rst; 
    reg [3:0] A; 
    reg [3:0] B; 
    wire [7:0] Z; 
    SEQ_MUL dut (clk,rst, A,B,Z); 
 
    always #5 clk = ~clk; 
    initial begin 
              clk = 0; 
        A   = 0; 
        B   = 0; 
 #5 rst=1; 
 A = 4'd3; 
        B = 4'd5; 
        #20 rst = 0; 
        #100;//4 clk cycle 
        rst = 1; 
        A = 4'd7; 
        B = 4'd9; 
        #10 rst = 0; 
        #100; 
        
        $stop; 
    end 
 
endmodule