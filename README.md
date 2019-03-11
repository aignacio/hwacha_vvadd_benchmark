# **Vector add example - benchmark for Hwacha evaluation**
---------------------

The code inside this repository it's just a copy modified of the RISC-V benchmark used for vector extension in hwacha. Benchmark used in this example it's multiple vector add computation tweaked to display internal variables through the process of computation with the vector processor.

- For reference the original file should be at: [esp-tests/vvadd](https://github.com/ucb-bar/esp-tests/tree/master/benchmarks/vec-vvadd) 

### **Requirements:**

To compile and use it, you'll need the custom RISC-V toolchain that can be able to support the custom arch for HWACHA (-march=rv64gcxhwacha) and also the spike simulator ([esp-isa](https://github.com/ucb-bar/esp-isa-sim)). Both can be build according to the rules present in the [hwacha template repository](https://github.com/ucb-bar/hwacha-template). Please notice that this example will run spike in the end of the makefile and save the output into a file with the same name as the compiled but with the suffix .out, so if you do not have it, it'll probably generate an error in the end.

**Credits:** Hwacha team + me =)