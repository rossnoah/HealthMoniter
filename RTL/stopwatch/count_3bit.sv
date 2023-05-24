module count_3bit ( 
  input logic clk, rst,
  output logic [2:0] q 
  );
   
   always_ff @(posedge clk)
     if (rst) q <= 3'd0;
     else q <= q + 3'd1;

endmodule // count