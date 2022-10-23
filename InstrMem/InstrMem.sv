module InstrMem
(
    input [31:0] pc, 
	output wire [31:0] instr
);

reg [31:0] mem [0:63];
initial $readmemb("../PARSED_assembly_code.txt", mem); 
assign instr = mem[pc>>2];             //index = pc/4
endmodule