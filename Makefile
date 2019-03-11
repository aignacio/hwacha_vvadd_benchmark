#=======================================================================
# UCB VLSI FLOW: Makefile for riscv-bmarks
#-----------------------------------------------------------------------
# Yunsup Lee (yunsup@cs.berkeley.edu)
#

XLEN ?= 64
SHELL := /bin/bash
default: all

src_dir = .
src_folder = src
instname = riscv-bmarks
instbasedir = $(UCB_VLSI_HOME)/install

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

bmarks = \
	vvadd_tweaked

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -DMULTITHREAD=$(CORES) -mcmodel=medany -static -std=gnu99 -ffast-math -fno-common -fno-builtin-printf -march=rv64gc -Wa,-march=rv64gcxhwacha
RISCV_LINK ?= $(RISCV_GCC) -T $(src_dir)/common/test.ld $(incs)
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T $(src_dir)/common/test.ld
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.init --section=.data
RISCV_SIM ?= spike -p$(CORES) --isa=rv$(XLEN)gc --extension=hwacha

incs  +=  -I$(src_dir)/common $(addprefix -I$(src_dir)/, $(src_folder))
objs  :=

define compile_template
$(1).riscv: $(wildcard $(src_dir)/$(1)/*) $(wildcard $(src_dir)/common/*)
	$$(RISCV_GCC) $$(incs) $$(RISCV_GCC_OPTS) -o $$@ $(wildcard $(src_dir)/$(src_folder)/*.c) $(wildcard $(src_dir)/common/*.c) $(wildcard $(src_dir)/$(src_folder)/*.S) $(wildcard $(src_dir)/common/*.S) $$(RISCV_LINK_OPTS)
endef

$(foreach bmark,$(bmarks),$(eval $(call compile_template,$(bmark))))

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

bmarks_riscv_bin  = $(addsuffix .riscv,  $(bmarks))
bmarks_riscv_dump = $(addsuffix .riscv.dump, $(bmarks))
bmarks_riscv_out  = $(addsuffix .riscv.out,  $(bmarks))

CORES ?= 1

$(bmarks_riscv_dump): %.riscv.dump: %.riscv
	$(RISCV_OBJDUMP) $< > $@

$(bmarks_riscv_out): %.riscv.out: %.riscv
	$(RISCV_SIM) $< > $@

riscv: $(bmarks_riscv_dump)
run: $(bmarks_riscv_out)

junk += $(bmarks_riscv_bin) $(bmarks_riscv_dump) $(bmarks_riscv_hex) $(bmarks_riscv_out)

#------------------------------------------------------------
# Default

all: riscv run
	@echo -ne "\n\n\n ========== DEBUG INFO =========="
	@echo -ne "\n\nIf you want to run independent the spike simulator, just type it \n \
				\r'spike -p1 --isa=rv64gc --extension=hwacha vvadd_tweaked.riscv' and  \n \
				\renable the debug mode with -d option"
	@echo -ne "\n\n...also, some shortcuts to use spike are:\n \
	           \runtil pc 0 PROGRAM_LINE - Run core 0 until this assembly command\n \
			   \rreg 0 X - Reads register X of the core \n \
			   \rr - it run continuously the program until it breaks of finishes \n \
			   \r see more info at https://github.com/riscv/riscv-isa-sim\n"
#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk)
