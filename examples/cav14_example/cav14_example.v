// Author: Aman Goel (amangoel@umich.edu), University of Michigan

`define W 400
`define WS1 399
`define CNT_MAX 400'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

// `define W 3
// `define WS1 2
// `define CNT_MAX `W'b111

module cav14_example(clk);

	input wire clk;
	reg [`WS1:0] X, Y;

	initial begin
		X = `W'd0;
		Y = `W'd0;
	end

	always @(posedge clk) begin
		X <= (Y > X) ? X : ((Y == X) || (X != `CNT_MAX))? (X + `W'd1) : Y;
		Y <= (Y == X) ? (Y + `W'd1) : ((Y > X) || (X != `CNT_MAX)) ? Y : X;
	end

	wire prop = !(Y > X);
	wire prop_neg = !prop;
	assert property ( prop );
endmodule















