`include "parts/registers.v"
`include "parts/immgen.v"

module ID(
    res,
    input_instr,
    write_dest,
    write_data,
    dout,
    RegWrite
);
    input res;
    input RegWrite;
    input [31:0] input_instr;
    input [31:0] write_data;
    input [4:0]  write_dest;

    // Write reg   = 100:96;
    // Read data 1 = 95 :64;
    // Read data 2 = 63 :32;
    // Imm32       = 31 : 0;
    output wire [100:0] dout;

    // Value of write reg
    assign dout[100:96] = input_instr[11:7];

    registers reg_file(
        .rreg1(input_instr[19:15]),
        .rreg2(input_instr[24:20]),
        .wreg(write_dest),
        .wdata(write_data),
        .out_reg1(dout[95:64]),
        .out_reg2(dout[63:32]),
        .RegWrite(RegWrite),
        .res(res)
    );
    
    ImmGen imm_gen(
        .instruction(input_instr),
        .imm32(dout[31:0])
    );

endmodule
