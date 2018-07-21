`include "define.v"

module ALU(select,A_bus,Z_out,AC,inc_AC,cin_AC,dec_AC,clk,rst);

input       clk,inc_AC,dec_AC,cin_AC,rst;
input [2:0] select;
input [7:0] A_bus;

output reg [11:0] AC=12'd0;
output reg        Z_out=1;

always @(AC)
	begin
		if(AC==12'b0) Z_out<=1; else Z_out<=0;
	end

always @(posedge clk)
	begin
		if (cin_AC) AC <= {4'd0,A_bus};
		else
			begin
				case(select)
					`alu_none:	
						begin
							if (inc_AC==1)     AC <= AC+1;
							else if(dec_AC==1) AC <= AC-1;
							else if(rst==1)    AC <= 12'd0;
						end
					`alu_add :	AC <= AC+{4'd0,A_bus};
					`alu_sub :	
						begin
							if(AC>{4'd0,A_bus}) AC <= AC-{4'd0,A_bus};
							else                AC <= {4'd0,A_bus}-AC;
						end
					`alu_div :	AC <= (AC+{5'd0,A_bus[7:1]})/{4'd0,A_bus};
					`alu_mul :  AC <= AC * A_bus;
					default  :	AC <= AC;
				endcase
			end
	end

endmodule
