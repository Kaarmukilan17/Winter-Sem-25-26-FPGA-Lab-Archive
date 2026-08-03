module top (
    input  wire        clk_btn,        
	 input wire CLOCK_50,
    input  wire        reset,
    input  wire        btn,        // for display scrolling
    input  wire        debug_sel,  // 0=input, 1=output
    input  wire [3:0]  SW,       // ROM address
	input wire start,
    output wire [0:6] HEX0,
    output wire [0:6] HEX1,
    output wire [0:6] HEX2,
    output wire [0:6] HEX3,
    output wire [0:6] HEX4,
    output wire [0:6] HEX5,
    output wire [0:6] HEX6,
    output wire [0:6] HEX7,
	 
	output wire done,
    output wire [1:0] status_led
);

    
    // ROM OUTPUTS
   
    wire [127:0] plaintext;
    wire [127:0] key;

	 wire clk;
	  debounce db_inst (
        .clk(CLOCK_50),
        .btn_in(clk_btn),
        .btn_out(clk)
    );


    rom128 data_rom (
        .clk(CLOCK_50),
        .addr(SW),
        .data_out(plaintext)
    );

    key_rom128 key_rom (
        .clk(CLOCK_50),
        .addr(SW),
        .key_out(key)
    );
	 
	 
	 /*
	 //paremetersed- check if working
	  rom128 #(
    .FILE_NAME("DATA.txt")
) data_rom (
        .clk(clk),
        .addr(addr),
        .data_out(plaintext)
    );
	 
	  rom128 #(
    .FILE_NAME("KEY.txt")
) key_rom (
        .clk(clk),
        .addr(addr),
        .data_out(key)
    );*/

    
    // AES CORE
   
    wire [127:0] ciphertext;
   

    aes_core aes_inst (
        .clk(clk),
        .plaintext(plaintext),
		  .start(start),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // ---------------------------------------------------------
    // DEBUG MUX (INPUT vs OUTPUT)
    // ---------------------------------------------------------
    wire [127:0] selected_data;

    assign selected_data = (debug_sel == 1'b0) ? plaintext : ciphertext;

    // ---------------------------------------------------------
    // DISPLAY MODULE (your existing)
    // ---------------------------------------------------------
    top_128bit_display display_inst (
        .clk(CLOCK_50),
        .reset(reset),
        .btn(btn),
        .data(selected_data),

        .seg0(HEX0),
        .seg1(HEX1),
        .seg2(HEX2),
        .seg3(HEX3),
        .seg4(HEX4),
        .seg5(HEX5),
        .seg6(HEX6),
        .seg7(HEX7),

        .status_led(status_led)
    );

endmodule


