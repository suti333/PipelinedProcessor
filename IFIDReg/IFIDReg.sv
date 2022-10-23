module IFIDReg
(
    input clk, reset, IFIDwriteEn, IFflush, 
    input [31:0] instr, pcNext,
    output reg IFIDflush, 
    output reg [31:0] IDinstr, IDpcNext
);

always @(reset) begin
    if(reset == 1'b1) begin
        IFIDflush <= 1'b0;
        IDinstr <= 32'b0;
        IDpcNext <= 32'b0;
    end
end

always @(posedge clk) begin
	if (IFIDwriteEn) begin
        IFIDflush <= IFflush;
		IDinstr <= instr;
        IDpcNext <= pcNext; 
	end
end

endmodule