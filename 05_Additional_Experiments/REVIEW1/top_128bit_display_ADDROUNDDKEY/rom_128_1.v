module rom128_1 (
    input  wire        clk,
    input  wire [3:0]  addr,
    output reg  [127:0] data_out
);

    reg [127:0] mem [0:15];   // 16 words of 128-bit

    initial begin
        $readmemh("key.txt", mem);
    end

    always @(posedge clk) begin
        data_out <= mem[addr];
    end

endmodule