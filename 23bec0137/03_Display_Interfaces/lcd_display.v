module lcd_display(
    input clk,
    input rst,
    input btn_raw,
    output reg [7:0] lcd_data,
    output reg lcd_rs,
    output reg lcd_rw,
    output reg lcd_en
);

    // Clock divider for timing
    reg [19:0] clk_div;
    wire slow_clk = clk_div[19];
    always @(posedge clk) clk_div <= clk_div + 1;

    // Button debounce
    reg [15:0] shift_reg;
    reg btn_stable;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[14:0], btn_raw};
        if (shift_reg == 16'hFFFF) btn_stable <= 1;
        else if (shift_reg == 16'h0000) btn_stable <= 0;
    end

    // Edge detection
    reg btn_prev;
    wire btn_pressed = (btn_stable && !btn_prev);
    always @(posedge clk) btn_prev <= btn_stable;

    // Message handling
    reg [3:0] state;
    reg [7:0] message [0:15];
    reg [4:0] idx;
    reg [7:0] count;

    // Convert count to ASCII decimal (2 digits)
    wire [7:0] count_tens = (count / 10) + 8'd48;
    wire [7:0] count_ones = (count % 10) + 8'd48;

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

            // Update display string
            message[0] <= "C";
            message[1] <= "o";
            message[2] <= "u";
            message[3] <= "n";
            message[4] <= "t";
            message[5] <= ":";
            message[6] <= " ";
            message[7] <= count_tens;
            message[8] <= count_ones;
            message[9] <= " ";
            message[10]<= " ";
            message[11]<= " ";
            message[12]<= " ";
            message[13]<= " ";
            message[14]<= " ";
            message[15]<= " ";

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
                    if (idx < 15) begin idx <= idx + 1; state <= 8;
                    end else begin idx <= 0; state <= 8; end
                end
            endcase
        end
    end
endmodule