`include "IF.v"
`include "ID.v"
`include "EX.v"

module top(
    clk,
    res
);
    input clk, res;

    wire PCSource;
    wire [31:0] PCJumpAddr;
    wire [31:0] PC;
    wire [31:0] instr;

    assign PCSource = 0;
    assign PCJumpAddr = 0;

    IF if_stage(
        .clk(clk),
        .res(res),
        .PCSource(PCSource),
        .PCJumpAddr(PCJumpAddr),
        .PC(PC),
        .instruction(instr)
    );

    reg[31:0] PC_IF_ID;
    reg[31:0] PC_ID_EX;

    reg[31:0] ISTR_IF_ID;
    wire [31:0] imm32;
    wire [31:0] rs1;
    wire [31:0] rs2;

    ID id_stage(
        .clk(clk),
        .res(res),
        .input_instr(ISTR_IF_ID),
        .PC(PC_IF_ID),
        .imm32(imm32),
        .rd1(rs1),
        .rd2(rs2)
    );

    reg[31:0] rs1_ID_EX;
    reg[31:0] rs2_ID_EX;
    reg[31:0] imm32_ID_EX;

    wire ALUSrc;
    assign ALUSrc = 0;
    

    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    wire [31:0] NewPC;

    wire [31:0] rs2_to_mem;

    EX ex_stage(
        .clk(clk),
        .res(res),
        .rs1(rs1_ID_EX),
        .rs2(rs2_ID_EX),
        .imm32(imm32_ID_EX),
        .PC(PC_ID_EX),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .PCJmpAddress(NewPC),
        .rs2_to_mem(rs2_to_mem)
    );

    always @(posedge clk) begin
        // IF/ID
        PC_IF_ID <= PC;
        ISTR_IF_ID <= instr;
        // ID/EX
        PC_ID_EX <= PC_IF_ID;
        imm32_ID_EX <= imm32;
        rs1_ID_EX <= rs1;
        rs2_ID_EX <= rs2;
    end


endmodule
