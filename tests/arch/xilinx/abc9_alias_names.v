module blk(input wire clk_in, input wire d, input wire a, input wire b,
           input wire [3:0] x, input wire [3:0] y,
           input wire we, input wire [3:0] wa, input wire [3:0] ra, input wire [3:0] wd,
           output wire o_sys_clk, output wire q, output wire o_and, output wire o_s,
           output wire [3:0] o_sum, output wire [1:0] o_k,
           output reg [3:0] o_kq = 4'b0000, output wire [3:0] o_ks,
           output wire [3:0] o_rd, output reg [3:0] o_rq = 4'b0000,
           output wire [7:0] o_mix);
    wire sys_clk;
    BUFG u_bufg (.I(clk_in), .O(sys_clk));
    reg r = 1'b0;
    always @(posedge sys_clk) r <= d;
    assign q = r;
    assign o_sys_clk = sys_clk;
    wire andab = a & b;
    assign o_and = andab;
    reg s = 1'b0;
    always @(posedge sys_clk) s <= andab;
    assign o_s = s;
    wire [3:0] sum = x + y;
    reg [3:0] sumq = 4'b0000;
    always @(posedge sys_clk) sumq <= sum;
    assign o_sum = sumq;
    wire [1:0] kk = 2'b10;
    assign o_k = kk;
    (* keep *) wire [3:0] ks = x + wd;
    always @(posedge sys_clk) o_kq <= ks ^ {x[0], x[3:1]};
    assign o_ks = ks;
    reg [3:0] mem [0:15];
    always @(posedge sys_clk) if (we) mem[wa] <= wd;
    wire [3:0] rdat = mem[ra];
    assign o_rd = rdat;
    always @(posedge sys_clk) o_rq <= rdat;
    reg [3:0] lo = 4'b0000;
    always @(posedge sys_clk) lo <= x ^ wd;
    wire [3:0] hi = y + wd;
    wire [7:0] mixw = {hi, lo};
    assign o_mix = mixw;
endmodule

module top(input wire clk_i, input wire d, input wire a, input wire b,
           input wire [3:0] x, input wire [3:0] y,
           input wire we, input wire [3:0] wa, input wire [3:0] ra, input wire [3:0] wd,
           output wire q, output wire q2, output wire q3, output wire q4,
           output wire [3:0] q5, output wire [1:0] q6,
           output wire [3:0] q7, output wire [3:0] q8, output wire [3:0] q9, output wire [3:0] q10,
           output reg [7:0] q11 = 8'h00);
    wire ddr_sys_clk, and_out;
    wire [3:0] ram_out;
    wire [7:0] mix_out;
    blk u_ddr3 (.clk_in(clk_i), .d(d), .a(a), .b(b), .x(x), .y(y),
                .we(we), .wa(wa), .ra(ra), .wd(wd),
                .o_sys_clk(ddr_sys_clk), .q(q), .o_and(and_out), .o_s(q4),
                .o_sum(q5), .o_k(q6), .o_kq(q7), .o_ks(q8), .o_rd(ram_out), .o_rq(q10), .o_mix(mix_out));
    reg r2 = 1'b0, r3 = 1'b1;
    always @(posedge ddr_sys_clk) begin
        r2 <= ~d;
        r3 <= and_out;
    end
    assign q2 = r2;
    assign q3 = r3;
    assign q9 = ram_out;
    always @(posedge ddr_sys_clk) q11 <= mix_out ^ {mix_out[0], mix_out[7:1]};
endmodule
