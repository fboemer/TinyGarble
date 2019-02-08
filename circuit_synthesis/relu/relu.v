`timescale 1ns / 1ps
module relu
#(
	parameter N=8 // Bit-width of inputs to sum
)
(
	clk,
	rst,
	g_input, // =: A
	e_input, // =: B; learns the output
	o
);

	input clk, rst;
	input[2*N-1:0] g_input; // 2 N-bit numbers; [r_1, r_2]
	input[N-1:0] e_input;   // N-bit number [x-r_1]
	output [N-1:0] o;

	wire [N-1:0] x; // Holds reconstructed secret
	wire overflow;
	wire [N-1:0] r1;
	wire [N-1:0] r2;

	assign r1 = g_input[2*N-1:N];
	assign r2 = g_input[N-1:0];

	// Reconstruct x
	ADD #( .N(N) ) OP1
	(
		.A(g_input[2*N-1:N]), //
		.B(e_input),
		.CI(1'b0), // No carry in
		.S(x),     // Sum is stored in output
		.CO()			 // Carry-out discardded
	);

	// Compare result against N/2
	/* localparam MAX_INT = 2**(N-1);
	COMP #( .N(N) ) OP2
	(
			.A(x),
			.B(MAX_INT),
			.O(overflow)
	); */

	assign o = x;




	// Check if output is bigger than N

endmodule

