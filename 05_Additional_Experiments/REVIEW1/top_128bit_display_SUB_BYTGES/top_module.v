module top_module(

 input  wire        clk,
 input  wire [3:0]  addr,
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
wire [127:0] subyteddata;


rom128 i1 (.clk(clk),.addr(addr),.data_out(data));
subBytes i3 (.in(data),.out(subyteddata));
    top_128bit_display i2(clk,reset,btn,subyteddata, seg0,seg1,seg2,seg3,seg4,seg5,seg6,seg7,status_led);
endmodule