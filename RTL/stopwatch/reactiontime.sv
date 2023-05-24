module reactiontime(
input clk, enter, start, rst,
output r_out,g_out,b_out,
output [6:0]segs_n,
output [7:0]an_n,
output dp_n);


logic [5:0] d0, d1, d2, d3;; //bcd digits for each digit
logic [5:0] d4, d5, d6, d7; //bcd digits for each digit


 sevenseg_control control(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.d4(d4),.d5(d5),.d6(d6),.d7(d7),.clk(clk),.rst(0),.segs_n(segs_n),.an_n(an_n),.dp_n(dp_n));
//sevenseg_control control(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.d4(d4),.d5(random[0]),.d6(random[1]),.d7(random[2]),.clk(clk),.rst(0),.segs_n(segs_n),.an_n(an_n),.dp_n(dp_n));


logic [3:0] r,g,b;
logic rst_counters;
logic run_clock;
logic show_clock;


logic start_db, start_pulse;


   debounce (.clk(clk), .pb(start),.pb_debounced(start_db));
   single_pulser(.clk(clk), .din(start_db), .d_pulse(start_pulse));






assign d4 = 6'b100000;
assign d5 = 6'b100000;
assign d6 = 6'b100000;
assign d7 = 6'b100000;


assign d0[5] = !show_clock;
assign d1[5] = !show_clock;
assign d2[5] = !show_clock;
assign d3[5] = !show_clock;


assign d3[4]=1;


logic carry0, carry1, carry2;


logic save_random;
logic [2:0] random_gen, random;


random(.clk(clk),.random(random_gen));
dregre #(.W(3)) random_reg(.clk(clk), .rst(rst), .enb(!save_random), .d(random_gen), .q(random));


counter_bcd count0(.clk(clk), .rst(rst||rst_counters), .enb(run_clock), .q(d0[3:0]), .carry(carry0));
counter_bcd count1(.clk(clk), .rst(rst||rst_counters), .enb(carry0), .q(d1[3:0]), .carry(carry1));
counter_bcd count2(.clk(clk), .rst(rst||rst_counters), .enb(carry1), .q(d2[3:0]), .carry(carry2));
counter_bcd count3(.clk(clk), .rst(rst||rst_counters), .enb(carry2), .q(d3[3:0]), .carry(carry3));


rgbcontroller(.clk(clk),.rst(0),.r(r),.g(g),.b(b),.r_out,.g_out,.b_out);
typedef enum logic [2:0]{
IDLE = 3'b0, COUNTUP = 3'd1,READY = 3'd2,
DISPLAY = 3'd3, EARLY = 3'd4, LATE = 3'd5


} states_t;
states_t state, next;


always_ff @(posedge clk)
 if(rst) state<= IDLE;
 else state = next;




always_comb begin
r=0;
b=0;
g=0;
show_clock=0;
rst_counters=0;
run_clock=0;
save_random=0;
next = IDLE;




case (state)
 IDLE: begin
     r=0;
     b=0;
     g=1;
     rst_counters=0;
     run_clock=0;
     save_random=0;
     show_clock=0;
 if(rst) next = IDLE;
 if(start_pulse)begin
     run_clock = 1;
     rst_counters = 1;
     save_random = 1;
     show_clock=0;
   next = COUNTUP;


 end
 else next = IDLE;


 end
 COUNTUP: begin
     save_random = 1;
     run_clock=1;
     rst_counters=0;
     r=0;
     g=0;
     b=0;
     show_clock=0;


     if(rst) next = IDLE;
     else if(d3[3:0]>=random+1) begin
//     else if(d3[3:0]>=4'd5) begin
         rst_counters = 1;
         next = READY;
     end
     else if (enter) begin
         rst_counters = 1;
         next = EARLY;
     end
     else next = COUNTUP;
 end


 READY: begin
 rst_counters=0;
 run_clock=1;
 r=1;
 g=1;
 b=1;
 show_clock=0;
 if(rst) next = IDLE;
 else if(enter) next = DISPLAY;
 else if(carry3)begin
     next=LATE;
     rst_counters=1;
 end
 else next = READY;
 end


 DISPLAY: begin
     r=0;
     b=0;
     g=0;
     run_clock=0;
     rst_counters=0;
     show_clock=1;


 if(rst) next = IDLE;
 else if(start_pulse) begin
   rst_counters=1;
   next = IDLE;
 end
 else next = DISPLAY;
 end




 EARLY: begin
     r=1;
     b=0;
     g=0;
     show_clock=0;
     run_clock=1;
     rst_counters=0;
 if(rst) next = IDLE;
 else if(d3[3:0]>=5) next = IDLE;


 else next = EARLY;


 end
 LATE: begin
     r=1;
     b=0;
     g=1;
     show_clock=0;
     run_clock=1;
     rst_counters=0;
 if(rst) next = IDLE;
 else if(d3[3:0]>=5) next = IDLE;
 else next = LATE;


 end


endcase
end
endmodule
