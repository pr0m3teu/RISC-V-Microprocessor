`include "parts/registers.v"
`include "parts/immgen.v"

module ID(
    clk,
    res,
    input_instr,
    PC,
    imm32,
    PC_out,
);

    input clk, res;
    input [31:0] PC;
    input [31:0] input_instr;

    output wire [31:0] rd1;
    output wire [31:0] rd2;
    output wire [31:0] imm32;
    output reg [31:0] PC_out;

    // Needs to be handled by control path
    wire RegWrite;
    assign RegWrite = 0;

    registers reg_file(
        .clk(clk),
        .rreg1(input_instr[19:15]),
        .rreg2(input_instr[24:20]),
        .wreg(input_instr[11:7]),
        .out_reg1(rd1),
        .out_reg2(rd2),
        .RegWrite(RegWrite)
    );
    
    ImmGen imm_gen(
        .instruction(input_instr),
        .imm32(imm32)
    );

    always @(posedge clk) begin 
        PC_out <= PC;
    end


endmodule
