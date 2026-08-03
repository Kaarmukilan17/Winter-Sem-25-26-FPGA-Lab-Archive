module button_toggle (
    input clk,
    input rst,
    input btn_raw, // Active-low button input
    output reg [3:0] leds // Output count on 4 LEDs
);

    // Debounce Logic
    reg [19:0] debounce_counter = 0;
    reg btn_stable = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            debounce_counter <= 0;
            btn_stable <= 0;
        end else begin
            if (~btn_raw) begin // Button is pressed
                if (debounce_counter < 20'd1_000_000) // ~20ms
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
    wire btn_rising_edge;

    assign btn_rising_edge = btn_stable & ~prev_btn_stable;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_btn_stable <= 0;
        end else begin
            prev_btn_stable <= btn_stable;
        end
    end

    // Count on each rising edge
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            leds <= 0;
        end else if (btn_rising_edge) begin
            leds <= leds + 1;
        end
    end

endmodule
