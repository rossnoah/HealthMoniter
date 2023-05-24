module add3 (
 input logic [3:0] a,
 output logic [3:0] y
);

assign y = (a > 4) ? a + 3 : a;


// add your code here!
endmodule // add3


