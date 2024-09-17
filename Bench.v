`timescale 1ns / 1ps  // Set timescale to 1 ns with 1 ps precision

module testbench_50MHz;

// Declare the clock signal
reg clk;

// Initialize and generate the clock signal
initial begin
    clk = 0;  // Start with the clock low
    forever #10 clk = ~clk;  // Toggle the clock every 10 ns
end


reg [31:0] inp;
reg [31:0] outp;

	CORDIC_Top dut (
       .clk(clk),
		 .target(inp),
		 .cos_x(outp)
	);



endmodule
