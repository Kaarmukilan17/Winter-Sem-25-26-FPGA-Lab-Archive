module aes_pipeline_top (
    input         clk,
    input  [127:0] plaintext,
    input  [127:0] key,
    input          start,
    output [127:0] ciphertext,
    output         done
);
 
    // -------------------------------------------------------------------------
    // Key Schedule: combinational, generates all 11 round keys simultaneously
    // rkey_flat[k*128 +: 128] = round key k
    // -------------------------------------------------------------------------
    wire [1407:0] rkey_flat;
 
    aes_keyschedule u_ks (
        .key      (key),
        .rkey_flat(rkey_flat)
    );
 
    // Unpack individual round keys for clarity
    wire [127:0] rkey0  = rkey_flat[  0*128 +: 128];
    wire [127:0] rkey1  = rkey_flat[  1*128 +: 128];
    wire [127:0] rkey2  = rkey_flat[  2*128 +: 128];
    wire [127:0] rkey3  = rkey_flat[  3*128 +: 128];
    wire [127:0] rkey4  = rkey_flat[  4*128 +: 128];
    wire [127:0] rkey5  = rkey_flat[  5*128 +: 128];
    wire [127:0] rkey6  = rkey_flat[  6*128 +: 128];
    wire [127:0] rkey7  = rkey_flat[  7*128 +: 128];
    wire [127:0] rkey8  = rkey_flat[  8*128 +: 128];
    wire [127:0] rkey9  = rkey_flat[  9*128 +: 128];
    wire [127:0] rkey10 = rkey_flat[ 10*128 +: 128];
 
    // -------------------------------------------------------------------------
    // 'done' shift register — tracks when a started block reaches the output.
    // start pulses for 1 cycle; done appears exactly 11 cycles later.
    // -------------------------------------------------------------------------
    reg [10:0] done_sr;   // shift register, 11 bits
 
    always @(posedge clk) begin
        done_sr[0]  <= start;
        done_sr[1]  <= done_sr[0];
        done_sr[2]  <= done_sr[1];
        done_sr[3]  <= done_sr[2];
        done_sr[4]  <= done_sr[3];
        done_sr[5]  <= done_sr[4];
        done_sr[6]  <= done_sr[5];
        done_sr[7]  <= done_sr[6];
        done_sr[8]  <= done_sr[7];
        done_sr[9]  <= done_sr[8];
        done_sr[10] <= done_sr[9];
    end
 
    assign done = done_sr[10];
 
    // -------------------------------------------------------------------------
    // STAGE 0 — Initial AddRoundKey  (plaintext XOR rkey0)
    // No SubBytes/ShiftRows/MixCols in this stage.
    // Pipeline register PR0 captures the result.
    // -------------------------------------------------------------------------
    wire [127:0] s0_out;
    reg  [127:0] pr0;          // Pipeline Register 0
 
    assign s0_out = plaintext ^ rkey0;
 
    always @(posedge clk)
        pr0 <= s0_out;
 
    // -------------------------------------------------------------------------
    // STAGE 1 — Full round 1 (SubBytes -> ShiftRows -> MixCols -> AddRK1)
    // -------------------------------------------------------------------------
    wire [127:0] s1_sub, s1_shift, s1_mix, s1_out;
    reg  [127:0] pr1;
 
    aes_subbytes   u_s1_sub  (.state_in(pr0),     .state_out(s1_sub));
    aes_shiftrows  u_s1_sr   (.state_in(s1_sub),  .state_out(s1_shift));
    aes_mixcolumns u_s1_mc   (.state_in(s1_shift), .state_out(s1_mix));
 
    assign s1_out = s1_mix ^ rkey1;
 
    always @(posedge clk)
        pr1 <= s1_out;
 
    // -------------------------------------------------------------------------
    // STAGE 2 — Full round 2
    // -------------------------------------------------------------------------
    wire [127:0] s2_sub, s2_shift, s2_mix, s2_out;
    reg  [127:0] pr2;
 
    aes_subbytes   u_s2_sub  (.state_in(pr1),     .state_out(s2_sub));
    aes_shiftrows  u_s2_sr   (.state_in(s2_sub),  .state_out(s2_shift));
    aes_mixcolumns u_s2_mc   (.state_in(s2_shift), .state_out(s2_mix));
 
    assign s2_out = s2_mix ^ rkey2;
 
    always @(posedge clk)
        pr2 <= s2_out;
 
    // -------------------------------------------------------------------------
    // STAGE 3 — Full round 3
    // -------------------------------------------------------------------------
    wire [127:0] s3_sub, s3_shift, s3_mix, s3_out;
    reg  [127:0] pr3;
 
    aes_subbytes   u_s3_sub  (.state_in(pr2),     .state_out(s3_sub));
    aes_shiftrows  u_s3_sr   (.state_in(s3_sub),  .state_out(s3_shift));
    aes_mixcolumns u_s3_mc   (.state_in(s3_shift), .state_out(s3_mix));
 
    assign s3_out = s3_mix ^ rkey3;
 
    always @(posedge clk)
        pr3 <= s3_out;
 
    // -------------------------------------------------------------------------
    // STAGE 4 — Full round 4
    // -------------------------------------------------------------------------
    wire [127:0] s4_sub, s4_shift, s4_mix, s4_out;
    reg  [127:0] pr4;
 
    aes_subbytes   u_s4_sub  (.state_in(pr3),     .state_out(s4_sub));
    aes_shiftrows  u_s4_sr   (.state_in(s4_sub),  .state_out(s4_shift));
    aes_mixcolumns u_s4_mc   (.state_in(s4_shift), .state_out(s4_mix));
 
    assign s4_out = s4_mix ^ rkey4;
 
    always @(posedge clk)
        pr4 <= s4_out;
 
    // -------------------------------------------------------------------------
    // STAGE 5 — Full round 5
    // -------------------------------------------------------------------------
    wire [127:0] s5_sub, s5_shift, s5_mix, s5_out;
    reg  [127:0] pr5;
 
    aes_subbytes   u_s5_sub  (.state_in(pr4),     .state_out(s5_sub));
    aes_shiftrows  u_s5_sr   (.state_in(s5_sub),  .state_out(s5_shift));
    aes_mixcolumns u_s5_mc   (.state_in(s5_shift), .state_out(s5_mix));
 
    assign s5_out = s5_mix ^ rkey5;
 
    always @(posedge clk)
        pr5 <= s5_out;
 
    // -------------------------------------------------------------------------
    // STAGE 6 — Full round 6
    // -------------------------------------------------------------------------
    wire [127:0] s6_sub, s6_shift, s6_mix, s6_out;
    reg  [127:0] pr6;
 
    aes_subbytes   u_s6_sub  (.state_in(pr5),     .state_out(s6_sub));
    aes_shiftrows  u_s6_sr   (.state_in(s6_sub),  .state_out(s6_shift));
    aes_mixcolumns u_s6_mc   (.state_in(s6_shift), .state_out(s6_mix));
 
    assign s6_out = s6_mix ^ rkey6;
 
    always @(posedge clk)
        pr6 <= s6_out;
 
    // -------------------------------------------------------------------------
    // STAGE 7 — Full round 7
    // -------------------------------------------------------------------------
    wire [127:0] s7_sub, s7_shift, s7_mix, s7_out;
    reg  [127:0] pr7;
 
    aes_subbytes   u_s7_sub  (.state_in(pr6),     .state_out(s7_sub));
    aes_shiftrows  u_s7_sr   (.state_in(s7_sub),  .state_out(s7_shift));
    aes_mixcolumns u_s7_mc   (.state_in(s7_shift), .state_out(s7_mix));
 
    assign s7_out = s7_mix ^ rkey7;
 
    always @(posedge clk)
        pr7 <= s7_out;
 
    // -------------------------------------------------------------------------
    // STAGE 8 — Full round 8
    // -------------------------------------------------------------------------
    wire [127:0] s8_sub, s8_shift, s8_mix, s8_out;
    reg  [127:0] pr8;
 
    aes_subbytes   u_s8_sub  (.state_in(pr7),     .state_out(s8_sub));
    aes_shiftrows  u_s8_sr   (.state_in(s8_sub),  .state_out(s8_shift));
    aes_mixcolumns u_s8_mc   (.state_in(s8_shift), .state_out(s8_mix));
 
    assign s8_out = s8_mix ^ rkey8;
 
    always @(posedge clk)
        pr8 <= s8_out;
 
    // -------------------------------------------------------------------------
    // STAGE 9 — Full round 9
    // -------------------------------------------------------------------------
    wire [127:0] s9_sub, s9_shift, s9_mix, s9_out;
    reg  [127:0] pr9;
 
    aes_subbytes   u_s9_sub  (.state_in(pr8),     .state_out(s9_sub));
    aes_shiftrows  u_s9_sr   (.state_in(s9_sub),  .state_out(s9_shift));
    aes_mixcolumns u_s9_mc   (.state_in(s9_shift), .state_out(s9_mix));
 
    assign s9_out = s9_mix ^ rkey9;
 
    always @(posedge clk)
        pr9 <= s9_out;
 
    // -------------------------------------------------------------------------
    // STAGE 10 — Final round (SubBytes -> ShiftRows -> AddRK10, NO MixCols)
    // Output register holds the final ciphertext.
    // -------------------------------------------------------------------------
    wire [127:0] s10_sub, s10_shift, s10_out;
    reg  [127:0] pr10;
 
    aes_subbytes  u_s10_sub (.state_in(pr9),      .state_out(s10_sub));
    aes_shiftrows u_s10_sr  (.state_in(s10_sub),  .state_out(s10_shift));
 
    assign s10_out = s10_shift ^ rkey10;
 
    always @(posedge clk)
        pr10 <= s10_out;
 
    assign ciphertext = pr10;
 
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company: VIT Vellore (Student)  
// Engineer: SANJAY ELAVARASAN KARTHIKEYAN..
// 
// Create Date: 29.03.2026 01:15:00
// Design Name: AES Hardware Design 
// Module Name: SubBytes
// Project Name: High Performance AES Hardware Accelerator.
// Target Devices: --
// Tool Versions: Icarus Verilog(iverilog-v12-20220611-x64), GTKWave(GTKWave LTS 3.3.126)
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// =============================================================================
// SubBytes — identical to iterative version
// =============================================================================
module aes_subbytes (
    input  [127:0] state_in,
    output [127:0] state_out
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sb
            aes_sbox u_sbox (
                .in (state_in [8*i+7 : 8*i]),
                .out(state_out[8*i+7 : 8*i])
            );
        end
    endgenerate
endmodule
 
 
 //////////////////////////////////////////////////////////////////////////////////
// Company: VIT Vellore (Student)  
// Engineer: SANJAY ELAVARASAN KARTHIKEYAN..
// 
// Create Date: 29.03.2026 01:15:00
// Design Name: AES Hardware Design 
// Module Name: SubBytes
// Project Name: KEY_SCHEDULING_ALGORITHM.
// Target Devices: --
// Tool Versions: Icarus Verilog(iverilog-v12-20220611-x64), GTKWave(GTKWave LTS 3.3.126)
// Description:
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// AES state is 4x4 bytes arranged column-major:
//   byte0  byte4  byte8  byte12
//   byte1  byte5  byte9  byte13
//   byte2  byte6  byte10 byte14
//   byte3  byte7  byte11 byte15
//
// In 128-bit vector: byte0=[127:120], byte15=[7:0]
//
// Row shifts (left cyclic):
//   Row 0: no shift        →  0  4  8 12
//   Row 1: shift left 1    →  5  9 13  1
//   Row 2: shift left 2    → 10 14  2  6
//   Row 3: shift left 3    → 15  3  7 11
// ============================================================
// =============================================================================
// ShiftRows — identical to iterative version
// =============================================================================
module aes_shiftrows (
    input  [127:0] state_in,
    output [127:0] state_out
);
    wire [7:0] s [0:3][0:3];
    genvar r, c;
    generate
        for (c = 0; c < 4; c = c + 1) begin : col_in
            for (r = 0; r < 4; r = r + 1) begin : row_in
                assign s[r][c] = state_in[127-(c*32)-(r*8) -: 8];
            end
        end
    endgenerate
 
    wire [7:0] sr [0:3][0:3];
    generate
        for (r = 0; r < 4; r = r + 1) begin : sr_row
            for (c = 0; c < 4; c = c + 1) begin : sr_col
                assign sr[r][c] = s[r][(c+r) % 4];
            end
        end
    endgenerate
 
    generate
        for (c = 0; c < 4; c = c + 1) begin : pack_col
            for (r = 0; r < 4; r = r + 1) begin : pack_row
                assign state_out[127-(c*32)-(r*8) -: 8] = sr[r][c];
            end
        end
    endgenerate
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company: VIT Vellore (Student)  
// Engineer: SANJAY ELAVARASAN KARTHIKEYAN..
// 
// Create Date: 29.03.2026 01:15:00
// Design Name: AES Hardware Design 
// Module Name: S_Box - LOOKUP TABLE
// Project Name: High Performance AES Hardware Accelerator.
// Target Devices: --
// Tool Versions: Icarus Verilog(iverilog-v12-20220611-x64), GTKWave(GTKWave LTS 3.3.126)
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// =============================================================================
// S-Box ROM — identical to iterative version
// =============================================================================
module aes_sbox (
    input  [7:0] in,
    output [7:0] out
);
    reg [7:0] sbox [0:255];
    initial begin
        sbox[8'h00]=8'h63; sbox[8'h01]=8'h7c; sbox[8'h02]=8'h77; sbox[8'h03]=8'h7b;
        sbox[8'h04]=8'hf2; sbox[8'h05]=8'h6b; sbox[8'h06]=8'h6f; sbox[8'h07]=8'hc5;
        sbox[8'h08]=8'h30; sbox[8'h09]=8'h01; sbox[8'h0a]=8'h67; sbox[8'h0b]=8'h2b;
        sbox[8'h0c]=8'hfe; sbox[8'h0d]=8'hd7; sbox[8'h0e]=8'hab; sbox[8'h0f]=8'h76;
        sbox[8'h10]=8'hca; sbox[8'h11]=8'h82; sbox[8'h12]=8'hc9; sbox[8'h13]=8'h7d;
        sbox[8'h14]=8'hfa; sbox[8'h15]=8'h59; sbox[8'h16]=8'h47; sbox[8'h17]=8'hf0;
        sbox[8'h18]=8'had; sbox[8'h19]=8'hd4; sbox[8'h1a]=8'ha2; sbox[8'h1b]=8'haf;
        sbox[8'h1c]=8'h9c; sbox[8'h1d]=8'ha4; sbox[8'h1e]=8'h72; sbox[8'h1f]=8'hc0;
        sbox[8'h20]=8'hb7; sbox[8'h21]=8'hfd; sbox[8'h22]=8'h93; sbox[8'h23]=8'h26;
        sbox[8'h24]=8'h36; sbox[8'h25]=8'h3f; sbox[8'h26]=8'hf7; sbox[8'h27]=8'hcc;
        sbox[8'h28]=8'h34; sbox[8'h29]=8'ha5; sbox[8'h2a]=8'he5; sbox[8'h2b]=8'hf1;
        sbox[8'h2c]=8'h71; sbox[8'h2d]=8'hd8; sbox[8'h2e]=8'h31; sbox[8'h2f]=8'h15;
        sbox[8'h30]=8'h04; sbox[8'h31]=8'hc7; sbox[8'h32]=8'h23; sbox[8'h33]=8'hc3;
        sbox[8'h34]=8'h18; sbox[8'h35]=8'h96; sbox[8'h36]=8'h05; sbox[8'h37]=8'h9a;
        sbox[8'h38]=8'h07; sbox[8'h39]=8'h12; sbox[8'h3a]=8'h80; sbox[8'h3b]=8'he2;
        sbox[8'h3c]=8'heb; sbox[8'h3d]=8'h27; sbox[8'h3e]=8'hb2; sbox[8'h3f]=8'h75;
        sbox[8'h40]=8'h09; sbox[8'h41]=8'h83; sbox[8'h42]=8'h2c; sbox[8'h43]=8'h1a;
        sbox[8'h44]=8'h1b; sbox[8'h45]=8'h6e; sbox[8'h46]=8'h5a; sbox[8'h47]=8'ha0;
        sbox[8'h48]=8'h52; sbox[8'h49]=8'h3b; sbox[8'h4a]=8'hd6; sbox[8'h4b]=8'hb3;
        sbox[8'h4c]=8'h29; sbox[8'h4d]=8'he3; sbox[8'h4e]=8'h2f; sbox[8'h4f]=8'h84;
        sbox[8'h50]=8'h53; sbox[8'h51]=8'hd1; sbox[8'h52]=8'h00; sbox[8'h53]=8'hed;
        sbox[8'h54]=8'h20; sbox[8'h55]=8'hfc; sbox[8'h56]=8'hb1; sbox[8'h57]=8'h5b;
        sbox[8'h58]=8'h6a; sbox[8'h59]=8'hcb; sbox[8'h5a]=8'hbe; sbox[8'h5b]=8'h39;
        sbox[8'h5c]=8'h4a; sbox[8'h5d]=8'h4c; sbox[8'h5e]=8'h58; sbox[8'h5f]=8'hcf;
        sbox[8'h60]=8'hd0; sbox[8'h61]=8'hef; sbox[8'h62]=8'haa; sbox[8'h63]=8'hfb;
        sbox[8'h64]=8'h43; sbox[8'h65]=8'h4d; sbox[8'h66]=8'h33; sbox[8'h67]=8'h85;
        sbox[8'h68]=8'h45; sbox[8'h69]=8'hf9; sbox[8'h6a]=8'h02; sbox[8'h6b]=8'h7f;
        sbox[8'h6c]=8'h50; sbox[8'h6d]=8'h3c; sbox[8'h6e]=8'h9f; sbox[8'h6f]=8'ha8;
        sbox[8'h70]=8'h51; sbox[8'h71]=8'ha3; sbox[8'h72]=8'h40; sbox[8'h73]=8'h8f;
        sbox[8'h74]=8'h92; sbox[8'h75]=8'h9d; sbox[8'h76]=8'h38; sbox[8'h77]=8'hf5;
        sbox[8'h78]=8'hbc; sbox[8'h79]=8'hb6; sbox[8'h7a]=8'hda; sbox[8'h7b]=8'h21;
        sbox[8'h7c]=8'h10; sbox[8'h7d]=8'hff; sbox[8'h7e]=8'hf3; sbox[8'h7f]=8'hd2;
        sbox[8'h80]=8'hcd; sbox[8'h81]=8'h0c; sbox[8'h82]=8'h13; sbox[8'h83]=8'hec;
        sbox[8'h84]=8'h5f; sbox[8'h85]=8'h97; sbox[8'h86]=8'h44; sbox[8'h87]=8'h17;
        sbox[8'h88]=8'hc4; sbox[8'h89]=8'ha7; sbox[8'h8a]=8'h7e; sbox[8'h8b]=8'h3d;
        sbox[8'h8c]=8'h64; sbox[8'h8d]=8'h5d; sbox[8'h8e]=8'h19; sbox[8'h8f]=8'h73;
        sbox[8'h90]=8'h60; sbox[8'h91]=8'h81; sbox[8'h92]=8'h4f; sbox[8'h93]=8'hdc;
        sbox[8'h94]=8'h22; sbox[8'h95]=8'h2a; sbox[8'h96]=8'h90; sbox[8'h97]=8'h88;
        sbox[8'h98]=8'h46; sbox[8'h99]=8'hee; sbox[8'h9a]=8'hb8; sbox[8'h9b]=8'h14;
        sbox[8'h9c]=8'hde; sbox[8'h9d]=8'h5e; sbox[8'h9e]=8'h0b; sbox[8'h9f]=8'hdb;
        sbox[8'ha0]=8'he0; sbox[8'ha1]=8'h32; sbox[8'ha2]=8'h3a; sbox[8'ha3]=8'h0a;
        sbox[8'ha4]=8'h49; sbox[8'ha5]=8'h06; sbox[8'ha6]=8'h24; sbox[8'ha7]=8'h5c;
        sbox[8'ha8]=8'hc2; sbox[8'ha9]=8'hd3; sbox[8'haa]=8'hac; sbox[8'hab]=8'h62;
        sbox[8'hac]=8'h91; sbox[8'had]=8'h95; sbox[8'hae]=8'he4; sbox[8'haf]=8'h79;
        sbox[8'hb0]=8'he7; sbox[8'hb1]=8'hc8; sbox[8'hb2]=8'h37; sbox[8'hb3]=8'h6d;
        sbox[8'hb4]=8'h8d; sbox[8'hb5]=8'hd5; sbox[8'hb6]=8'h4e; sbox[8'hb7]=8'ha9;
        sbox[8'hb8]=8'h6c; sbox[8'hb9]=8'h56; sbox[8'hba]=8'hf4; sbox[8'hbb]=8'hea;
        sbox[8'hbc]=8'h65; sbox[8'hbd]=8'h7a; sbox[8'hbe]=8'hae; sbox[8'hbf]=8'h08;
        sbox[8'hc0]=8'hba; sbox[8'hc1]=8'h78; sbox[8'hc2]=8'h25; sbox[8'hc3]=8'h2e;
        sbox[8'hc4]=8'h1c; sbox[8'hc5]=8'ha6; sbox[8'hc6]=8'hb4; sbox[8'hc7]=8'hc6;
        sbox[8'hc8]=8'he8; sbox[8'hc9]=8'hdd; sbox[8'hca]=8'h74; sbox[8'hcb]=8'h1f;
        sbox[8'hcc]=8'h4b; sbox[8'hcd]=8'hbd; sbox[8'hce]=8'h8b; sbox[8'hcf]=8'h8a;
        sbox[8'hd0]=8'h70; sbox[8'hd1]=8'h3e; sbox[8'hd2]=8'hb5; sbox[8'hd3]=8'h66;
        sbox[8'hd4]=8'h48; sbox[8'hd5]=8'h03; sbox[8'hd6]=8'hf6; sbox[8'hd7]=8'h0e;
        sbox[8'hd8]=8'h61; sbox[8'hd9]=8'h35; sbox[8'hda]=8'h57; sbox[8'hdb]=8'hb9;
        sbox[8'hdc]=8'h86; sbox[8'hdd]=8'hc1; sbox[8'hde]=8'h1d; sbox[8'hdf]=8'h9e;
        sbox[8'he0]=8'he1; sbox[8'he1]=8'hf8; sbox[8'he2]=8'h98; sbox[8'he3]=8'h11;
        sbox[8'he4]=8'h69; sbox[8'he5]=8'hd9; sbox[8'he6]=8'h8e; sbox[8'he7]=8'h94;
        sbox[8'he8]=8'h9b; sbox[8'he9]=8'h1e; sbox[8'hea]=8'h87; sbox[8'heb]=8'he9;
        sbox[8'hec]=8'hce; sbox[8'hed]=8'h55; sbox[8'hee]=8'h28; sbox[8'hef]=8'hdf;
        sbox[8'hf0]=8'h8c; sbox[8'hf1]=8'ha1; sbox[8'hf2]=8'h89; sbox[8'hf3]=8'h0d;
        sbox[8'hf4]=8'hbf; sbox[8'hf5]=8'he6; sbox[8'hf6]=8'h42; sbox[8'hf7]=8'h68;
        sbox[8'hf8]=8'h41; sbox[8'hf9]=8'h99; sbox[8'hfa]=8'h2d; sbox[8'hfb]=8'h0f;
        sbox[8'hfc]=8'hb0; sbox[8'hfd]=8'h54; sbox[8'hfe]=8'hbb; sbox[8'hff]=8'h16;
    end
    assign out = sbox[in];
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company: VIT Vellore (Student)  
// Engineer: SANJAY ELAVARASAN KARTHIKEYAN..
// 
// Create Date: 29.03.2026 01:15:00
// Design Name: AES Hardware Design 
// Module Name: MixColoumn 
// Project Name: 
// Target Devices: --
// Tool Versions: Icarus Verilog(iverilog-v12-20220611-x64), GTKWave(GTKWave LTS 3.3.126)
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Matrix multiplication in GF(2^8):
// |2 3 1 1|   |s0|
// |1 2 3 1| × |s1|
// |1 1 2 3|   |s2|
// |3 1 1 2|   |s3|
//////////////////////////////////////////////////////////////////////////////////
// =============================================================================
// MixColumns — identical to iterative version
// =============================================================================
module aes_mixcolumns (
    input  [127:0] state_in,
    output [127:0] state_out
);
    function [7:0] xtime;
        input [7:0] b;
        begin
            xtime = b[7] ? ({b[6:0],1'b0} ^ 8'h1b) : {b[6:0],1'b0};
        end
    endfunction
 
    function [31:0] mix_col;
        input [31:0] col;
        reg [7:0] s0,s1,s2,s3,t0,t1,t2,t3;
        begin
            s0=col[31:24]; s1=col[23:16]; s2=col[15:8]; s3=col[7:0];
            t0=xtime(s0);  t1=xtime(s1);  t2=xtime(s2); t3=xtime(s3);
            mix_col[31:24] = t0^(t1^s1)^s2^s3;
            mix_col[23:16] = s0^t1^(t2^s2)^s3;
            mix_col[15:8]  = s0^s1^t2^(t3^s3);
            mix_col[7:0]   = (t0^s0)^s1^s2^t3;
        end
    endfunction
 
    assign state_out[127:96] = mix_col(state_in[127:96]);
    assign state_out[95:64]  = mix_col(state_in[95:64]);
    assign state_out[63:32]  = mix_col(state_in[63:32]);
    assign state_out[31:0]   = mix_col(state_in[31:0]);
endmodule
 
 
 //////////////////////////////////////////////////////////////////////////////////
// Company: VIT Vellore (Student)  
// Engineer: SANJAY ELAVARASAN KARTHIKEYAN..
// 
// Create Date: 29.03.2026 01:15:00
// Design Name: AES Hardware Design 
// Module Name: SubBytes
// Project Name: KEY_SCHEDULING_ALGORITHM.
// Target Devices: --
// Tool Versions: Icarus Verilog(iverilog-v12-20220611-x64), GTKWave(GTKWave LTS 3.3.126)
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Generates all 11 round keys from the 128-bit cipher key.
// Key schedule uses:
//   - RotWord  : rotate 32-bit word left by 8 bits
//   - SubWord  : apply S-Box to each byte of word
//   - Rcon     : round constant XOR on first byte
//
// All 11 round keys are produced combinationally.
//////////////////////////////////////////////////////////////////////////////////
// =============================================================================
// Key Schedule — identical to iterative version (combinational, no loops)
// Reused from iterative design unchanged.
// =============================================================================
module aes_keyschedule (
    input  [127:0]  key,
    output [1407:0] rkey_flat
);
    wire [7:0] rcon [1:10];
    assign rcon[1]=8'h01; assign rcon[2]=8'h02;
    assign rcon[3]=8'h04; assign rcon[4]=8'h08;
    assign rcon[5]=8'h10; assign rcon[6]=8'h20;
    assign rcon[7]=8'h40; assign rcon[8]=8'h80;
    assign rcon[9]=8'h1b; assign rcon[10]=8'h36;
 
    wire [31:0] w [0:43];
 
    assign w[0] = key[127:96];
    assign w[1] = key[95:64];
    assign w[2] = key[63:32];
    assign w[3] = key[31:0];
 
    genvar i;
    generate
        for (i = 1; i <= 10; i = i + 1) begin : ks_round
            wire [7:0] rot0, rot1, rot2, rot3;
            wire [7:0] sub0, sub1, sub2, sub3;
 
            assign rot0 = w[4*i-1][23:16];
            assign rot1 = w[4*i-1][15:8];
            assign rot2 = w[4*i-1][7:0];
            assign rot3 = w[4*i-1][31:24];
 
            aes_sbox sb0(.in(rot0),.out(sub0));
            aes_sbox sb1(.in(rot1),.out(sub1));
            aes_sbox sb2(.in(rot2),.out(sub2));
            aes_sbox sb3(.in(rot3),.out(sub3));
 
            assign w[4*i+0] = w[4*i-4] ^ {sub0^rcon[i], sub1, sub2, sub3};
            assign w[4*i+1] = w[4*i-3] ^ w[4*i+0];
            assign w[4*i+2] = w[4*i-2] ^ w[4*i+1];
            assign w[4*i+3] = w[4*i-1] ^ w[4*i+2];
        end
    endgenerate
 
    genvar r;
    generate
        for (r = 0; r <= 10; r = r + 1) begin : rk_pack
            assign rkey_flat[r*128 +: 128] = {w[4*r], w[4*r+1], w[4*r+2], w[4*r+3]};
        end
    endgenerate
endmodule




 