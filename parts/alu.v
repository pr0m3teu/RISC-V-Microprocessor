module ALU(
    src1,
    src2,
    ALUControl,
    result,
    zero
);

    // Make this width variable
    input [31:0] src1;
    input [31:0] src2;
    input [3:0] ALUControl;

    output reg [31:0] result;
    output reg zero;


    always @(*) begin
        case(ALUControl) 
            4'b0010: result = src1 + src2;
            4'b0110: result = src1 - src2;
            4'b0000: result = src1 & src2;
            4'b0001: result = src1 | src2;

            default: result = 32'b0;
        endcase
        zero = (result == 0) ? 1 : 0;
     end
    
endmodule
