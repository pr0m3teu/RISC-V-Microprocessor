`include "parts/alu.v"


module EX(
    clk,
    res,
    rs1,
    rs2,
    ALUSrc,
    ALUControl,
    imm32,
    PC,
    ALUResult,
    Zero,
    PCJmpAddress,
    rs2_to_mem
);

    input clk, res;
    input ALUSrc;
    input [3:0] ALUControl;

    input [31:0] PC;
    input [31:0] imm32;
    input [31:0] rs1;
    input [31:0] rs2;

    output wire Zero;
    output wire [31:0] ALUResult;
    output wire [31:0] PCJmpAddress;
    output wire [31:0] rs2_to_mem;
    
    wire [31:0] aluOpB;
    assign aluOpB = ALUSrc ? imm32 : rs2;

    ALU alu(
        .clk(clk),
        .res(res),
        .src1(rs1),
        .src2(aluOpB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .zero(Zero)
    );

    assign PCJmpAddress = PC + imm32;
    assign rs2_to_mem = rs2;

endmodule
