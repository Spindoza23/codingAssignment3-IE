// `timescale 1ns / 1ps
module alu_control_tb();
    // Wire Ports
    wire [2:0] select;
    // Register Declarations
    reg [1:0] alu_op;
    reg [5:0] funct;
    
    alu_control aluccontrol1 (.select(select), .aluop(alu_op), .funct(funct));
    
    initial begin
        $monitor("ALUOp = %b\tfunct = %b\tselect = %b", alu_op, funct, select);
        alu_op = 2'b00; // lwsw -> 010; add
        funct = 6'b100000; // select = 010
        #1
        alu_op = 2'b01; // I-type; BEQ -> 110 (sub)
        funct = 6'b100000; // select = 110
        #1
        alu_op = 2'b10; // R-type, and so are all subsequent opcodes
        funct = 6'b100000; // add, therefore select = 010
        #1
        funct = 6'b100010; // select = 110; sub
        #1
        funct = 6'b100100; // select = 000; and
        #1
        funct = 6'b100101; // select = 001; or
        #1
        funct = 6'b101010; // select = 111; slt
        #1
        funct = 6'b000000; // unknown
        #1
        alu_op = 2'b11; //invalid ALUop
        #1
        $finish;
    end
endmodule //alu_control_testbench
