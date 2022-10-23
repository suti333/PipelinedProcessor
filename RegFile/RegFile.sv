module RegFile
(
    input clk, reset, regWrite,
    input [4:0] readReg1, readReg2, writeReg,
    input [31:0] writeData,
    output reg [31:0] readData1, readData2
);

reg [31:0] register [31:0];

always @ (posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        for(integer i=0; i<32; i=i+1) begin
            register[i] = 32'b0;
        end
    end
    else begin
        if(regWrite) begin
            register[writeReg] = writeData;
            // $display("reg: ",writeReg);
            // $display("Value stored :",register[writeReg]);
        end
    end
end

always @(*) begin
    if(readReg1 == 5'b0) begin
        readData1 = 32'b0;
    end
    else begin
        readData1 = register[readReg1];
    end

    if(readReg2 == 5'b0) begin
        readData2 = 32'b0;
    end
    else begin
        readData2 = register[readReg2];
    end
end

endmodule