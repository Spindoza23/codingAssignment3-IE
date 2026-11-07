// alu_control.v - Takes in 6 bit of s_extendout with alu_op and outputs select, which is the control for alu.v 
// This bridges machine language with assembly language.
//`timescale 1ns / 1ps

module alu_control(
    input wire [5:0] funct, //from ID/EX latch (sing extend [5:0])
    input wire [1:0] aluop, //from the control (id/ex execute bits)
    output reg [2:0] select // to alu.v
);
    // ALU Op values
    parameter lwsw  = 2'b00,   // LW/SW: add; since LW and SW use the same bit pattern, only way to store them as a paramter
              Itype = 2'b01,   // BEQ: subtract; beq, branch
              Rtype =  2'b10;  // these are the function field paramters for Rtype.this is a 2 bit parameter
                    /* Radd = 2'b10,
                    Rsub = 2'b10,
                    Rand = 2'b10,
                    Ror = 2'b10,
                    Rslt = 2'b10; */
    // ALU select codes
    parameter ALUadd = 3'b010,  //for R-type instructions
              ALUsub = 3'b110,
              ALUand = 3'b000,
              ALUor  = 3'b001,
              ALUslt = 3'b111,
              ALUx   = 3'b011; // invalid input -> ALU output x's
    /* parameter xis = 6'bXXXXXX; // not in diagrams, but assuming for don't care 
    //If the input information does not correspond to any valid instruction,
    //aluop = 2'b11 which sets control = ALUx = 3'b011 
    //and ALU output is 32 x's 
    parameter unknown = 2'b11, //for invalid opcode, ALUop = 2'b11 */
    // Funct Field codes
    parameter FUNCTadd = 6'b100000,
              FUNCTsub = 6'b100010,
              FUNCTand = 6'b100100,
              FUNCTor  = 6'b100101,
              FUNCTslt = 6'b101010;
    
    initial select = 3'b000;
    always@(*) begin
        case (aluop)
            lwsw: select = ALUadd;
            Itype: select = ALUsub;
            Rtype: begin
                case (funct)
                    FUNCTadd: select = ALUadd;
                    FUNCTsub: select = ALUsub;
                    FUNCTand: select = ALUand;
                    FUNCTor:  select = ALUor;
                    FUNCTslt: select = ALUslt;
                    default:  select = ALUx;
                endcase
            end
            default: seelct = ALUx; // aluop unknown
        endcase
    end
endmodule
