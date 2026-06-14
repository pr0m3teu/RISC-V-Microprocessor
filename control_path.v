module ControlPath(
    clk,
    instr,
    ctl_signals
);

    input clk;
    input [31:0] instr;

    
    // { ALUOp[1:0], ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg }; 
 
    output reg [7:0] ctl_signals;

    always @(posedge clk) begin
        casex(instr[6:0]) 
            // R-Type
            7'b0110011: ctl_signals <= 8'b10_0_0_0_0_1_0;
            // TODO: Add I-Type
            // lw
            7'b0000011: ctl_signals <= 8'b00_1_0_1_0_1_1;
            // sw
            7'b0100011: ctl_signals <= 8'b00_1_0_0_1_0_0;
            // beq
            7'b1100011: ctl_signals <= 8'b01_0_1_0_0_0_0;
            
            default: ctl_signals <= 8'b0;
        endcase
    end

endmodule;
