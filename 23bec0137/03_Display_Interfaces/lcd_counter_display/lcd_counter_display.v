
module lcd_counter_display(
    input clk,
    input rst,
    input btn_raw,
    output reg [7:0] lcd_data,
    output reg lcd_rs,
    output reg lcd_rw,
    output reg lcd_en
    
);

    // Clock divider for timing control
    reg [19:0] clk_div;
    wire slow_clk = clk_div[19];
    always @(posedge clk) clk_div <= clk_div + 1;

    // Button debounce logic
    reg [15:0] shift_reg;
    reg btn_stable;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[14:0], btn_raw};
        if (shift_reg == 16'hFFFF) btn_stable <= 1;
        else if (shift_reg == 16'h0000) btn_stable <= 0;
    end

    // Rising edge detection
    reg btn_prev;
    wire btn_pressed = (btn_stable && !btn_prev);
    always @(posedge clk) btn_prev <= btn_stable;

    // State machine and message
    reg [3:0] state;
    reg [7:0] message [0:15];
    reg [4:0] idx;
    reg [7:0] count;

    // Convert count to ASCII digits
    wire [7:0] ones = (count % 10) + 8'd48;
    wire [7:0] tens = (count / 10) + 8'd48;

    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            idx <= 0;
            lcd_en <= 0;
            lcd_rs <= 0;
            lcd_rw <= 0;
            count <= 0;
        end else begin
            if (btn_pressed) count <= count + 1;

            // Prepare message
            message[0] <= "P";
            message[1] <= "r";
            message[2] <= "e";
            message[3] <= "s";
            message[4] <= "s";
            message[5] <= "e";
            message[6] <= "d";
            message[7] <= ":";
            message[8] <= " ";
            message[9] <= tens;
            message[10] <= ones;
            message[11] <= " ";
            message[12] <= " ";
            message[13] <= " ";
            message[14] <= " ";
            message[15] <= " ";

            case (state)
                0: begin lcd_rs <= 0; lcd_rw <= 0; lcd_data <= 8'h38; lcd_en <= 1; state <= 1; end
                1: begin lcd_en <= 0; state <= 2; end
                2: begin lcd_data <= 8'h0E; lcd_en <= 1; state <= 3; end
                3: begin lcd_en <= 0; state <= 4; end
                4: begin lcd_data <= 8'h01; lcd_en <= 1; state <= 5; end
                5: begin lcd_en <= 0; state <= 6; end
                6: begin lcd_data <= 8'h06; lcd_en <= 1; state <= 7; end
                7: begin lcd_en <= 0; state <= 8; end
                8: begin lcd_rs <= 1; lcd_data <= message[idx]; lcd_en <= 1; state <= 9; end
                9: begin lcd_en <= 0;
                    if (idx < 15) begin
                        idx <= idx + 1; state <= 8;
                    end else begin
                        state <= 9;
                    end
                end
            endcase
        end
    end
endmodule