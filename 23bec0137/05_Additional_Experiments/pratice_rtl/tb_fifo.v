`timescale 1ns/1ps

module tb_fifo;

reg clock;
reg [7:0] data;
reg rdreq;
reg wrreq;

wire empty;
wire full;
wire [7:0] q;
wire [7:0] usedw;

// DUT
fifo uut (
    .clock(clock),
    .data(data),
    .rdreq(rdreq),
    .wrreq(wrreq),
    .empty(empty),
    .full(full),
    .q(q),
    .usedw(usedw)
);

// Clock generation
always #5 clock = ~clock;

initial begin
    clock = 0;
    data  = 0;
    rdreq = 0;
    wrreq = 0;

    $monitor("T=%0t | data=%d wr=%b rd=%b | q=%d | full=%b empty=%b used=%d",
              $time, data, wrreq, rdreq, q, full, empty, usedw);

    //--------------------------------------------------
    // WRITE DATA
    //--------------------------------------------------
    repeat (5) begin
        @(negedge clock);
        if (!full) begin
            data  = data + 1;
            wrreq = 1;
        end
    end

    @(negedge clock);
    wrreq = 0;

    //--------------------------------------------------
    // READ DATA
    //--------------------------------------------------
    repeat (5) begin
        @(negedge clock);
        if (!empty)
            rdreq = 1;
    end

    @(negedge clock);
    rdreq = 0;

    //--------------------------------------------------
    // MIXED OPERATIONS
    //--------------------------------------------------
    repeat (5) begin
        @(negedge clock);
        data  = data + 2;
        wrreq = !full;
        rdreq = !empty;
    end

    @(negedge clock);
    wrreq = 0;
    rdreq = 0;

    #50;
    $finish;
end

endmodule