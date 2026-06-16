`timescale 1ns / 1ps

`include "top.v"

module tb();

    reg clk, res;

    top DUT(clk, res);
    
      task dump_regs;
        begin
            $display("[x0 ]: %0d", DUT.id_stage.reg_file.regs[0]);
            $display("[x1 ]: %0d", DUT.id_stage.reg_file.regs[1]);
            $display("[x2 ]: %0d", DUT.id_stage.reg_file.regs[2]);
            $display("[x3 ]: %0d", DUT.id_stage.reg_file.regs[3]);
            $display("[x4 ]: %0d", DUT.id_stage.reg_file.regs[4]);
            $display("[x5 ]: %0d", DUT.id_stage.reg_file.regs[5]);
            $display("[x6 ]: %0d", DUT.id_stage.reg_file.regs[6]);
            $display("[x7 ]: %0d", DUT.id_stage.reg_file.regs[7]);
            $display("[x8 ]: %0d", DUT.id_stage.reg_file.regs[8]);
            $display("[x9 ]: %0d", DUT.id_stage.reg_file.regs[9]);
            $display("[x10]: %0d", DUT.id_stage.reg_file.regs[10]);
            $display("[x11]: %0d", DUT.id_stage.reg_file.regs[11]);
            $display("[x12]: %0d", DUT.id_stage.reg_file.regs[12]);
            $display("[x13]: %0d", DUT.id_stage.reg_file.regs[13]);
            $display("[x14]: %0d", DUT.id_stage.reg_file.regs[14]);
            $display("[x15]: %0d", DUT.id_stage.reg_file.regs[15]);
            $display("[x16]: %0d", DUT.id_stage.reg_file.regs[16]);
            $display("[x17]: %0d", DUT.id_stage.reg_file.regs[17]);
            $display("[x18]: %0d", DUT.id_stage.reg_file.regs[18]);
            $display("[x19]: %0d", DUT.id_stage.reg_file.regs[19]);
            $display("[x20]: %0d", DUT.id_stage.reg_file.regs[20]);
            $display("[x21]: %0d", DUT.id_stage.reg_file.regs[21]);
            $display("[x22]: %0d", DUT.id_stage.reg_file.regs[22]);
            $display("[x23]: %0d", DUT.id_stage.reg_file.regs[23]);
            $display("[x24]: %0d", DUT.id_stage.reg_file.regs[24]);
            $display("[x25]: %0d", DUT.id_stage.reg_file.regs[25]);
            $display("[x26]: %0d", DUT.id_stage.reg_file.regs[26]);
            $display("[x27]: %0d", DUT.id_stage.reg_file.regs[27]);
            $display("[x28]: %0d", DUT.id_stage.reg_file.regs[28]);
            $display("[x29]: %0d", DUT.id_stage.reg_file.regs[29]);
            $display("[x30]: %0d", DUT.id_stage.reg_file.regs[30]);
            $display("[x31]: %0d", DUT.id_stage.reg_file.regs[31]);
        end
    endtask 

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        clk = 1;
        res = 1;
        #11 res = 0;
        #500 dump_regs;
        #1 $finish;
    end

    always #5 clk = ~clk;
endmodule
