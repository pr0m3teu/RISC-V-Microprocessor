module ImmGen(
   instruction,
   imm32
); 
   input [31:0] instruction; 
   output reg [31:0] imm32;


   always @(instruction) begin
       case (instruction[6:0])
           7'b0000011,
           7'b0010011,
           7'b1100111,
           7'b1110011: imm32 = { {20{instruction[31]}}, instruction[31:20] }; // I-Type
           7'b0100011: imm32 = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] }; // S-Type
           7'b1100011: imm32 = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8] }; // B-Type
           default: imm32 = 32'h0000_0000;
       endcase
   end

endmodule
