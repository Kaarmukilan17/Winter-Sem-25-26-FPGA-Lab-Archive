module moore_vending_machine(x,clk,rst,out,change);

input [1:0]x;
input rst;
input clk;
output out;
output [1:0]change;

reg [2:0] temp;

parameter S0 = 3'b000,
S1=3'b001,
S2=3'b010,
S3=3'b011,
S4=3'b100,
S5=3'b101,
S6=3'b110;

reg [2:0]p_state,n_state;

always @(posedge clk or posedge rst) begin
    if(rst)
       p_state <= S0;
    else 
       p_state <= n_state;
end

always @(*) begin
    n_state = p_state;
    case(p_state)

    S0,S3,S4,S5,S6: begin
        if(x==2'b00) begin
            n_state = S0;
        end
        else if(x==2'b01) begin
            n_state = S1;
        end
        else if(x==2'b10) begin
            n_state = S2;
        end
        else begin
            n_state = S0;
        end
    end

    S1: begin
        if(x==2'b00) begin
            n_state = S4;
           
        end
        else if(x==2'b01) begin
            n_state = S2;
           
        end
        else if(x==2'b10) begin
            n_state = S3;
           
        end
        else begin
            n_state = S0;
       
        end
    end

    S2: begin
        if(x==2'b00) begin
            n_state = S5;
           
        end
        else if(x==2'b01) begin
            n_state = S3;
           
        end
        else if(x==2'b10) begin
            n_state = S6;
           
        end
        else begin
            n_state = S0;
        end

    end

    default n_state = S0;


    endcase
   

end

//OUTPUT LOGIC
always @(*) begin
    case(p_state)
        S0: temp = 3'b000;
        S1: temp = 3'b000;
        S2: temp = 3'b000;
        S3: temp = 3'b001; 
        S4: temp = 3'b010; 
        S5: temp = 3'b100;
        S6: temp = 3'b011;
        default: temp = 3'b000;
    endcase
end

assign out = temp[0];
assign change = temp[2:1];


endmodule