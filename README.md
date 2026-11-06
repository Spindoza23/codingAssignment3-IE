# Coding Assignment 3 — Execute Stage
<!--
Replace every item in square brackets before submitting.
Keep this README focused on what the design does, how it is used, and how it was
verified.
-->
## Design Scope and Assumptions
- **In scope:** The execute stage of the MIPS pipeline takes the operands and control bits from the ID/EX latch, performing the arithmetic or logic operation in the ALU, computing the branch target address, selecting the destination register number, and storing results in the EX/MEM latch.
- **Out of scope:** Future stages (MEM & WB) as well as hazard handling will be implemented in later labs.
- **Assumptions:** 32-bit data and addresses. The ALU, ALU control, muxes, and branch adder are combinational. Only the EX/MEM latch is clocked, on the rising clock edge. ALU control follows Fig. 2 in the images folder.
- **Limitations:** The ALU supports add, subtract, AND, OR< and set-on-less-than. Invalid ALUOp combinations produce select 011, and the ALU outputs unknown XXX values for any invalid select code.
## Requirements
| Requirement | Description | Verification Method |
|---|---|---|
| REQ-01 | [The design shall ...] | [Test case, waveform, calculation, or
inspection] |
| REQ-02 | [The design shall ...] | [Test case, waveform, calculation, or
inspection] |
| REQ-03 | [The design shall ...] | [Test case, waveform, calculation, or
inspection] |
## Architecture
### Timing or Behavioral Summary
Save diagrams in the repository's `images/` folder. Use relative paths so they
display on GitHub.
![Timing Diagram](images/[timing-diagram-filename].png)
## Implementation
### Source Code
| File | Description |
|---|---|
| [`[module].v`](LINK_TO_IMPLEMENTATION_CODE) | [Primary implementation module] |
| [`[component].v`](LINK_TO_COMPONENT_CODE) | [Supporting component] |
| [`[testbench].v`](LINK_TO_TESTBENCH_CODE) | [Verification testbench] |
### Implementation Notes
- [Explain one important design decision.]
- [Identify any parameterization, reusable module, or interface convention.]
- [Document any deliberate simplification made for this lab.]
## Verification
### Verification Strategy
The design is verified using **[simulation, formal checks, hardware testing, or
another method]**.
Verification covers:
- [Normal operating case]
- [Boundary or maximum-value case]
- [Reset or initialization case]
- [Invalid, stalled, or exceptional case, if applicable]
### Testbench and Waveform
Save screenshots and waveform images in the repository's `images/` folder.
![Testbench or waveform](images/[testbench-screenshot-filename].png)
The testbench source is available [*here*](LINK_TO_TESTBENCH_CODE).
### Results
| Test Case | Expected Result | Observed Result | Status |
|---|---|---|---|
| TC-01 — [Name] | [Expected behavior] | [Observed behavior] | Pass / Fail |
| TC-02 — [Name] | [Expected behavior] | [Observed behavior] | Pass / Fail |
| TC-03 — [Name] | [Expected behavior] | [Observed behavior] | Pass / Fail |
## Reproduction Instructions
### Tools and Versions
- **Simulator / synthesis tool:** [Name and version]
- **Language / standard:** [Verilog/SystemVerilog version]
- **Operating system:** [macOS, Windows, Linux, or other]
- **Additional dependencies:** [List any required tools or libraries]
### Build and Run
```bash
# Replace these commands with the commands required for this lab.
[compile-command]
[run-command]
```
Expected output:
```text
[Paste a short representative output or result here.]
```
## Repository Organization
```text
.
├── README.md
├── images/
│ ├── [timing-diagram-filename].png
│ └── [testbench-screenshot-filename].png
├── [source-files]
└── [testbench-files]
```
## Known Issues and Future Improvements
- [Document any known issue, unverified behavior, or technical debt.]
- [Describe a realisti
