module ALU(
    clk,
    res,
    src1,
    src2,
    ALUControl,
    result,
    zero
);

    input clk, res;

    // Make this width variable
    input [31:0] src1;
    input [31:0] src2;
    input [3:0] ALUControl;

    output reg [31:0] result;
    output reg zero;

    always@(posedge res) begin
        zero = 1'b0;
        result = 32'b0;
    end
    
    always@(posedge clk or ALUControl) begin
        case(ALUControl) 
            4'b0010: result = src1 + src2;
            4'b0110: result = src1 - src2;
            4'b0000: result = src1 & src2;
            4'b0001: result = src1 | src2;

            default: result = 32'b0;
        endcase

        zero = result ? 0 : 1;
    end
    
endmodule
