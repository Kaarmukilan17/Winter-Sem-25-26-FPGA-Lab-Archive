module button_toggle (
    input clk, // 50 MHz
    input rst, // active high reset
    input btn, // active-low push button
    output reg [6:0] seg // single digit 7-segment output
);

    // ====================
    // Debounce Logic
    // ====================
    reg [19:0] debounce = 0;
    reg btn_sync = 1;
    reg btn_stable = 1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            debounce <= 0;
            btn_stable <= 1;
        end else begin
            if (btn != btn_stable) begin
                debounce <= debounce + 1;
                if (debounce == 1_000_000) begin
                    btn_stable <= btn;
                    debounce <= 0;
                end
            end else begin
                debounce <= 0;
            end
        end
    end

    // ====================
    // Edge Detection
    // ====================
    reg btn_prev = 1;
    wire btn_pressed = (btn_prev == 1 && btn_stable == 0);

    always @(posedge clk) begin
        btn_prev <= btn_stable;
    end

    // ====================
    // Counter Logic
    // ====================
    reg [3:0] count = 0;
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (btn_pressed)
            count <= (count == 9) ? 0 : count + 1;
    end

    // ====================
    // 7-Segment Decoder
    // ====================
    always @(*) begin
        case (count)
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0110000;
            4: seg = 7'b0011001;
            5: seg = 7'b0010010;
            6: seg = 7'b0000010;
            7: seg = 7'b1111000;
            8: seg = 7'b0000000;
            9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end

endmodule