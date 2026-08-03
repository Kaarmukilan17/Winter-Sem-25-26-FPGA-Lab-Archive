//  2-BIT SYNCHRONOUS UP COUNTER

module counter2_up (
    input  wire clk,
    input  wire reset,
    input  wire enable,
    output reg  [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else if (enable)
            count <= count + 1'b1;
    end

endmodule