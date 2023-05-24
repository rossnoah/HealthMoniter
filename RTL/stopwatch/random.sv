module random (
    input clk,
    output [2:0] random
);
    
logic [2:0] count;

assign random = count;



always_ff @(posedge clk) begin
count <= count + 1;
end


endmodule