

module mux8 #()
    (input logic [5:0]  d0, d1, d2, d3, d4, d5, d6, d7,
     input logic [2:0]    sel,
     output logic [5:0] y );

always_comb
case (sel)
3'd0 : y = d0;
3'd1 : y = d1;
3'd2 : y = d2;
3'd3 : y = d3;
3'd4 : y = d4;
3'd5 : y = d5;
3'd6 : y = d6;
3'd7 : y = d7;


default : y = 0;
endcase

endmodule