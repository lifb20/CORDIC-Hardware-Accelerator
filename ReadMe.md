# CORDIC Accelerator for Intel DE10-Max FPGA

This repository contains the files required to implement an accelerator for the calculation of Cosine on an FPGA.
The accelerator was designed using Verilog HDL on Intel's Quartus Prime. Prior to the design's implementation, it was tested
on MATLAB to determine the optimal word bit-length and number of iterations to guarantee a certain error range.
