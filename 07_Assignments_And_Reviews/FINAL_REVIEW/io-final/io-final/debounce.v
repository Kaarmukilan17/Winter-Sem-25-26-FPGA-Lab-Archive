//debonuce moduele parmaterised

module debounce #(
    parameter integer CLK_FREQ_HZ = 50_000_000,
    parameter integer DEBOUNCE_MS = 20
)(
    input  wire clk,
    input  wire btn_in,
    output reg  btn_out = 0
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
                btn_out <= btn_sync2;  // accept new stable state
                count   <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            count <= 0;                // stable again â reset timer
        end
    end

endmodule
