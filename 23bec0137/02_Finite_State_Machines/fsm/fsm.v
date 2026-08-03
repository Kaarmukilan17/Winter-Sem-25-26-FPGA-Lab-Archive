//vending machnie fsm - 
/*



CHANGE 00 ,01,10= 0 RS,5RS,10RS;



*/
module fsm(rst,clk,x,out,change);
input clk,rst;
input [1:0]x;
output reg out;
output reg [1:0] change;
reg[1:0] p_state,n_state;

parameter S0=2'b00;
parameter S1=2'b01;
parameter S2=2'b10;

always @(posedge clk or posedge rst)begin
 if(rst)
   p_state <= S0;
      else
   p_state <= n_state;
 end

  always @(p_state or x)
  begin
             n_state = S0;
         change= 2'b00;
case(p_state)
S0: if(x == 2'b01) begin //Received 5 Rs
 n_state = S1;
 change = 2'b00;
 out = 1'b0;
end
else if(x == 2'b10) begin   //Received 10 Rs
 n_state = S2;
 change = 2'b00;
 out = 1'b0;
end
else begin
 n_state = S0;
 change = 2'b00;
 out = 1'b0;
end
S1: if(x == 2'b01) begin //Received 10(5+ 5) Rs
 n_state = S2;
 change = 2'b00;
 out = 1'b0;
end
else if(x == 2'b10) begin             //Received 15(5+10) Rs
 n_state = S0;
 out = 1'b1;
 change = 2'b00;
end
else begin
 n_state = S0;
 change = 2'b01;
 out = 1'b0;
end
S2: if(x == 2'b01) begin //Received 15(5+ 5 + 5) Rs
 n_state = S0;
 out = 1'b1;
change=2'b00;
end
else if(x == 2'b10) begin //Received 20(10+ 10) Rs
 n_state = S0;
 out = 1'b1;
 change = 2'b01;
end
else begin
 n_state = S0;
 change = 2'b10;
 out = 1'b0;
end
endcase
end

endmodule
