//`include "parts/memory.v" It's already included in IF and
// it sees it twice, causing a compilation error

module MEM(
    din,
    dout,
    MemRead,
    MemWrite
);

    // Write reg   = 101:97;
    // Zero        = 96;
    // New PC      = 95:64;
    // ALU result  = 63:32;
    // Read data 2 = 31: 0;
    input [101:0]  din;

    // Write reg  = 68:64;
    // Read Data  = 63:32;
    // ALU Result = 31:0;
    output [68:0] dout;

    input MemWrite, MemRead;

    memory data_mem(
       .addr_in(din[63:32]),
       .data_in(din[31:0]),
       .data_out(dout[63:32]),
       .MemWrite(MemWrite),
       .MemRead(MemRead)
    );

    assign dout[63:32] = din[63:32];
    assign dout[68:64] = din[101:97];

endmodule
