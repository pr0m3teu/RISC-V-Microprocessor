`include "IF.v"
`include "ID.v"

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

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imm32;
    
    ID id_stage(
        .clk(clk),
        .res(res),
        .input_instr(instr),
        .PC(PC),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm32(imm32)
    );


endmodule
