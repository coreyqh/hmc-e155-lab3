TOP_MODULE = lab3_tb

VERILOG_SOURCES = lab3_tb.sv ../src/*

VERILATOR_FLAGS = --binary --exe --build -j 0 -Wall --trace-vcd --trace-depth 3

OBJ_DIR = obj_dir

wave:
	gtkwave trace.vcd

sim: verilate
	./obj_dir/V$(TOP_MODULE)

verilate: $(VERILOG_SOURCES)
	verilator $(VERILATOR_FLAGS) $(VERILOG_SOURCES) --top-module $(TOP_MODULE)

clean:
	rm -rf $(OBJ_DIR)
	rm -f trace.vcd