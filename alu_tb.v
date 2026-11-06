//`timescale 1ns / 1ps
/*
Tests alu.v
*/
module alu_tb;
    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] control;
    // Outputs
    wire [31:0] result;
    wire zero;
  
    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a), 
        .b(b), 
        .control(control), 
        .result(result), 
        .zero(zero)
    );
  
    initial begin
        $monitor("t=%0t a = %h\t b = %h\t control = %b\t result = %h\t zero = %b", $time, a, b, control, result, zero);
        a = 32'd10; // 10
        b = 32'd7; // 7
        #1
        control = 3'b011; //invalid -> result = x       
        #1 
        control = 3'b100; //invalid -> result = x
        #1 
        control = 3'b010; //add -> 17
        #1 
        control = 3'b110; //sub -> 3
        #1 
        control = 3'b000; // and -> 2
        #1 
        control = 3'b001; // or -> 15
        #1 
        control = 3'b111; // slt 10<7 -> 0, zero = 1
        #1
        a = 32'd5; 
        b = 32'd5;
        #1
        control = 3'b110; // sub 5-5 -> 0, zero = 1 (what the branch uses)
        #1
        a = 32'hFFFFFFFF;
        b = 32'd1;
        #1
        control = 3'b111; // slt -1<1 -> 1 (negative input)
        #1
        $finish;
    end
      
endmodule
