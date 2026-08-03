module top_module(

 input  wire        clk,
 input  wire [3:0]  addr1,
  input  wire [3:0]  addr2,
//from displ
input wire reset,
    input wire btn,

	 
	 
	 
	 /*
    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4,
    output wire [6:0] seg5,
    output wire [6:0] seg6,
    output wire [6:0] seg7,
	 */
	 
	  output wire [0:6] seg0,
    output wire [0:6] seg1,
    output wire [0:6] seg2,
    output wire [0:6] seg3,
    output wire [0:6] seg4,
    output wire [0:6] seg5,
    output wire [0:6] seg6,
    output wire [0:6] seg7,

    output wire [1:0] status_led
);
wire  [127:0] data;
wire [127:0] key;

rom128 i1 (.clk(clk),.addr(addr1),.data_out(data));
rom128_1 i2 (.clk(clk),.addr(addr2),.data_out(key));

addRoundKey(data, out, key);


    top_128bit_display i3(clk,reset,btn,out, seg0,seg1,seg2,seg3,seg4,seg5,seg6,seg7,status_led);
endmodule