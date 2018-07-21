`include "define.v"
//Jump selector. Outputs J (1 bit) connected to the input of the INS module.
module JMP_mux(JMP_sel,AC_Z,ZT,ZRG,ZRT,ZK0,ZK1,J);

input [3:0] JMP_sel;
input       AC_Z,ZT,ZRG,ZRT,ZK0,ZK1;

output reg  J;

always @ (*)
begin
	case (JMP_sel)
		`jmp_none:		J<= 1'd0;
		`jmp_jump:		J<= 1'd1;
		`jmp_jmpz:		J<= AC_Z;
		`jmp_jpnz:		J<= ~AC_Z;
		`jmp_jzt	:		J<= ZT;
		`jmp_jnrg:		J<= ~ZRG;
		`jmp_jnrt:		J<= ~ZRT;
		`jmp_jnk0:     J<= ~ZK0;
		`jmp_jnk1:		J<= ~ZK1;
		  default:  	J<= 1'd0;
	endcase
end
endmodule
