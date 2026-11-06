// adder.v - Adds two 32-bit inputs to output a 32-bit value. Takes in npcout and s_extendout to output adder_out.
`timescale 1ns / 1ps

module adder(
    input wire [31:0] add_in1, // 32-bit NPC - Next Program Counter (address of next insruction)
    input wire [31:0] add_in2, // 32-bit SignExtend (immediate field from I-type instruction)
    output wire [31:0] add_out // 32-bit Add_Result (potential branch destination)
    );
 
assign add_out = add_in1 + add_in2; // Add_Result = NPC + SignExtend

endmodule
