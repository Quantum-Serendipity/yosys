module rb(input wire clk, input wire en, input wire [3:0] d, output reg [3:0] o_ndiff = 4'b0000, output reg o_flag = 1'b0);
  always @(posedge clk) if (en) begin o_ndiff <= d + 4'd1; o_flag <= ^d; end
endmodule
module sav(input wire clk, input wire [7:0] d, output reg [7:0] q = 8'h00);
  always @(posedge clk) q <= {q[6:0], ^d};
endmodule
module core(input wire clk, input wire en, input wire [3:0] d, output wire [3:0] nd, output wire fl, output wire [7:0] sq);
  rb u_rb (.clk(clk), .en(en), .d(d), .o_ndiff(nd), .o_flag(fl));
  sav u_sav (.clk(clk), .d({d, d}), .q(sq));
endmodule
module top(input wire clk, input wire en, input wire [3:0] d, output wire [3:0] y, output wire z, output wire [7:0] w);
  wire [3:0] rb_ndiff; wire rb_flag; wire [7:0] a_sav;
  core u_core (.clk(clk), .en(en), .d(d), .nd(rb_ndiff), .fl(rb_flag), .sq(a_sav));
  assign y = rb_ndiff; assign z = rb_flag; assign w = a_sav;
endmodule
