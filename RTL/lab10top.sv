module lab10top(
input clk, enter, start, rst, switch,
input analog_pos_in,       // pulse sensor positive input
input analog_neg_in,      // pulse sensor negative input
output logic [15:0] led,  // display digitized pulse sensor value
output logic pulse,        // display pulse as red LED
output r_out,g_out,b_out,
output [6:0]segs_n,
output [7:0]an_n,
output dp_n);




logic sclk;


clkdiv #(.DIVFREQ(1000)) U_DIV (.clk, .reset(0), .sclk);




logic t_r;
logic t_g;
logic t_b;
logic [6:0]t_segs_n;
logic [7:0]t_an_n;
logic t_dp_n;




logic p_pulse;
logic [15:0] p_led;
logic [6:0]p_segs_n;
logic [7:0]p_an_n;
logic p_dp_n;


assign pulse = !switch? p_pulse: 0;
assign led = !switch? p_led: 0;






assign r_out = switch ? t_r : 0;
assign g_out = switch ? t_g : 0;
assign b_out = switch ? t_b : 0;
assign segs_n = switch ? t_segs_n : p_segs_n;
assign an_n = switch ? t_an_n : p_an_n;
assign dp_n = switch ? t_dp_n : p_dp_n;












reactiontime(.clk(sclk), .enter(enter), .start(start), .rst(rst||!switch), .r_out(t_r), .g_out(t_g), .b_out(t_b), .segs_n(t_segs_n), .an_n(t_an_n), .dp_n(t_dp_n));


heartrate(.clk,.sclk,.rst, .analog_pos_in(analog_pos_in), .analog_neg_in(analog_neg_in), .pulse(p_pulse), .led(p_led), .segs_n(p_segs_n), .an_n(p_an_n), .dp_n(p_dp_n));


  
endmodule



