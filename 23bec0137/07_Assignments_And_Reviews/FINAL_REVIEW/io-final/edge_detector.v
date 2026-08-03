
//  RISING EDGE DETECTOR



module edge_detector (
    input  wire clk,
    input  wire signal_in,
    output wire pulse_out
);

    reg signal_d;

    always @(posedge clk)
        signal_d <= signal_in;

    assign pulse_out = signal_in & ~signal_d;

endmodule


