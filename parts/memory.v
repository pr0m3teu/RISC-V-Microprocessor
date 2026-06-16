module memory(addr_in, data_in, data_out, MemWrite, MemRead);
    parameter WIDTH = 8;
    parameter ADDR_WIDTH = 10;
    parameter WORD = 32;

    input MemWrite;
    input MemRead; 
    input [WORD-1:0] addr_in;
    input wire [WORD-1:0] data_in;

    output reg [WORD-1:0] data_out;

    reg [WIDTH-1:0] mem [0:(1 << ADDR_WIDTH) - 1];

    // synchronous writes
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr_in]     <= data_in[7:0];
            mem[addr_in + 1] <= data_in[15:8];
            mem[addr_in + 2] <= data_in[23:16];
            mem[addr_in + 3] <= data_in[31:24];
        end
    end
    

    // asynchronous reads
    always @(*) begin
        if (MemRead) begin
            data_out[7:0]   <= mem[addr_in];
            data_out[15:8]  <= mem[addr_in + 1];
            data_out[23:16] <= mem[addr_in + 2];
            data_out[31:24] <= mem[addr_in + 3];
        end
    end

endmodule
