`timescale 1ns / 1ps
module relu
#(
	parameter N=8, // Bit-width of inputs to sum
)
(
	clk,
	rst,
	g_input, // =: A
	e_input, // =: B
	o
);

	input clk, rst;
	input  [N-1:0] g_input; // Input posts are read at every clock cycle?!
	input  [N-1:0] e_input;
	output [N-1:0] o;

	wire [N-1:0] x; // Holds reconstructed secret


	// Call A+B
	// Creates ADD module with parameter N
	ADD #( .N(N) ) OP1
	(
		.A(g_input), // Calls g_input + e_input
		.B(e_input),
		.CI(1'b0), // No carry in
		.S(x),     // Sum is stored in output
		.CO()			 // Carry-out discardded
	);





	assign o = x;





	// Check if output is bigger than N

endmodule

