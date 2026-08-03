module button_counter_seg (
    input clk,
    input rst,
    input btn_raw, // Active-low button
    output reg [25:0] leds, // LED output: 4-bit binary counter
    output reg [6:0] seg // 7-segment display output (active low)
);

    // Debounce Logic
    reg [19:0] debounce_counter = 0;
    reg btn_stable = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            debounce_counter <= 0;
            btn_stable <= 0;
        end else begin
            if (~btn_raw) begin // Button is pressed (active low)
                if (debounce_counter < 20'd1_000_000) // ~20ms debounce at 50MHz
                    debounce_counter <= debounce_counter + 1;
                else
                    btn_stable <= 1;
            end else begin
                debounce_counter <= 0;
                btn_stable <= 0;
            end
        end
    end

    // Rising Edge Detection
    reg prev_btn_stable = 0;
    wire btn_rising_edge = btn_stable & ~prev_btn_stable;

    always @(posedge clk or posedge rst) begin
        if (rst)
            prev_btn_stable <= 0;
        else
            prev_btn_stable <= btn_stable;
    end

    // Counter Logic (increments on rising edge)
    always @(posedge clk or posedge rst) begin
        if (rst)
            leds <= 0;
        else if (btn_rising_edge)
            leds <= leds + 1;
    end

    // 7-Segment Display Decoder (Hex: 0–F)
    always @(*) begin
        case (leds)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            4'd10: seg = 7'b0001000; // A
            4'd11: seg = 7'b0000011; // b
            4'd12: seg = 7'b1000110; // C
            4'd13: seg = 7'b0100001; // d
            4'd14: seg = 7'b0000110; // E
            4'd15: seg = 7'b0001110; // F
            default: seg = 7'b1111111;
        endcase
    end

endmodule