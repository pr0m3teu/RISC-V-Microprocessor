`include "./parts/memory.v"

module IF(
    clk,
    res,
    PCSrc,
    PCJumpAddr,
    dout
);
    input clk, res;

    input PCSrc;
    input [31:0] PCJumpAddr;

     // PC    = 63:32
     // Instr = 31:0
     output reg[63:0] dout;

    reg[31:0] PC;
    wire[31:0] instruction;
    
    // For instruction memory this should always be deasserted
    wire instr_mem_write;
    assign instr_mem_write = 0;

    // For instruction memory this should always be asserted
    wire instr_mem_read;
    assign instr_mem_read = 1;

    wire [31:0] data_in;
    assign data_in = 32'b0;
    memory instr_mem(
        .addr_in(PC),
        .data_in(data_in),
        .data_out(instruction),
        .MemWrite(instr_mem_write),
        .MemRead(instr_mem_read)
    );

    initial begin
        instr_mem.mem[0] <= 8'hFF;
        instr_mem.mem[1] <= 8'hEE;
        instr_mem.mem[2] <= 8'hEC;
        instr_mem.mem[3] <= 8'hEC;
    end
    

    always @(posedge clk or posedge res) begin
        if (res == 1)
            PC <= 0;
        else begin
            PC <= PCSrc? PCJumpAddr : PC + 4;
        end
    end

    // TODO: Check if this is correct?
    always @(PC or instruction) begin
        dout[63:32] <= PC;
        dout[31:0]  <= instruction;
    end
    

endmodule
