`include "../RegFile/RegFile.sv"
`include "../ALU/ALU.sv"
`include "../DataMem/DataMem.sv"
`include "../ALUControl/ALUControl.sv"
`include "../ControlUnit/ControlUnit.sv"
`include "../IFIDReg/IFIDReg.sv"
`include "../IDEXReg/IDEXReg.sv"
`include "../EXMEMReg/EXMEMReg.sv"
`include "../MEMWBReg/MEMWBReg.sv"
`include "../PCReg/PCReg.sv"
`include "../InstrMem/InstrMem.sv"
`include "../SignExtention/SignExtend.sv"
`include "../MUX32/MUX32.sv"
`include "../MUX5/MUX5.sv"
`include "../StallControlUnit1/StallControlUnit1.sv"
`include "../StallControlUnit2/StallControlUnit2.sv"
`include "../FlushUnit/FlushUnit.sv"

module PipelinedProcessor
(
    input clk, reset
);

wire [31:0] pc, pc_inp, pcNext, IDpcNext;
wire [31:0] instr, IDinstr, signextendout;

wire [4:0] rs, rt, rd;
wire [5:0] opcode, funct;
wire [15:0] addr16;
wire [31:0] writeData, readData1, readData2;

wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jump, BEQFlag, PCSrc, pcwriteEn, IFIDwriteEn, zero, stall1, stall2, stall;
wire [1:0] ALUOp;

wire EXRegDst, EXALUSrc, EXMemRead, EXMemWrite, EXBranch, EXMemtoReg, EXRegWrite;
wire [31:0] EXpcNext, EXreadData1, EXreadData2, EXsignextendout;
wire [4:0] EXrt, Exrd;
wire [1:0] EXALUOp;

wire [31:0] op1, op2, ALURes, EA;
wire [4:0] writeReg;
wire [3:0] ALUControlRes;

wire MEMMemRead, MEMMemWrite, MEMBranch, MEMMemtoReg, MEMRegWrite, MEMzero;
wire [31:0] MEMEA, MEMreadData2, MEMALURes, readData;
wire [4:0] MEMwriteReg;

wire WBMemtoReg, WBRegWrite;
wire [31:0] WBreadData, WBALURes;
wire [4:0] WBwriteReg;

wire IDRegDst, IDALUSrc, IDMemtoReg, IDRegWrite, IDMemRead, IDMemWrite, IDBranch;
wire [1:0] IDALUOp;

//IF Stage

assign stall = stall1 || stall2;
assign pcwriteEn = ~stall;
assign IFIDwriteEn = ~stall;
MUX32 mux32if(PCSrc, pcNext, MEMEA, pc_inp);
PCReg pcreg(clk, reset, pcwriteEn, pc_inp, pc);
assign pcNext = pc + 32'b100;
InstrMem instrmem(pc, instr);

IFIDReg ifidreg(clk, reset, IFIDwriteEn, IFflush, instr, pcNext, IFIDflush, IDinstr, IDpcNext);

//ID Stage
assign opcode = IDinstr[31:26];
assign rs = IDinstr[25:21];
assign rt = IDinstr[20:16];
assign rd = IDinstr[15:11];
assign funct = IDinstr[5:0];
assign addr16 = IDinstr[15:0];

ControlUnit controlunit(reset, opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BEQFlag, ALUOp);

StallControlUnit2 stallcontrolunit2(reset, EXRegWrite, MEMRegWrite, WBRegWrite, rs, rt, writeReg, MEMwriteReg, WBwriteReg,stall2);

RegFile regfile(clk, reset, WBRegWrite, rs, rt, WBwriteReg, writeData, readData1, readData2);

SignExtend signextend(addr16, signextendout);

assign IFflush = jumpcontrol || PCSrc;
assign IDflush = PCSrc;
assign flush = IDflush || IFIDflush || stall1;

FlushUnit flushunit(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, flush, ALUOp, IDRegDst, IDALUSrc, IDMemtoReg, IDRegWrite, IDMemRead, IDMemWrite, IDBranch, IDALUOp);

IDEXReg idexreg(clk, reset, IDRegDst, IDALUSrc, IDMemRead, IDMemWrite, IDBranch, IDMemtoReg, IDRegWrite, IDpcNext, readData1, readData2, signextendout, rt, rd, IDALUOp, EXRegDst, EXALUSrc, EXMemRead, EXMemWrite, EXBranch, EXMemtoReg, EXRegWrite, EXpcNext, EXreadData1, EXreadData2, EXsignextendout, EXrt, Exrd, EXALUOp);

//EX Stage

assign op1 = EXreadData1;
MUX32 mux32ex(EXALUSrc, EXreadData2, EXsignextendout, op2);
MUX5 mux5(EXRegDst, EXrt, Exrd, writeReg);

assign funct = EXsignextendout[5:0];
ALUControl alucontrol(ALUOp, funct, ALUControlRes);

ALU alu(op1, op2, ALUControlRes, ALURes, zero);

assign EA = (EXsignextendout<<2) + EXpcNext;

EXMEMReg exmemreg(clk, reset, EXMemRead, EXMemWrite, EXBranch, EXMemtoReg, EXRegWrite, zero, EA, ALURes, EXreadData2, writeReg, MEMMemRead, MEMMemWrite, MEMBranch, MEMMemtoReg, MEMRegWrite, MEMzero, MEMEA, MEMreadData2, MEMALURes, MEMwriteReg);

//MEM Stage

assign PCSrc = MEMzero && MEMBranch;
DataMem datamem(clk, MEMMemWrite, MEMMemRead, MEMALURes, MEMreadData2, readData);

MEMWBReg memwbreg(clk, reset, MEMMemtoReg, MEMRegWrite, readData, MEMALURes, MEMwriteReg, WBMemtoReg, WBRegWrite, WBreadData, WBALURes, WBwriteReg);

//WB Stage
MUX32 mux32wb(WBMemtoReg, WBALURes, WBreadData, writeData);

StallControlUnit1 stallcontrolunit1(reset, MEMMemRead, rs, rt, EXrt, stall1);

assign jumpflush = Jump && (~IFIDflush);
assign jumpcontrol = jumpflush && (~PCSrc);
endmodule