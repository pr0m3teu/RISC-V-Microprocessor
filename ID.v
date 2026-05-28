module ID(
    clk,
    res,
    input_instr,
    PC,
    rs1,
    rs2,
    rd,
    imm32
);

    input clk, res;
    input [31:0] PC;
    input [31:0] input_instr;

    output reg [4:0] rs1;
    output reg [4:0] rs2;
    output reg [4:0] rd;
    output reg [31:0] imm32;



endmodule
