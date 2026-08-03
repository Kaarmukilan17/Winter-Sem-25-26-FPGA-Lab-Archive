module clock ( 
    input CLOCK_50,        // 50 MHz clock 
    input KEY0,            // Reset button (active LOW) 
    output [6:0] HEX0  ,    // 7-segment display 
	  output [6:0] HEX1,   //seconds
	   output [6:0] HEX2,
		 output [6:0] HEX3,//minutes
		  output [6:0] HEX4,
		   output [6:0] HEX5//hours
); 
 
    wire clk_1hz; 
    
	
	
	reg [5:0] seconds,minutes;
	reg [4:0] hours;
   
    clk_div #(50_000_000) U1 ( 
        .clk(CLOCK_50), 
        .rst(KEY0), 
        .clk_out(clk_1hz) 
    ); 
	 
	 //time increment logic
 
    always @(posedge CLOCK_50 or negedge KEY0) begin
	 if (!KEY0) begin
	 hours<=0;
	 minutes<=0;
	 seconds<=0;
	 end
	 else if (clk_1hz) begin   
			if (seconds==59) begin
					seconds<=0;
					if(minutes==59) begin
							minutes<=0;
							if (hours==23) 	hours<=0;
							else 					hours<=hours+1;
					end 
					else 	begin 
							minutes<=minutes+1;		
					end 
			end
			else begin 
				seconds<=seconds+1;
				end
			
			end
	 end
 
    // 7-segment decoder 
    segment7 U3 ( 
        .bcd({1'b0, hours%10}),   // convert 3-bit to 4-bit 
        .seg(HEX5) 
    ); 
	 
	 // 7-segment decoder 
    segment7 U4 ( 
        .bcd({1'b0, hours/10}),   // convert 3-bit to 4-bit 
        .seg(HEX4) 
    );
	 // 7-segment decoder 
    segment7 U5 ( 
        .bcd({1'b0, minutes%10}),   // convert 3-bit to 4-bit 
        .seg(HEX3) 
    );
	 // 7-segment decoder 
    segment7 U6 ( 
        .bcd({1'b0, minutes/10}),   // convert 3-bit to 4-bit 
        .seg(HEX2) 
    );
	 
	 // 7-segment decoder 
    segment7 U7 ( 
        .bcd({1'b0, hours%10}),   // convert 3-bit to 4-bit 
        .seg(HEX1) 
    );
	 
	 // 7-segment decoder 
    segment7 U8 ( 
        .bcd({1'b0, hours/10}),   // convert 3-bit to 4-bit 
        .seg(HEX0) 
    );
 
endmodule 
 
module clk_div #(parameter DIV = 50_000_000)( 
    input clk, 
    input rst, 
    output reg clk_out 
); 
 
    reg [31:0] count; 
 
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            count <= 0; 
            clk_out <= 0; 
        end 
        else if (count == (DIV/2 - 1)) begin 
            count <= 0; 
            clk_out <= ~clk_out; 
        end 
        else begin 
            count <= count + 1; 
        end 
    end 
 
endmodule 
 

 
module segment7( 
    input [3:0] bcd, 
    output reg [6:0] seg 
); 
 
    always @(*) begin 
        case (bcd) 
            4'd0: seg = 7'b1000000; 
            4'd1: seg = 7'b1111001; 
            4'd2: seg = 7'b0100100; 
            4'd3: seg = 7'b0110000; 
            4'd4: seg = 7'b0011001; 
            4'd5: seg = 7'b0010010; 
            4'd6: seg = 7'b0000010; 
            4'd7: seg = 7'b1111000; 
            4'd8: seg = 7'b0000000; 
            4'd9: seg = 7'b0010000; 
            default: seg = 7'b1111111; 
        endcase 
    end 
 
endmodule 