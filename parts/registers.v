// Register file module 

module registers(
   clk,
   res,
   rreg1,
   rreg2,
   wreg,
   wdata,
   out_reg1,
   out_reg2,
   RegWrite
);

    parameter WIDTH = 32;
    parameter REG_COUNT = 32;

    input clk, res;
    input [4:0] rreg1;
    input [4:0] rreg2; // TODO: unhardcode the sizes
    input [4:0] wreg;

    input RegWrite;

    input [WIDTH-1:0] wdata;
    
    output wire [WIDTH-1:0] out_reg1;
    output wire [WIDTH-1:0] out_reg2; 

    reg [WIDTH-1:0] regs [0:REG_COUNT-1];


    assign out_reg1 = regs[rreg1];
    assign out_reg2 = regs[rreg2];

    integer i;
    always @(posedge clk or posedge res) begin
        if (res) begin
            for (i = 0; i < REG_COUNT; i = i + 1)
                regs[i] <= 32'b0;

        end else begin
            if (RegWrite && wreg != 5'b0)
                regs[wreg] <= wdata;
            regs[0] <= 32'b0;
        end
    end

endmodule
