module heartrate (input clk, sclk, rst,
input analog_pos_in,       // pulse sensor positive input
input analog_neg_in,      // pulse sensor negative input
output logic [15:0] led,  // display digitized pulse sensor value
output logic pulse,
output [6:0]segs_n,
output [7:0]an_n,
output dp_n      // display pulse as red LED
);

logic [7:0] pulse_count;
logic [15:0] clk_count;
logic raw_pulse;


logic save1;
logic save2;
logic save3;


logic [7:0] average1;
logic [7:0] average2;
logic [7:0] average3;

logic pulse_db;
logic[15:0] average_total;
assign average_total = (average1 + average2 + average3)*4;



logic single;
// assign average_total = 8'd95;
//    single_pulser(.clk(clk), .din(raw_pulse), .d_pulse(single_pulse));
    
   debounce (.clk(sclk), .pb(raw_pulse),.pb_debounced(pulse_db));
   single_pulser(.clk(sclk), .din(pulse_db), .d_pulse(single));
    
  
    
    
dregre #(.W(8)) averagesaver1(.clk(clk), .rst(rst), .enb(save1), .d(pulse_count), .q(average1));
dregre #(.W(8)) averagesaver2(.clk(clk), .rst(rst), .enb(save2), .d(average1), .q(average2));
dregre #(.W(8)) averagesaver3(.clk(clk), .rst(rst), .enb(save3), .d(average2), .q(average3));



assign pulse = single;

always_ff @(posedge sclk, posedge rst) begin
    clk_count ++;
if(rst) begin
    clk_count <= 0;
       save1 <= 0;
       save2 <= 0;
       save3 <= 0;
       pulse_count <= 0;
end
else if(clk_count == 5000) begin
   save1 <= 0;
   save2 <= 0;
   save3 <= 1;

end

else if(clk_count == 5001) begin
   save1 <= 0;
   save2 <= 1;
   save3 <= 0;

end 
else if(clk_count == 5002) begin
   save1 <= 1;
   save2 <= 0;
   save3 <= 0;

end
//else if(clk_count == 5004) begin
//   save1 <= 0;
//   save2 <= 0;
//   save3 <= 0;

//end
else if(clk_count == 5003) begin
   save1 <= 0;
   save2 <= 0;
   save3 <= 0;   
   pulse_count <= 0;
   clk_count <=0;
   
end
else begin 
       save1 <= 0;
       save2 <= 0;
       save3 <= 0;
        
       if(single) begin
       pulse_count++;
       end
end
end

pulse_sensor U_PS(.clk, .rst, .analog_pos_in, .analog_neg_in, .led, .pulse(raw_pulse));

// dregre #(.W(13)) reg1(.clk(clk), .rst(rst), .enb(), .d(random_gen), .q(random));
logic [5:0] d0, d1, d2, d3;; //bcd digits for each digit
logic [5:0] d4, d5, d6, d7; //bcd digits for each digit

assign d3[5]  = 1'b1;
assign d4[5]  = 1'b1;
assign d5[5]  = 1'b1;
assign d6[5]  = 1'b1;
assign d7[5]  = 1'b1;

binary_to_bcd(.b(average_total[7:0]),.hundreds(d2[3:0]),.tens(d1[3:0]),.ones(d0[3:0]));
sevenseg_control control(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.d4(d4),.d5(d5),.d6(d6),.d7(d7),.clk(sclk),.rst(0),.segs_n(segs_n),.an_n(an_n),.dp_n(dp_n));

  
endmodule



