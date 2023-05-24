module  sevenseg_hex(input logic [5:0] data,
 output logic [6:0] segs_n,
 output logic dp_n);
 logic [6:0] segs;
 logic [3:0] temp = data[3:0];
 always_comb
 begin
 case (temp)
    4'd0: segs = 7'b111_1110;
    4'd1: segs = 7'b011_0000;
    4'd2: segs = 7'b110_1101;
    4'd3: segs = 7'b111_1001;
    4'd4: segs = 7'b011_0011;
    4'd5: segs = 7'b101_1011;
    4'd6: segs = 7'b101_1111;
    4'd7: segs = 7'b111_0000;
    4'd8: segs = 7'b111_1111;
    4'd9: segs = 7'b111_0011;
    4'd10: segs = 7'b111_0111;
    4'd11: segs = 7'b001_1111;
    4'd12: segs = 7'b000_1101;
    4'd13: segs = 7'b011_1101;
    4'd14: segs = 7'b100_1111;
    4'd15: segs = 7'b100_0111;
 default: segs = 7'b000_0000;
 endcase

 
 if(data[5]==1) begin
 segs=7'b000_0000;
 end
// assign segs = (data[5]? 7'b000_0000);
 

 segs_n = ~segs;
 end
 assign dp_n = (data[4]&&!data[5]?0:1);
 

 
endmodule