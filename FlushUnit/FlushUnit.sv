module FlushUnit 
(
    input RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, flush,
    input [1:0] ALUOp,
    output reg IDRegDst, IDALUSrc, IDMemtoReg, IDRegWrite, IDMemRead, IDMemWrite, IDBranch,
    output reg [1:0] IDALUOp
);

always @(*) begin
    IDRegDst <= RegDst && (~flush);
    IDALUSrc <= ALUSrc && (~flush);
    IDMemtoReg <= MemtoReg && (~flush);
    IDRegWrite <= RegWrite && (~flush);
    IDMemRead <= MemRead && (~flush);
    IDMemWrite <= MemWrite && (~flush);
    IDBranch <= Branch && (~flush);
    IDALUOp <= ALUOp && (~flush);
end

endmodule