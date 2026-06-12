all: tb.vcd
	rm tb && gtkwave tb.vcd 

tb: tb.v
	iverilog -o tb tb.v

tb.vcd: tb
	vvp tb
