`include "IF.v"
`include "ID.v"
`include "EX.v"
`include "MEM.v"


// TODO: Seperate data path logic to its own module
module top(
    clk,
    res
);
    input clk, res;

    // PC    = 63:32
    // Instr = 31:0
    reg [63:0]  IF_ID_REG;
    

    // Write reg   = 132:128;
    // PC          = 127:96;
    // Read data 1 = 95:64;
    // Read data 2 = 63:32;
    // Imm32       = 31: 0;
    reg [132:0] ID_EX_REG;


    // Write reg   = 101:97;
    // Zero        = 96;
    // New PC      = 95:64;
    // ALU result  = 63:32;
    // Read data 2 = 31: 0;
    reg [101:0] EX_MEM_REG;


    // Write reg  = 68:64;
    // Read Data  = 63:32;
    // ALU Result = 31:0;
    reg [68:0] MEM_WB_REG;
    

    // TODO: Signal to be unhardcoded
    wire MemToReg;
    assign MemToReg = 0;

    // Write reg  = 36:34;
    // Write data = 31: 0;
    wire [36:0] WB_stage;
    assign WB_stage[31:0] = MemToReg ? MEM_WB_REG[63:32] : MEM_WB_REG[31:0]; 
    assign WB_stage[36:32] = MEM_WB_REG[68:64];


    // TODO: Control signals;
    wire PCSource;

    // TODO: Once EX/MEM is complete this should be removed
    wire [31:0] PCJumpAddr;

    assign PCSource = 0;
    assign PCJumpAddr = EX_MEM_REG[95:64];

    wire [63:0] IF_out;
    IF if_stage(
        .clk(clk),
        .res(res),
        .PCSource(PCSource),
        .PCJumpAddr(PCJumpAddr),
        .dout(IF_out)
    );

   
    wire [100:0] ID_out;
    ID id_stage(
        .res(res),
        .input_instr(IF_ID_REG[31:0]),
        .write_dest(WB_stage[36:32]),
        .write_data(WB_stage[31:0]),
        .dout(ID_out)
    );


    // TODO: Make controll signals input from control path
    wire ALUSrc;
    assign ALUSrc = 0;
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;


    wire [101:0] EX_out;
    EX ex_stage(
        .clk(clk),
        .res(res),
        .din(ID_EX_REG),
        .dout(EX_out),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl)
    );

    // TODO: Signal to be unhardcoded
    wire MEMWrite;
    assign MEMWrite = 0;
    wire [68:0] MEM_out;
    MEM mem_stage(
        .din(EX_MEM_REG),
        .dout(MEM_out),
        .mem_write(MEMWrite)
    );
    
    
    always @(posedge clk or posedge res) begin
        if (res) begin
            IF_ID_REG  <=  64'b0;
            ID_EX_REG  <= 133'b0;
            EX_MEM_REG <= 102'b0;
            MEM_WB_REG <= 69'b0;

        end
        else begin
            // IF/ID
            IF_ID_REG <= IF_out;

            // ID/EX
            // TODO: Unhardcode the values of these pins for all regsiters asap
            ID_EX_REG[95:0]    <= ID_out[95:0];
            ID_EX_REG[127:96]  <= IF_ID_REG[63:32];
            ID_EX_REG[132:128] <= ID_out[100:96];

            // EX/MEM
            EX_MEM_REG <= EX_out;

            // MEM/WB
            MEM_WB_REG <= MEM_out;
            
        end
    end

endmodule
