`include "top.v"

module tb();

    reg clk, res;

    top DUT(clk, res);
    
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        clk = 1;
        res = 1;
        #3
        res = 0;

        #100 $finish;
    end

    always #5 clk = ~clk;
endmodule
