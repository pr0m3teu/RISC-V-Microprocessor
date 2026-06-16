module HazardDetectionUnit(
    input       ID_EX_MemRead,
    input [4:0] ID_EX_Rd,
    input [4:0] IF_ID_Rs1,
    input [4:0] IF_ID_Rs2,
    output reg  PCWrite,
    output reg  IF_ID_Write,
    output reg  Stall
);

    always @(*) begin
        // Load-use hazard condition
        if (ID_EX_MemRead && ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2))) begin
            PCWrite     = 1'b0; // Freeze PC
            IF_ID_Write = 1'b0; // Freeze IF/ID register
            Stall       = 1'b1; // Insert bubble into ID/EX
        end else begin
            PCWrite     = 1'b1;
            IF_ID_Write = 1'b1;
            Stall       = 1'b0;
        end
    end

endmodule
