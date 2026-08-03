
module debounce #(
    parameter integer CLK_FREQ_HZ = 50_000_000,
    parameter integer DEBOUNCE_MS = 20
)(
    input wire clk,
    input wire btn_in,
    output reg btn_out = 0
);

    // Number of clock cycles required for stability
  
    localparam integer COUNT_MAX =
        (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

    localparam integer COUNT_W = $clog2(COUNT_MAX + 1);

    reg btn_sync1 = 0;
    reg btn_sync2 = 0;
    reg [COUNT_W-1:0] count = 0;


    // Debounce logic

    always @(posedge clk) begin
        // Synchronize async button
        btn_sync1 <= btn_in;
        btn_sync2 <= btn_sync1;

        // Debounce
        if (btn_sync2 != btn_out) begin
            if (count == COUNT_MAX) begin
                btn_out <= btn_sync2; // accept new stable state
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            count <= 0; // stable again → reset timer
        end
    end

endmodule



// 4x1 MUX - 32 BIT

module mux4x1_32bit (
    input wire [31:0] in0,
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [31:0] in3,
    input wire [1:0] sel,
    output reg [31:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 32'h00000000;
        endcase
    end

endmodule




// HEX TO 7-SEG DECODER (COMMON ANODE - ACTIVE LOW)

module hex_to_7seg (
    input wire [3:0] hex,
    output reg [6:0] seg // {a,b,c,d,e,f,g}
);

always @(*) begin
    case (hex)
        4'h0: seg = 7'b0000001;
        4'h1: seg = 7'b1001111;
        4'h2: seg = 7'b0010010;
        4'h3: seg = 7'b0000110;
        4'h4: seg = 7'b1001100;
        4'h5: seg = 7'b0100100;
        4'h6: seg = 7'b0100000;
        4'h7: seg = 7'b0001111;
        4'h8: seg = 7'b0000000;
        4'h9: seg = 7'b0000100;
        4'hA: seg = 7'b0001000;
        4'hB: seg = 7'b1100000;
        4'hC: seg = 7'b0110001;
        4'hD: seg = 7'b1000010;
        4'hE: seg = 7'b0110000;
        4'hF: seg = 7'b0111000;
        default: seg = 7'b1111111;
    endcase
end

endmodule



// 8 SEVEN-SEG DRIVER FOR 32-BIT INPUT

module eight_sevenseg_32bit (
    input wire [31:0] data32,
    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4,
    output wire [6:0] seg5,
    output wire [6:0] seg6,
    output wire [6:0] seg7
);

    hex_to_7seg h0 (.hex(data32[3:0]), .seg(seg0));
    hex_to_7seg h1 (.hex(data32[7:4]), .seg(seg1));
    hex_to_7seg h2 (.hex(data32[11:8]), .seg(seg2));
    hex_to_7seg h3 (.hex(data32[15:12]), .seg(seg3));
    hex_to_7seg h4 (.hex(data32[19:16]), .seg(seg4));
    hex_to_7seg h5 (.hex(data32[23:20]), .seg(seg5));
    hex_to_7seg h6 (.hex(data32[27:24]), .seg(seg6));
    hex_to_7seg h7 (.hex(data32[31:28]), .seg(seg7));

endmodule



// RISING EDGE DETECTOR

module edge_detector (
    input wire clk,
    input wire signal_in,
    output wire pulse_out
);

    reg signal_d;

    always @(posedge clk)
        signal_d <= signal_in;

    assign pulse_out = signal_in & ~signal_d;

endmodule



// 2-BIT SYNCHRONOUS UP COUNTER

module counter2_up (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else if (enable)
            count <= count + 1'b1;
    end

endmodule



// TOP MODULE - 128-BIT DISPLAY CONTROLLER

module top_128bit_display (
    input wire clk,
    input wire reset,
    input wire btn,
    input wire [127:0] data,

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