
//  8 SEVEN-SEG DRIVER FOR 32-BIT INPUT
module eight_sevenseg_32bit (
    input  wire [31:0] data32,
    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4,
    output wire [6:0] seg5,
    output wire [6:0] seg6,
    output wire [6:0] seg7
);

    hex_to_7seg h0 (.hex(data32[3:0]),    .seg(seg0));
    hex_to_7seg h1 (.hex(data32[7:4]),    .seg(seg1));
    hex_to_7seg h2 (.hex(data32[11:8]),   .seg(seg2));
    hex_to_7seg h3 (.hex(data32[15:12]),  .seg(seg3));
    hex_to_7seg h4 (.hex(data32[19:16]),  .seg(seg4));
    hex_to_7seg h5 (.hex(data32[23:20]),  .seg(seg5));
    hex_to_7seg h6 (.hex(data32[27:24]),  .seg(seg6));
    hex_to_7seg h7 (.hex(data32[31:28]),  .seg(seg7));

endmodule
