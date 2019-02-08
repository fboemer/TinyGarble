`timescale 1ns / 1ps
module relu
#(
	parameter N=32 // Bit-width of inputs to sum
)
(
	clk,
	rst,
	g_input,
	e_input, // learns the output
	o
);

	input clk, rst;
	input[2*N-1:0] g_input; // 2 N-bit numbers; [r_1, r_2]
	input[N-1:0] e_input;   // N-bit number [x-r_1]
	output [N-1:0] o;       // Relu(x) - r_2

	wire [N-1:0] x; // Holds reconstructed secret
	wire negative;
	wire [N-1:0] r1;
	wire [N-1:0] r2;

	assign r1 = g_input[2*N-1:N];
	assign r2 = g_input[N-1:0];

	wire overflow;

	// Reconstruct x (mod 2**N)
	ADD #( .N(N) ) OP1
	(
		.A(r1),
		.B(e_input),
		.CI(1'b0), // No carry in
		.S(x),     // Sum is stored in output
		.CO(overflow) // Carry-out put into MSB of x, since we need additional 2^31. TODO: cleanup
	);

	//assign x[N-1] = overflow;
  //assign o = x;

	wire [N-1:0] relu_x;

	// overflow => x > 0
	localparam MAX_INT =32'b00000000000000000000000000000000;
	always@(overflow) begin
		if (overflow == 1) begin
			relu_x = x;
		//	relu_x[N-1] = overflow;
		end
		else begin
			relu_x = 0; // TODO: assign 2^31 without segfault
		end
	end

	// relu_x is 2^31 smaller than the desired output.
	// However, we mask with r2, so the 2^31 is restored.
		// Mask with r2; store result in o
	ADD #( .N(N) ) OP3
	(
		.A(relu_x),
		.B(r2),
		.S(o),
		.CO()
	);

//	assign o = relu_x;

/*
	// This encodes 2^31. TODO: less obtuse representation
	localparam MAX_INT =32'b00000000000000000000000000000000;
	// Compare result against N/2
	COMP #( .N(N) ) OP2
	(
			.A(MAX_INT),
			.B(x),
			.O(negative)
	);

	wire [N-1:0] relu_x;

	always@(negative) begin
		if (negative == 1) begin
				relu_x <= 1'b1; //  => 0x80000001
				//relu_x <= MAX_INT; // TODO: solution with CC>1
		end
		else begin
			 //relu_x <= x;
			 relu_x <= 1'b0; // => 0x80000000
			 //relu_x <= MAX_INT; (For debugging value of MAX_INT)
		end
	end

	// Mask with r2; store result in o
	SUB #( .N(N) ) OP3
	(
		.A(relu_x),
		.B(r2),
		.S(o),
		.CO()
	);
*/

endmodule

