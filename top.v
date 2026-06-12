`include "IF.v"
`include "ID.v"
`include "EX.v"


// TODO: Seperate data path logic to its own module
module top(
    clk,
    res
);
    input clk, res;

    // PC    = 63:32
    // Instr = 31:0
    reg [63:0]  IF_ID_REG;
    

    // PC          = 127:96;
    // Read data 1 = 95:64;
    // Read data 2 = 63:32;
    // Imm32       = 31: 0;
    reg [127:0] ID_EX_REG;


    // Zero        = 96;
    // New PC      = 95:64;
    // ALU result  = 63:32;
    // Read data 2 = 31: 0;
    reg [127:0] EX_MEM_REG;


    // TODO: Control signals;
    wire PCSource;

    // TODO: Once EX/MEM is complete this should be removed
    wire [31:0] PCJumpAddr;

    assign PCSource = 0;
    assign PCJumpAddr = 0;

    wire [63:0] IF_out;
    IF if_stage(
        .clk(clk),
        .res(res),
        .PCSource(PCSource),
        .PCJumpAddr(PCJumpAddr),
        .dout(IF_out)
    );

   
    wire [95:0] ID_out;
    ID id_stage(
        .clk(clk),
        .res(res),
        .input_instr(IF_ID_REG[31:0]),
        // Output
        .dout(ID_out)
    );


    // TODO: Make controll signals input from control path
    wire ALUSrc;
    assign ALUSrc = 0;
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;


    wire [96:0] EX_out;
    EX ex_stage(
        .clk(clk),
        .res(res),
        .din(ID_EX_REG),
        .dout(EX_out),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl)
    );

    always @(posedge clk or posedge res) begin
        if (res) begin
            IF_ID_REG  <=  64'b0;
            ID_EX_REG  <= 128'b0;
            EX_MEM_REG <= 97'b0;

        end
        else begin
            // IF/ID
            IF_ID_REG <= IF_out;

            // ID/EX
            ID_EX_REG[95:0]   <= ID_out;
            ID_EX_REG[127:96] <= IF_ID_REG[63:32];

            // EX/MEM
            EX_MEM_REG <= EX_out;
            
        end
    end

endmodule
