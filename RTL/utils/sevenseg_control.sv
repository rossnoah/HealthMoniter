module sevenseg_control(
    input clk,
    input rst,
    input [5:0] d0,d1,d2,d3,d4,d5,d6,d7,
    output [7:0] an_n,
    output [6:0] segs_n,
    output dp_n);

    logic [5:0] y;
    logic [2:0] sel;
    logic [2:0] q;



    count_3bit count(.clk(clk),.rst(rst),.q(q));

    assign sel = q;

    mux8 mux(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.d4(d4),.d5(d5),.d6(d6),.d7(d7),.sel(sel),.y(y));


    dec_3_8 dec(.a(q),.y_n(an_n));

    sevenseg_hex hex(.data(y),.segs_n(segs_n),.dp_n(dp_n));





endmodule