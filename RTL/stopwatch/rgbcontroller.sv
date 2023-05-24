module rgbcontroller (
   input[3:0] r, g, b,
   input clk, rst,
   output r_out, g_out, b_out);
logic [3:0] counter;
always_ff @(posedge clk) begin
counter <= counter + 4'd1;
end
assign r_out = (counter < r&&!rst) ? 1'b1 : 1'b0;
assign g_out = (counter < g&&!rst) ? 1'b1 : 1'b0;
assign b_out = (counter < b&&!rst) ? 1'b1 : 1'b0;
endmodule
