// top_mux.v - Uses ALUSrc to select between SignExtend and ReadData2 to send to the ALU as its second operand
// Basically: 1 = I-type instruction (Reg + Immediate), 0 = R-type instruction (Reg + Reg)

`timescale 1ns / 1ps

module top_mux (
output wire [31:0] y, // 32-bit output of top_mux (y = muxout [31:0])
input wire [31:0] a, // 32-bit SignExtend (a = s_extendout)
input wire [31:0] b, // 32-bit ReadData2 (b = rdata2)
input wire alusrc // Select Input (alusrc = ALUSrc)
);

assign y = alusrc ? a : b; // if (alusrc) {y=a}; else {y=b}
/*
(1 = SignExtend)
(0 = ReadData2)
*/

endmodule
