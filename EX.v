`include "parts/alu.v"


module EX(
    clk,
    res,
    din,
    dout,
    ALUSrc,
    ALUControl,
);

    input clk, res;

    input ALUSrc;
    input [3:0] ALUControl;


    // Write reg   = 132:128;
    // PC          = 127:96;
    // Read data 1 = 95:64;
    // Read data 2 = 63:32;
    // Imm32       = 31: 0;
    input [132:0] din;

    // Write reg   = 101:97;
    // Zero        = 96;
    // New PC      = 95:64;
    // ALU result  = 63:32;
    // Read data 2 = 31: 0;
    output reg [101:0] dout;

    
    wire [31:0] aluOpB;
    assign aluOpB = ALUSrc ? din[31:0] : din[63:32];

    wire [31:0] ALUResult;
    wire Zero;
    ALU alu(
        .clk(clk),
        .res(res),
        .src1(din[95:64]),
        .src2(aluOpB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .zero(Zero)
    );


    always @(posedge clk) begin 
        if (res) begin
            dout <= 98'b0;
        end
        else begin
            // TODO: Make sure these assignments are correct
            dout[101:97]<= din[132:128];
            dout[96]    <= Zero;
            dout[95:64] <= din[127:96] + din[31:0];
            dout[63:32] <= ALUResult;
            dout[31:0]  <= din[63:32];
        end
    end

endmodule
