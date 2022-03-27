//module adder_1bit
//(
//	input clk, n_rst, a, b, carry_in,
//	output sum, carry_out
//);
// 
//  logic sum_reg;
//  logic carry_out_reg;
//
//  assign sum = sum_reg;
//  assign carry_out = carry_out_reg;
//
//  always_ff @(posedge clk, negedge n_rst) begin
//    if(n_rst) begin
//      sum_reg <= (a ^ b) ^ carry_in;
//      carry_out_reg <= (a & b) | (a & carry_in) | (b & carry_in);
//    end
//    else begin
//      sum_reg = 0;
//      carry_out_reg = 0;
//    end
//  end
//endmodule
//
//module adder_nbit #(parameter BIT_WIDTH = 4) (adder_if.adder add_if);
//	logic [BIT_WIDTH:0] carrys;
//	assign carrys[0] = add_if.carry_in;
//
//	genvar i;
//	generate
//		for(i = 0; i < BIT_WIDTH; i = i + 1) begin
//			adder_1bit IX(.clk(add_if.clk), .n_rst(add_if.n_rst), .a(add_if.a[i]), .b(add_if.b[i]), .carry_in(carrys[i]), .sum(add_if.sum[i]), .carry_out(carrys[i+1]));
//		end
//	endgenerate
//	
//	assign add_if.overflow = carrys[BIT_WIDTH];
//endmodule

module adder_nbit #(parameter BIT_WIDTH = 4) (adder_if.adder add_if);
  always_ff @(posedge add_if.clk, negedge add_if.n_rst) begin
    if(add_if.n_rst) begin
      {add_if.overflow, add_if.sum} <= (add_if.a + add_if.b + add_if.carry_in);
    end
    else begin
      add_if.sum <= 0;
      add_if.overflow <= 0;
    end
  end
endmodule
