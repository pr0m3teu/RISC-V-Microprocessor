module ControlPath(
    clk,
    instr,
    ctl_signals
);

    input clk;
    input [31:0] instr;

    wire [6:0] opcode;
    assign opcode = instr[6:0];
    
    // { ALUOp[1:0], ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg }; 
 
    output reg [7:0] ctl_signals;

    always @(*) begin
        casex(opcode) 
            // R-Type
            7'b0110011: ctl_signals <= 8'b10_0_0_0_0_1_0;
            // I-Type
            7'b0010011: ctl_signals <= 8'b10_1_0_0_0_1_0;
            // lw
            7'b0000011: ctl_signals <= 8'b00_1_0_1_0_1_1;
            // sw
            7'b0100011: ctl_signals <= 8'b00_1_0_0_1_0_0;
            // beq
            7'b1100011: ctl_signals <= 8'b01_0_1_0_0_0_0;
            
            default: ctl_signals <= 8'b0;
        endcase
    end

endmodule
