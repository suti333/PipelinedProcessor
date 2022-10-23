module ALUControl
(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [3:0] ALUControlRes
);

always @(*) begin
    if(ALUOp == 2'b00) begin   //Load, Store and Add Immediate instructions
        ALUControlRes = 4'b0010;
    end

    if(ALUOp == 2'b01) begin   //Branch if equal instructions
        ALUControlRes = 4'b0110;
    end

    if(ALUOp == 2'b10) begin   //R-type instructions
        casex (funct)
            6'b100000:  ALUControlRes = 4'b0010;  //add
            6'b100010:  ALUControlRes = 4'b0110;  //subtract
            6'b011000:  ALUControlRes = 4'b1000;  //multiply
            6'b100100:  ALUControlRes = 4'b0000;  //and
            6'b100101:  ALUControlRes = 4'b0001;  //or
            6'b101010:  ALUControlRes = 4'b0111;  //set on less than
        endcase
    end
end

endmodule