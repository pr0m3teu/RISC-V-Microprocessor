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

    wire [31:0] imm32;

    reg[31:0] PC_IF_ID;
    reg[31:0] ISTR_IF_ID;
    
    ID id_stage(
        .clk(clk),
        .res(res),
        .input_instr(ISTR_IF_ID),
        .PC(PC_IF_ID),
        .imm32(imm32)
    );

    always @(posedge clk) begin
        PC_IF_ID <= PC;
        ISTR_IF_ID <= instr;
    end


endmodule
