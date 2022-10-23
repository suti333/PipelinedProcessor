module StallControlUnit2
(
    input reset, EXRegWrite, MEMRegwrite, WBRegWrite,
    input [4:0] rs, rt, writeReg, MEMwriteReg, WBwriteReg,
    output reg stall
);

always @(*) begin
    if(reset == 1'b0) begin
        if((EXRegWrite == 1'b1 && ((rs == writeReg && rs != 5'b0) || (rt == writeReg && rt != 5'b0))) || (MEMRegwrite == 1'b1 && ((rs == MEMwriteReg && rs != 5'b0) || (rt == MEMwriteReg && rt != 5'b0))) || (WBRegWrite == 1'b1 && ((rs == WBwriteReg && rs != 5'b0) || (rt == WBwriteReg && rt != 5'b0)))) begin // hazard detected
		    stall <= 1'b1;
	    end
        else begin // hazard not detected
		    stall <= 1'b0;
	    end
    end
    else begin
        stall <= 1'b1;
    end 
end

endmodule