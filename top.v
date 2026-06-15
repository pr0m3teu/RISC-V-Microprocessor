`timescale 1ns / 1ps

`include "IF.v"
`include "ID.v"
`include "EX.v"
`include "MEM.v"
`include "control_path.v"


// TODO: Seperate data path logic to its own module
module top(
    clk,
    res
);
    input clk, res;

    // Control Wires
    wire [1:0] ALUOp;
    wire ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg;


    // PC    = 63:32
    // Instr = 31:0
    reg [63:0]  IF_ID_REG;
    

    // Write reg   = 132:128;
    // PC          = 127:96;
    // Read data 1 = 95:64;
    // Read data 2 = 63:32;
    // Imm32       = 31: 0;
    reg [132:0] ID_EX_REG;
    reg [31: 0] ID_EX_INSTR;


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
    

    // Write reg  = 36:34;
    // Write data = 31: 0;
    wire [36:0] WB_stage;
    assign WB_stage[31:0]  = MemToReg ? MEM_WB_REG[63:32] : MEM_WB_REG[31:0]; 
    assign WB_stage[36:32] = MEM_WB_REG[68:64];



    // Control Path
    ///////////////////////////////////////////////////////////

    wire [7:0] ctl_signals;
    ControlPath control(
        .clk(clk),
        .instr(IF_ID_REG[31:0]),
        .ctl_signals(ctl_signals)
    );
    
    // { ALUOp[1:0], ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg }; 
    reg [7:0] ID_EX_CTL;
    
    // { Branch, MemRead, MemWrite, RegWrite, MemToReg }; 
    reg [4:0] EX_MEM_CTL;
    
    // { RegWrite, MemToReg }; 
    reg [1:0] MEM_WB_CTL;

    always @(posedge clk or posedge res) begin
        if (res) begin
            ID_EX_CTL  <= 8'b0;
            EX_MEM_CTL <= 5'b0;
            MEM_WB_CTL <= 2'b0;
        end
        else begin 
            ID_EX_CTL  <= ctl_signals;
            EX_MEM_CTL <= ID_EX_CTL[4:0];
            MEM_WB_CTL <= EX_MEM_CTL[1:0];
        end
    end

    assign ALUOp    = ID_EX_CTL[7:6];
    assign ALUSrc   = ID_EX_CTL[5];

    assign Branch   = EX_MEM_CTL[4];
    assign MemRead  = EX_MEM_CTL[3];
    assign MemWrite = EX_MEM_CTL[2];

    assign RegWrite = MEM_WB_CTL[1];
    assign MemToReg = MEM_WB_CTL[0];

    // ALU Control unit
    reg [3:0] ALUControl;
    reg [6:0] funct7;
    always @(posedge clk or ALUOp or ID_EX_INSTR[14:12] or ID_EX_INSTR[31:25]) begin

        // TODO: Extend logic to check funct3 as well for more complex instr
        case(ID_EX_INSTR[6:0])
            7'b0010011: funct7 <= 7'b0;

            default: funct7 <= ID_EX_INSTR[31:25];
        endcase

        casex ({ ALUOp, ID_EX_INSTR[14:12], funct7 })
            12'b00_xxx_xxxxxxx: ALUControl <= 4'b0010;
            12'b01_xxx_xxxxxxx: ALUControl <= 4'b0110;
            12'b10_000_0000000: ALUControl <= 4'b0010;
            12'b10_000_0100000: ALUControl <= 4'b0110;
            12'b10_111_0100000: ALUControl <= 4'b0000;
            12'b10_110_0100000: ALUControl <= 4'b0001;
            default: ALUControl <= 4'b1111; // Cause ERROR
        endcase
    end

    ///////////////////////////////////////////////////////////

    wire PCSrc;
    wire Zero;
    assign Zero = EX_MEM_REG[96];
    assign PCSrc = Zero & Branch;

    wire [63:0] IF_out;
    IF if_stage(
        .clk(clk),
        .res(res),
        .PCSrc(PCSrc),
        .PCJumpAddr(EX_MEM_REG[95:64]),
        .dout(IF_out)
    );

   
    wire [100:0] ID_out;
    ID id_stage(
        .res(res),
        .input_instr(IF_ID_REG[31:0]),
        .write_dest(WB_stage[36:32]),
        .write_data(WB_stage[31:0]),
        .dout(ID_out),
        .RegWrite(RegWrite)
    );


    wire [101:0] EX_out;
    EX ex_stage(
        .clk(clk),
        .res(res),
        .din(ID_EX_REG),
        .dout(EX_out),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl)
    );


    wire [68:0] MEM_out;
    MEM mem_stage(
        .din(EX_MEM_REG),
        .dout(MEM_out),
        .MemWrite(MemWrite),
        .MemRead(MemRead)
    );
    
    
    always @(posedge clk or posedge res) begin
        if (res) begin
            IF_ID_REG  <=  64'b0;
            ID_EX_REG  <= 133'b0;
            EX_MEM_REG <= 102'b0;
            MEM_WB_REG <=  69'b0;

        end
        // TODO: Unhardcode the values of these pins for all regsiters asap
        else begin
            // IF/ID
            IF_ID_REG <= IF_out;

            // ID/EX
            ID_EX_REG[95:0]    <= ID_out[95:0];
            //PC
            ID_EX_REG[127:96]  <= IF_ID_REG[63:32];
            // Write reg
            ID_EX_REG[132:128] <= ID_out[100:96];

            ID_EX_INSTR <= IF_ID_REG[31:0];

            // EX/MEM
            EX_MEM_REG <= EX_out;

            // MEM/WB
            MEM_WB_REG <= MEM_out;
            
        end
    end

endmodule
