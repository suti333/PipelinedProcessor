module StallControlUnit1
(
    input reset, MEMMemRead,
    input [4:0] rs, rt, EXrt,
    output reg stall
);

always @(*) begin
    if(reset == 1'b0) begin
        if(MEMMemRead == 1'b1 && (rs == EXrt || rt == EXrt)) begin // hazard detected
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