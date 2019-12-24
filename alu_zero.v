`timescale 1ns/1ns

module testBench();

  wire[15:0] a, b, f;
  wire[2:0] opcode;

  testALU test (f, a, b, opcode);
  fullALU alu (f, a, b, opcode);

endmodule

module testALU(f, a, b, opcode);

  input[15:0] f;
  output[15:0] a, b;
  output[2:0] opcode;

  reg[15:0] a, b;
  reg[2:0] opcode;

  initial begin
    
    $monitor($time,,,,"opcode=%b, a=%b, b=%b, f=%b", opcode, a, b, f);
    $display($time,,,,"opcode=%b, a=%b, b=%b, f=%b", opcode, a, b, f);

    //  And
    #100   opcode=000;   a=7;    b=4;
    #100   opcode=000;   a=25;   b=-40;
    #100   opcode=000;   a=-77;  b=33;
    #100   opcode=000;   a=-397; b=-614;

    //  Or
    #100   opcode=001;   a=7;    b=4;
    #100   opcode=001;   a=25;   b=-40;
    #100   opcode=001;   a=-77;  b=33;
    #100   opcode=001;   a=-397; b=-614;

    //  Add
    #100   opcode=010;   a=7;    b=4;
    #100   opcode=010;   a=25;   b=-40;
    #100   opcode=010;   a=-77;  b=33;
    #100   opcode=010;   a=-397; b=-614;

    //  Subtract
    #100   opcode=110;   a=7;    b=4;
    #100   opcode=110;   a=25;   b=-40;
    #100   opcode=110;   a=-77;  b=33;
    #100   opcode=110;   a=-397; b=-614;

    //  SLT
    #100   opcode=111;   a=7;    b=4;
    #100   opcode=111;   a=25;   b=-40;
    #100   opcode=111;   a=-77;  b=33;
    #100   opcode=111;   a=-397; b=-614;

    #100

    $display($time,,,,"opcode=%b, a=%b, b=%b, f=%b", opcode, a, b, f);

  end

  endmodule

//  Full ALU design
module fullALU(f, a, b, opcode);

  // Inputs A and B, three bit opcode, and output F
  input[15:0] a, b;
  input[2:0] opcode;
  output[15:0] f;

  //  Temp wires for circuit
  wire[15:0] a_and_b;
  wire[15:0] a_or_b;
  wire[15:0] a_plus_minus_b;
  wire[15:0] a_slt_b;

  //  Performs all operations to go into mux
  sixteenBitAnd and16 (a_and_b, a, b);
  sixteenBitOr or16 (a_or_b, a, b);
  sixteenBitAddSubtract addSub (a_plus_minus_b, a, b, opcode[2]);
  slt setLess (a_slt_b, a, b);

  //  Selects operation based on opcode
  sixteenBitMuxFourToOne mux (f, opcode[1:0], a_and_b, a_or_b, a_plus_minus_b, a_slt_b);
  
endmodule

/************************************************************************************************************************/

//  And with 16 bit inputs and output
module sixteenBitAnd(f, a, b);
  
  //  Inputs a and b, output f
  input[15:0] a, b;
  output[15:0] f;

  //  And each bit from a and b, output into f
  and (f[0], a[0], b[0]);
  and (f[1], a[1], b[1]);
  and (f[2], a[2], b[2]);
  and (f[3], a[3], b[3]);
  and (f[4], a[4], b[4]);
  and (f[5], a[5], b[5]);
  and (f[6], a[6], b[6]);
  and (f[7], a[7], b[7]);
  and (f[8], a[8], b[8]);
  and (f[9], a[9], b[9]);
  and (f[10], a[10], b[10]);
  and (f[11], a[11], b[11]);
  and (f[12], a[12], b[12]);
  and (f[13], a[13], b[13]);
  and (f[14], a[14], b[14]);
  and (f[15], a[15], b[15]);
  
endmodule

/************************************************************************************************************************/

//  Or with 16 bit inputs and output
module sixteenBitOr(f, a, b);

  //  Inputs a and b, output f
  input[15:0] a, b;
  output[15:0] f;

  //  Or each bit from a and b, output into f
  or (f[0], a[0], b[0]);
  or (f[1], a[1], b[1]);
  or (f[2], a[2], b[2]);
  or (f[3], a[3], b[3]);
  or (f[4], a[4], b[4]);
  or (f[5], a[5], b[5]);
  or (f[6], a[6], b[6]);
  or (f[7], a[7], b[7]);
  or (f[8], a[8], b[8]);
  or (f[9], a[9], b[9]);
  or (f[10], a[10], b[10]);
  or (f[11], a[11], b[11]);
  or (f[12], a[12], b[12]);
  or (f[13], a[13], b[13]);
  or (f[14], a[14], b[14]);
  or (f[15], a[15], b[15]);
  
endmodule

/************************************************************************************************************************/

//  Not with 16 bit input and output
module sixteenBitNot(f, a);

  //  Input a, output f
  input[15:0] a;
  output[15:0] f;

  //  Not each bit from a, output into f
  not (f[0], a[0]);
  not (f[1], a[1]);
  not (f[2], a[2]);
  not (f[3], a[3]);
  not (f[4], a[4]);
  not (f[5], a[5]);
  not (f[6], a[6]);
  not (f[7], a[7]);
  not (f[8], a[8]);
  not (f[9], a[9]);
  not (f[10], a[10]);
  not (f[11], a[11]);
  not (f[12], a[12]);
  not (f[13], a[13]);
  not (f[14], a[14]);
  not (f[15], a[15]);

endmodule

/************************************************************************************************************************/

//  1 bit full adder
module fullAdder(s, cout, a, b, c);

  //  Inputs a, b, and cin, outputs f and cout
  input a, b, c;
  output s, cout;

  //  Temp wires used for circuits
  wire a_xor_b, a_and_c, b_and_c, a_and_b;

  //  A xor b is stored in a_xor_b, then xor'ed with c, outputted to s
  xor
  g1(a_xor_b, a, b),
  g2(s, a_xor_b, c);

  //  A and b, a and c, b and c, stored in wires
  and
  g3(a_and_b, a, b),
  g4(a_and_c, a, c),
  g5(b_and_c, b, c);

  //  a_and_b or a_and_c or b_and_c
  or
  g6(cout, a_and_b, a_and_c, b_and_c);

endmodule

/************************************************************************************************************************/

//  16 bit full adder
module sixteenBitAdder (s, a, b);

  //  Inputs a, b, and cin, outputs f and cout
  input [15:0] a, b;
  reg cin = 0;

  output [15:0] s;
  
  //  Temp wire t
  wire [15:0] t;

  //  Add bits from a and b, stores cout in t and uses it as cin for next add, stores sum in s
  fullAdder a0 (s[0], t[0], a[0], b[0], cin);
  fullAdder a1 (s[1], t[1], a[1], b[1], t[0]);
  fullAdder a2 (s[2], t[2], a[2], b[2], t[1]);
  fullAdder a3 (s[3], t[3], a[3], b[3], t[2]);
  fullAdder a4 (s[4], t[4], a[4], b[4], t[3]);
  fullAdder a5 (s[5], t[5], a[5], b[5], t[4]);
  fullAdder a6 (s[6], t[6], a[6], b[6], t[5]);
  fullAdder a7 (s[7], t[7], a[7], b[7], t[6]);
  fullAdder a8 (s[8], t[8], a[8], b[8], t[7]);
  fullAdder a9 (s[9], t[9], a[9], b[9], t[8]);
  fullAdder a10 (s[10], t[10], a[10], b[10], t[9]);
  fullAdder a11 (s[11], t[11], a[11], b[11], t[10]);
  fullAdder a12 (s[12], t[12], a[12], b[12], t[11]);
  fullAdder a13 (s[13], t[13], a[13], b[13], t[12]);
  fullAdder a14 (s[14], t[14], a[14], b[14], t[13]);
  fullAdder a15 (s[15], t[15], a[15], b[15], t[14]);

endmodule

/************************************************************************************************************************/

//  16 bit adder/subtractor
module sixteenBitAddSubtract(f, a, b, sub);
  
  //  Inputs a and b, the numbers to be added/subtracted
  input[15:0] a, b;
  //  Constant one represents 1
  wire[15:0] one = 1;
  //  Input sub tells whether a and b will be added or subtracted
  input sub;
  output[15:0] f;

  //  Temp wires for circuits
  wire [15:0] not_b, twos_comp_b, mux_out;

  //  Conversion of b to 2s compliment
  sixteenBitNot not16 (not_b, b);
  sixteenBitAdder twos (twos_comp_b, not_b, one);

  //  Checks whether to use positive or 2s comp, then adds them together
  sixteenBitMuxTwoToOne mux (mux_out, sub, b, twos_comp_b);
  sixteenBitAdder add (f, a, mux_out);

endmodule

/************************************************************************************************************************/

//  16 bit slt
module slt(f, a, b);

  //  Inputs a and b, output f
  input[15:0] a, b;
  output[15:0] f;

  //  Temp wire sub
  wire[15:0] sub;
  wire zero = 0;
  wire one = 1;

  //  Subtract a - b, store in sub
  sixteenBitAddSubtract addSub (sub, a, b, one);

  //  Or most significant bit from sub with 0
  or (f[0], sub[15], zero);
  and (f[1], f[1], zero);
  and (f[2], f[2], zero);
  and (f[3], f[3], zero);
  and (f[4], f[4], zero);
  and (f[5], f[5], zero);
  and (f[6], f[6], zero);
  and (f[7], f[7], zero);
  and (f[8], f[8], zero);
  and (f[9], f[9], zero);
  and (f[10], f[10], zero);
  and (f[11], f[11], zero);
  and (f[12], f[12], zero);
  and (f[13], f[13], zero);
  and (f[14], f[14], zero);
  and (f[15], f[15], zero);

endmodule

/************************************************************************************************************************/

//  4 to 1 multiplexer
module muxFourToOne(f, s, a, b, c, d);

  //  Inputs a, b, c, d, selector bits s, output f
  input a, b, c, d;
  input[1:0] s;
  output f;

  //  Temp wires used for circuits
  wire a_and_s, b_and_s, c_and_s, d_and_s, not_s0, not_s1;

  //  Invert both selector bits
  not(not_s1, s[1]);
  not(not_s0, s[0]);

  //  And all inputs with appropriate selector bits
  and(a_and_s, a, not_s1, not_s0);
  and(b_and_s, b, not_s1, s[0]);
  and(c_and_s, c, s[1], not_s0);
  and(d_and_s, d, s[1], s[0]);

  //  Or all and outputs together
  or(f, a_and_s, b_and_s, c_and_s, d_and_s);

endmodule

/************************************************************************************************************************/

//  16 bit 4 to 1 multiplexer
module sixteenBitMuxFourToOne(f, s, a, b, c, d);
  
  //  Inputs a, b, c, d, selector bits s, output f
  input[15:0] a, b, c, d;
  input[1:0] s;
  output[15:0] f;

  //  Mux all bits from all inputs, store in f
  muxFourToOne m0 (f[0], s, a[0], b[0], c[0], d[0]);
  muxFourToOne m1 (f[1], s, a[1], b[1], c[1], d[1]);
  muxFourToOne m2 (f[2], s, a[2], b[2], c[2], d[2]);
  muxFourToOne m3 (f[3], s, a[3], b[3], c[3], d[3]);
  muxFourToOne m4 (f[4], s, a[4], b[4], c[4], d[4]);
  muxFourToOne m5 (f[5], s, a[5], b[5], c[5], d[5]);
  muxFourToOne m6 (f[6], s, a[6], b[6], c[6], d[6]);
  muxFourToOne m7 (f[7], s, a[7], b[7], c[7], d[7]);
  muxFourToOne m8 (f[8], s, a[8], b[8], c[8], d[8]);
  muxFourToOne m9 (f[9], s, a[9], b[9], c[9], d[9]);
  muxFourToOne m10 (f[10], s, a[10], b[10], c[10], d[10]);
  muxFourToOne m11 (f[11], s, a[11], b[11], c[11], d[11]);
  muxFourToOne m12 (f[12], s, a[12], b[12], c[12], d[12]);
  muxFourToOne m13 (f[13], s, a[13], b[13], c[13], d[13]);
  muxFourToOne m14 (f[14], s, a[14], b[14], c[14], d[14]);
  muxFourToOne m15 (f[15], s, a[15], b[15], c[15], d[15]);

endmodule

/************************************************************************************************************************/

//  2 to 1 multiplexer
module muxTwoToOne(f, s, a, b);

  //  Inputs a and b, selector bit s, output f
  input a, b;
  input s;
  output f;

  //  Temp wires used for circuits
  wire a_and_s, b_and_s, not_s;

  //  Invert selector bit
  not(not_s, s);

  //  And a and b with selector bit
  and(a_and_s, a, not_s);
  and(b_and_s, b, s);

  //  Or both ands together
  or(f, a_and_s, b_and_s);

endmodule

/************************************************************************************************************************/

//  16 bit 2 to 1 multiplexer
module sixteenBitMuxTwoToOne(f, s, a, b);

  //  Inputs a and b, selector bit s, output f
  input[15:0] a, b;
  input s;
  output[15:0] f;

  //  Mux all bits from both inputs, store in f
  muxTwoToOne m0 (f[0], s, a[0], b[0]);
  muxTwoToOne m1 (f[1], s, a[1], b[1]);
  muxTwoToOne m2 (f[2], s, a[2], b[2]);
  muxTwoToOne m3 (f[3], s, a[3], b[3]);
  muxTwoToOne m4 (f[4], s, a[4], b[4]);
  muxTwoToOne m5 (f[5], s, a[5], b[5]);
  muxTwoToOne m6 (f[6], s, a[6], b[6]);
  muxTwoToOne m7 (f[7], s, a[7], b[7]);
  muxTwoToOne m8 (f[8], s, a[8], b[8]);
  muxTwoToOne m9 (f[9], s, a[9], b[9]);
  muxTwoToOne m10 (f[10], s, a[10], b[10]);
  muxTwoToOne m11 (f[11], s, a[11], b[11]);
  muxTwoToOne m12 (f[12], s, a[12], b[12]);
  muxTwoToOne m13 (f[13], s, a[13], b[13]);
  muxTwoToOne m14 (f[14], s, a[14], b[14]);
  muxTwoToOne m15 (f[15], s, a[15], b[15]);

endmodule