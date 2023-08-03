# VIC-20 Games

This repository contains disassemblies of some popular VIC-20 games.

The .asm files were created using the da65 disassembler and together with the included 
Makefile are set up such that the games can be assembled using the ca65 assembler 
(the cc65 compiler suite can be found [here](https://cc65.github.io)). Make sure the 
ca65/ld65 executables are in your search path.

As is, the resulting binary code will be identical to the original cartridges. The default
memory location for all 8k and 4k binaries is $A000 (the default VIC-20 cartrige location).
Note that Donkey Kong is a 16k game and as such will produce an additional binary file in
the $2000-$3FFF range.

All the disassemblies are set up such that the code can be modified and/or re-located
to a different address space. All absolute jumps/loads/vectors are set up using labels
which will be adjusted automatically by the assembler.
