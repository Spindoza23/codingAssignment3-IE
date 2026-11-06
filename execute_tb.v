//executeTB.v
`timescale 1ns / 1ps // ADDED: same timescale as the other modules, so #5 means 5 ns

module executeTB;
    reg clk;
    reg [1:0] ctlwb_in;
    reg [2:0] ctlm_in; // CHANGED: was [1:0]. M control is 3 bits (branch, memread, memwrite), so it was split off from ctlwb_in
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [4:0] instr_2016, instr_1511;
    reg [1:0] alu_op;
    reg [5:0] funct;
    reg alusrc, regdst;

    wire [1:0] ctlwb_out;
    wire [2:0] ctlm_out; // CHANGED: was [1:0], now 3 bits to match ctlm_in
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire [4:0] muxout_out;
    wire zero; // ADDED: zero flag from the ALU (needed for branches, so we want to see it in the waveform)

    execute uut (
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .npc(npc),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extend(s_extend),
        .instr_2016(instr_2016),
        .instr_1511(instr_1511),
        .alu_op(alu_op),
        .funct(funct),
        .alusrc(alusrc),
        .regdst(regdst),
        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out),
        .zero(zero) // ADDED: hook up the zero output
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ADDED: print outputs to the console every time they change (easy to check against expected values)
    initial begin
        $monitor("t=%0t | ctlwb_out=%b ctlm_out=%b | adder_out=%0d alu_result_out=%0d zero=%b rdata2_out=%0d muxout_out=%0d",
                 $time, ctlwb_out, ctlm_out, adder_out, alu_result_out, zero, rdata2_out, muxout_out);
    end

    // NOTE on timing: the clock rises at 5, 15, 25, ... ns and falls at 10, 20, 30, ... ns.
    // CHANGED: the delays are now #20 instead of #15. Before, inputs changed at 15 ns, the same instant
    // as a rising edge, which is a race (the latch might grab the old OR the new values).
    // With #20, inputs always change on a falling edge and the latch picks them up 5 ns later on the rising edge.
    initial begin
        // Initialize inputs
        // Test 1: R-type ADD, but with alusrc = 1 so the ALU adds the immediate: 10 + 4 = 14
        // expected: adder_out = 100 + 4 = 104, alu_result_out = 14, zero = 0, muxout_out = 10 (regdst = 1 -> instr_1511)
        ctlwb_in = 2'b10; ctlm_in = 3'b000; // CHANGED: ctlm_in = 2'b01 -> 3'b000 (3 bits now, no memory access for an add)
        npc = 32'd100; rdata1 = 32'd10; rdata2 = 32'd20; s_extend = 32'd4;
        instr_2016 = 5'd5; instr_1511 = 5'd10;
        alu_op = 2'b10; funct = 6'b100000;
        alusrc = 1; regdst = 1;

        #20;

        // Modify inputs to test different scenarios
        // Test 2: BEQ (alu_op = 01 -> subtract) with unequal registers: 10 - 20 = -10
        // expected: adder_out = 100 + 8 = 108, alu_result_out = -10 (4294967286 unsigned), zero = 0, muxout_out = 5
        alusrc = 0; regdst = 0;
        s_extend = 32'd8;
        alu_op = 2'b01; funct = 6'b100010;
        ctlm_in = 3'b100; // ADDED: branch = 1 for a beq

        #20;

        // ADDED: extra test cases below so every ALU operation and the zero flag get checked
        // Test 3: BEQ with equal registers: 20 - 20 = 0  -> zero = 1 (branch would be taken)
        rdata1 = 32'd20;

        #20;

        // Test 4: LW (alu_op = 00 -> add), address = rdata1 + offset = 20 + 8 = 28, memread = 1
        ctlwb_in = 2'b11; ctlm_in = 3'b010;
        alu_op = 2'b00; alusrc = 1; regdst = 0;

        #20;

        // Test 5: SW (alu_op = 00 -> add), address = 20 + 8 = 28, memwrite = 1, no register write back
        ctlwb_in = 2'b00; ctlm_in = 3'b001;

        #20;

        // Test 6: R-type AND: 12 & 10 = 8  (1100 & 1010 = 1000)
        ctlwb_in = 2'b10; ctlm_in = 3'b000;
        rdata1 = 32'd12; rdata2 = 32'd10;
        alu_op = 2'b10; funct = 6'b100100; alusrc = 0; regdst = 1;

        #20;

        // Test 7: R-type OR: 12 | 10 = 14  (1100 | 1010 = 1110)
        funct = 6'b100101;

        #20;

        // Test 8: R-type SLT: is 12 < 10? no -> 0, so zero = 1
        funct = 6'b101010;

        #20;

        // Test 9: R-type SLT with a negative number: is -5 < 10? yes -> 1
        rdata1 = -32'd5;

        #20;

        $stop;
    end
endmodule
