`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 02:38:02 PM
// Design Name: 
// Module Name: thermometer_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module thermometer_decode(
    input logic [3:0] d,
    output logic [15:0] y
    );
    
    always_comb
        case (d)
            4'd0: y = 16'b0000000000000001;
            4'd1: y = 16'b0000000000000011;
            4'd2: y = 16'b0000000000000111;
            4'd3: y = 16'b0000000000000111;
            4'd4: y = 16'b0000000000011111;
            4'd5: y = 16'b0000000000111111;
            4'd6: y = 16'b0000000001111111;
            4'd7: y = 16'b0000000011111111;
            4'd8: y = 16'b0000000111111111;
            4'd9: y = 16'b0000001111111111;
            4'd10: y = 16'b0000011111111111;
            4'd11: y = 16'b0000111111111111;
            4'd12: y = 16'b0001111111111111;
            4'd13: y = 16'b0011111111111111;
            4'd14: y = 16'b0111111111111111;
            4'd15: y = 16'b1111111111111111;
        endcase
        
endmodule
