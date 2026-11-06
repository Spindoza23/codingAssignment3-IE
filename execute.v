`timescale 1ns / 1ps
/*
Execute Stage: This uses the outputs of Fetch and Decode Stages as well as combining the modules: adder, bottom_mux(5-bit), alu_control, alu, top_mux(32-bit),
and ex_mem.
*/
// CHANGED: module name EXECUTE -> execute, and the port names were renamed to match executeTB.v
// (old name shown in each comment so you can see what it used to be called)
module execute(
    input wire clk, // ADDED: clock, passed down to the ex_mem latch
    input wire [1:0] ctlwb_in, //11 inputs, based off of outputs of ID/EX latch (Lab 2-2)   (was wb_ctl)
    input wire [2:0] ctlm_in, // {branch, memread, memwrite}   (was m_ctl)
    input wire regdst, alusrc,
    input wire [1:0] alu_op, // (was aluop)
    input wire [5:0] funct, // ADDED: Instr[5:0] from ID/EX latch, goes to alu_control (assignment says ALU control uses the 6 lowest bits of the instruction)
    input wire [31:0] npc, rdata1, rdata2, s_extend, // (were npcout, rdata1, rdata2, s_extendout)
    input wire [4:0] instr_2016, instr_1511, // (were instrout_2016, instrout_1511)
    output wire [1:0] ctlwb_out, //9 total outputs from EX/MEM latch   (was wb_ctlout)
    output wire [2:0] ctlm_out, // ADDED: {branch, memread, memwrite} bundled together to match the testbench   (was branch, memread, memwrite)
    output wire [31:0] adder_out, // Add_Result   (was EX_MEM_NPC)
    output wire zero,
    output wire [31:0] alu_result_out, rdata2_out, // (were alu_result, rdata2out)
    output wire [4:0] muxout_out // FiveBitMuxout   (was five_bit_muxout)
);
// signals
wire [31:0] add_out, b, aluout;//internal wires to connect internal EXECUTE components together
// CHANGED: internal adder wire renamed adder_out -> add_out, because adder_out is now the name of an output port
wire [4:0] muxout;
wire [2:0] control;
wire aluzero;
wire branch, memread, memwrite; // ADDED: the 3 M control bits coming out of ex_mem, recombined into ctlm_out below
adder adder3(
    .add_in1(npc),
    .add_in2(s_extend),
    .add_out(add_out)
);
bottom_mux bottom_mux3(
    .a(instr_1511),  //in case of error, check this
    .b(instr_2016),  // (checked: regdst = 1 -> rd/Instr[15:11], regdst = 0 -> rt/Instr[20:16], matches the diagram)
    .sel(regdst),
    .y(muxout)
);
alu_control alu_control3(
    .funct(funct), // CHANGED: was s_extendout[5:0], now uses the funct input (Instr[5:0]) passed through the ID/EX latch
    .aluop(alu_op),
    .select(control)
);
alu alu3(
    .a(rdata1),
    .b(b), // b <= output of top_mux
    .control(control),
    .result(aluout),
    .zero(aluzero)
);
top_mux top_mux3(
    .y(b), // output of mux is 32 bit "b" wire
    .a(s_extend),
    .b(rdata2), // input a = 1'b1, b = 1'b0
    .alusrc(alusrc)
);
ex_mem ex_mem3(
    .clk(clk), // ADDED: connect the clock to the latch
    .ctlwb_out(ctlwb_in), // inputs, which should stem from intermediate modules
    .ctlm_out(ctlm_in),
    .adder_out(add_out),
    .aluzero(aluzero),
    .aluout(aluout),
    .readdat2(rdata2),
    .muxout(muxout),
    .wb_ctlout(ctlwb_out), // outputs going to FETCH or MEM/WB
    .branch(branch),
    .memread(memread),
    .memwrite(memwrite),
    .add_result(adder_out),
    .zero(zero),
    .alu_result(alu_result_out),
    .rdata2out(rdata2_out),
    .five_bit_muxout(muxout_out)
);
assign ctlm_out = {branch, memread, memwrite}; // ADDED: put the 3 M bits back together for the MEM stage / testbench

endmodule // IEXECUTE
