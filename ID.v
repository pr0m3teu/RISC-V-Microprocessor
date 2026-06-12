`include "parts/registers.v"
`include "parts/immgen.v"

module ID(
    clk,
    res,
    input_instr,
    dout 
);

    input clk, res;
    input [31:0] input_instr;

    // Read data 1 = 95:64;
    // Read data 2 = 63:32;
    // Imm32       = 31: 0;
    output wire [95:0] dout;

    // TODO: Needs to be handled by control path
    wire RegWrite;
    assign RegWrite = 0;

    // TODO: Add write data to registers file
    registers reg_file(
        .clk(clk),
        .rreg1(input_instr[19:15]),
        .rreg2(input_instr[24:20]),
        .wreg(input_instr[11:7]),
        .out_reg1(dout[95:64]),
        .out_reg2(dout[63:32]),
        .RegWrite(RegWrite)
    );
    
    ImmGen imm_gen(
        .instruction(input_instr),
        .imm32(dout[31:0])
    );

endmodule
