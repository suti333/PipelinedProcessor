module ControlUnit
(
    input reset,
    input [5:0] opcode, // Input 31-26 of instruction
    output reg RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BEQFlag,
    output reg [1:0] ALUOp
);

always @(*) begin
    if(reset == 1'b0) begin
        casex (opcode)
            6'b000000:    //R-type instructions
            begin
                ALUOp=2'b10;
                ALUSrc=1'b0;
                RegDst=1'b1;
                Jump=1'b0;
                Branch=1'b0;
                MemtoReg=1'b0;
                RegWrite=1'b1;
                MemRead=1'b0;
                MemWrite=1'b0;
            end

            6'b001000:   //Add immediate instructions
            begin
                ALUOp=2'b00;
                ALUSrc=1'b1;
                RegDst=1'b0;
                Jump=1'b0;
                Branch=1'b0;
                MemtoReg=1'b0;
                RegWrite=1'b1;
                MemRead=1'b0;
                MemWrite=1'b0;
            end

            6'b100011:   //Load instructions
            begin
                ALUOp=2'b00;
                ALUSrc=1'b1;
                RegDst=1'b0;
                MemRead=1'b1;
                MemWrite=1'b0;
                Jump=1'b0;
                Branch=1'b0;
                MemtoReg=1'b1;
                RegWrite=1'b1;
            end

            6'b101011:   //Store instructions
            begin
                ALUOp=2'b00;
                ALUSrc=1'b1;
                RegDst=1'b0;
                MemWrite=1'b1;
                MemRead=1'b0; 
                MemtoReg=1'b0;
                Jump=1'b0;
                Branch=1'b0;
                RegWrite=1'b0;
            end

            6'b000010:   //Jump instructions
            begin
                Jump=1'b1;
                Branch=1'b0;
            end

            6'b000100:   //Branch if equal instructions
            begin
                ALUOp=2'b01;
                ALUSrc=1'b0;
                Branch=1'b1;
                Jump=1'b0;
                BEQFlag=1'b1;
            end

            6'b000101:   //Branch if not equal instructions
            begin
                ALUOp=2'b01;
                Branch=1'b1;
                Jump=1'b0;
                BEQFlag=1'b0;
            end
        endcase
    end
    else begin
        RegDst <= 1'b0;
        Jump <= 1'b0;
        Branch <= 1'b0;
        MemRead <= 1'b0;
        MemtoReg <= 1'b0;
        MemWrite <= 1'b0;
        ALUSrc <= 1'b0;
        RegWrite <= 1'b0;
        BEQFlag <= 1'b0;
        ALUOp <= 2'b0;
    end
end

endmodule

