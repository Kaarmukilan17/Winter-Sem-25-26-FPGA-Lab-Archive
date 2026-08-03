
module file(
    input clk,
    input en,
    input [5:0] addr,
    output reg [7:0] dataout
);

reg [7:0] mem [0:49];

always @(posedge clk) begin
    if (en)
        dataout <= mem[addr];
end

endmodule

module tb_read;

reg clk;
reg en;
reg [5:0] addr;
wire [7:0] dataout;

file DUT(clk, en, addr, dataout);

always #5 clk = ~clk;
integer i;
initial begin
    clk = 0;
    en  = 0;
  
    $readmemh("file137_1.txt", DUT.mem);
   
    en = 1;
    
    for(i=0;i<50;i=i+1) begin
    #10 addr = i;
		end
    $finish;
end

endmodule




module tb_copy;

reg clk;
reg en;
reg [5:0] addr;
wire [7:0] dataout;

file DUT(clk, en, addr, dataout);

always #5 clk = ~clk;

integer i,fout;

initial begin
    clk = 0;
    en  = 0;
  
    $readmemh("file137_1.txt", DUT.mem);
    fout = $fopen("file137_2.txt");
    //en = 1;
    
    for(i=0;i<50;i=i+1) begin
    $fwrite(fout,"%h\n",DUT.mem[i]);
	end


    for (i = 0; i < 50; i = i + 1) begin
        $fdisplay(fout);
    end

    $fclose(fout);

    $finish;
end
 

endmodule

