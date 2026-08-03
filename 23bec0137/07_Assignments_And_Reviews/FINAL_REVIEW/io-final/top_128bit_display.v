

//  TOP MODULE - 128-BIT DISPLAY CONTROLLER

module top_128bit_display (
    input  wire        clk,
    input  wire        reset,
    input  wire        btn,
    input  wire [127:0] data,

    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4,
    output wire [6:0] seg5,
    output wire [6:0] seg6,
    output wire [6:0] seg7,

    output wire [1:0] status_led
);

   
    // Debounce (module provided separately)
   
    wire btn_clean;

    debounce db_inst (
        .clk(clk),
        .btn_in(btn),
        .btn_out(btn_clean)
    );

   
    // Edge Detection
    
    wire btn_pulse;

    edge_detector edge_inst (
        .clk(clk),
        .signal_in(btn_clean),
        .pulse_out(btn_pulse)
    );


    // 2-bit Quarter Counter
    
    wire [1:0] quarter;

    counter2_up counter_inst (
        .clk(clk),
        .reset(reset),
        .enable(btn_pulse),
        .count(quarter)
    );

    assign status_led = quarter;


    // 4:1 MUX (Select 32-bit quarter)
    // ---------------------------------------------------------
    // 4x1 32-bit MUX
    // ---------------------------------------------------------
    wire [31:0] selected_data;

    mux4x1_32bit mux_inst (
        .in0(data[31:0]),
        .in1(data[63:32]),
        .in2(data[95:64]),
        .in3(data[127:96]),
        .sel(quarter),
        .out(selected_data)
    );

    // 8 Seven Segment Driver

    eight_sevenseg_32bit display_inst (
        .data32(selected_data),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5),
        .seg6(seg6),
        .seg7(seg7)
    );

endmodule