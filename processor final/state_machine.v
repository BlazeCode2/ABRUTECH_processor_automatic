`include "define.v"
`include "opcode_define.v"
module state_machine(
			clock,
			MIDR,
			TOG,
			ACI,
			AWM,
			MEM,
			ALU,
			PRM_param,
			PRM,
			OPR,
			ADR,			
			PCI,
			STATE,
			start,
			status
			);

input       clock ,start;
input [7:0] MIDR;

output reg  [4:0] ACI=5'd0;
output reg  [3:0] PRM_param=4'd0,ADR=4'd0;
output reg  [2:0] AWM=3'd0,MEM=3'd0,OPR=3'd0,ALU=3'd0; 
output reg  [1:0] PRM=2'd0;
output reg  PCI=0,TOG=0;
output reg  status=0;
output reg  [7:0] STATE = 8'd0;


always @(negedge clock)
begin
	case(STATE)
		`END:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_jmp;
				OPR  <=   `opr_pc;
				ADR  <=   `adr_none;
				TOG  <=    0;
				PRM_param  <=  `jmp_jump;
				if(start)    //means negative edge of start button
					begin
						STATE <= `FETCH;
						status<=1;
					end
				else  status<=0;
			end
		`FETCH:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`FETCH_2:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;	
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_3;
			end
		`FETCH_3:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=    {MIDR[7:4],4'd0};
				PRM_param <= MIDR[3:0]; 
			end

		`LODK:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `LODK_2;
			end
		`LODK_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_AC;
				AWM  <=   `awm_MIDR;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`LADD:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `LADD_2;
			end

		`LADD_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_MIDR	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_first2;
				TOG  <=    0;
				STATE<=   `LADD_3;
			end

		`LADD_3:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `LADD_4;
			end

		`LADD_4:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_MIDR	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_mid8;
				TOG  <=    0;
				STATE<=   `LADD_5;
			end

		`LADD_5:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `LADD_6;
			end

		`LADD_6:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_MIDR	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_last8;
				TOG  <=    0;
				STATE<=   `LADD_7;
			end

		`LADD_7:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_adr;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`LOAD:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_adr;
				OPR  <=   `opr_none;	
		      ADR  <=   `adr_none;		
				TOG  <=    0;
				STATE<=   `LOAD_2;
			end

		`LOAD_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `LOAD_3;
			end

		`LOAD_3:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_mddr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end

		`STAC:
			begin
				PCI  <=    0;
				ACI  <=   `aci_MDDR;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_dm_write;
				ALU  <=   `alu_none;
				PRM  <=   `prm_adr;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`COPY:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `COPY_2;
			end
		`COPY_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_aci_awm;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`RSET:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `RSET_2;
			end
		`RSET_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_rst;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end
		`JUMP:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `JUMP_2;
			end
		`JUMP_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_jmp;
				OPR  <=   `opr_pc;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH;
			end
		`INCR:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `INCR_2;
			end

		`INCR_2:
			begin
				PCI  <=    0;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_none;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_inc;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `FETCH_2;
			end

		`DECR:
			begin
				PCI  <=    1;
				ACI  <=   `aci_none;
				AWM  <=   `awm_AC	;
				MEM  <=   `mem_midr_m_ci;
				ALU  <=   `alu_none;
				PRM  <=   `prm_none;
				OPR  <=   `opr_none;
				ADR  <=   `adr_none;
				TOG  <=    0;
				STATE<=   `DECR_2;
			end

			`DECR_2:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_none;
					PRM  <=   `prm_none;
					OPR  <=   `opr_dec;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end

			`ADD:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_add;
					PRM  <=   `prm_add_sub;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end
				
			`SUBT:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_sub;
					PRM  <=   `prm_add_sub;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end

			`DIV:
				begin
					PCI  <=    1;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_midr_m_ci;
					ALU  <=   `alu_none;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `DIV_2;
				end
			`DIV_2:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_MIDR	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_div;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end
			`MUL:
				begin
					PCI  <=    1;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_midr_m_ci;
					ALU  <=   `alu_none;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `MUL_2;
				end
			`MUL_2:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_MIDR	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_mul;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end
			`TOGL:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_none;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    1;
					STATE<=   `FETCH_2;
				end
			`NOOP:
				begin
					PCI  <=    0;
					ACI  <=   `aci_none;
					AWM  <=   `awm_AC	;
					MEM  <=   `mem_none;
					ALU  <=   `alu_none;
					PRM  <=   `prm_none;
					OPR  <=   `opr_none;
					ADR  <=   `adr_none;
					TOG  <=    0;
					STATE<=   `FETCH_2;
				end
			default: STATE <= `END;
	endcase
end

endmodule
