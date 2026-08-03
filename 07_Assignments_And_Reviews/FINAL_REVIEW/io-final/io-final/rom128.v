//  128-BIT ROM 

module rom128 (
    input  wire        clk,
    input  wire [3:0]  addr,
    output reg  [127:0] data_out
);

    reg [127:0] mem [0:15];   // 16 words of 128-bit

    initial begin
        $readmemh("data.txt", mem);
    end

    always @(posedge clk) begin
        data_out <= mem[addr];
    end

endmodule
/*
module rom128 #(
    parameter string FILE_NAME = "data.txt"
)(
    input  wire        clk,
    input  wire [3:0]  addr,
    output reg  [127:0] data_out
);

    reg [127:0] mem [0:15];

    initial begin
        $readmemh(FILE_NAME, mem);
    end

    always @(posedge clk)
        data_out <= mem[addr];

endmodule
*/