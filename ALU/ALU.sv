module ALU
(
    input [31:0] op1, op2,
    input [3:0] ALUControl,
    output reg [31:0] ALURes,
    output reg zero
);

always @(*) begin
    case(ALUControl)
    4'b0010: ALURes = op1+op2;   //add
    4'b0110: ALURes = op1-op2;   //subtract
    4'b1000: ALURes = op1*op2;   //multiply
    4'b0000: ALURes = op1&op2;   //and
    4'b0001: ALURes = op1|op2;   //or
    4'b0111: ALURes = (op1 < op2) ? 32'd1: 32'd0;  //set on less than
    endcase

    if(ALURes == 32'd0) begin
        assign zero = 1'b1;
    end
    else begin
        assign zero = 1'b0;
    end
end
endmodule