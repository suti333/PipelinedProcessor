module DataMem
(
    input clk, memWrite, memRead,
    input [31:0] address, writeData,
    output reg [31:0] readData
);

reg [31:0] memory[1023:0];

initial begin
    for(integer i=0; i<1024; i=i+1) begin
        memory[i] <= 32'b0;
    end
end

always @ (posedge clk) begin
    if(memWrite) begin
        memory[address>>2] <= writeData;
    end
    if(memRead) begin
        readData <= memory[address>>2];
    end
end

endmodule