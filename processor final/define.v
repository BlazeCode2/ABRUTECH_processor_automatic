// Control Signals
// use


// [ACI_decoder] To write from A-bus to registers' cin

`define aci_none			5'b00000
`define aci_AC				5'b00001
`define aci_MDDR			5'b00010
`define aci_K0				5'b00100
`define aci_K1				5'b01000
`define aci_G				5'b10000
`define aci_all			5'b11111

// [AWM_mux] To write from registers to A-bus (A mux selection bits)

`define awm_AC				3'd0
`define awm_MDDR			3'd1
`define awm_K0				3'd2
`define awm_K1				3'd3
`define awm_G0				3'd4
`define awm_G1				3'd5
`define awm_G2				3'd6
`define awm_MIDR			3'd7

// [INC_decoder] inc signals for registers

`define inc_none			3'd0
`define inc_ADR				3'd1
`define inc_ART				3'd2
`define inc_ARG				3'd3
`define inc_AWT				3'd4
`define inc_AWG				3'd5
`define inc_AC				3'd6
`define inc_MDAR			3'd7

// [DEC_decoder] dec signals for registers

`define dec_none			3'd0
`define dec_ADR				3'd1
`define dec_ART				3'd2
`define dec_ARG				3'd3
`define dec_AWT				3'd4
`define dec_AWG				3'd5
`define dec_AC				3'd6
`define dec_MDAR			3'd7

// [ALU] ALU selection bits

`define alu_none			3'd0
`define alu_add		  	3'd1
`define alu_sub		  	3'd2
`define alu_div    		3'd3    
`define alu_mul    		3'd4    


// [ADR_maker] Selection bits for ADR_maker

`define adr_none			4'd0
`define adr_matrix_r		4'd1
`define adr_matrix_w		4'd2
`define adr_last8			4'd3
`define adr_mid8			4'd4
`define adr_first2		4'd5
`define adr_to_mdar		4'd6
`define adr_to_ar 		4'd7
`define adr_to_aw 		4'd8
`define adr_to_ar_ref	4'd9

// [JMP_encoder] Jump signals


`define jmp_none			4'd0
`define jmp_jump			4'd1
`define jmp_jmpz			4'd2
`define jmp_jpnz			4'd3
`define jmp_jzt			4'd4
`define jmp_jnrg			4'd5
`define jmp_jnrt			4'd6
`define jmp_jnk0			4'd7
`define jmp_jnk1			4'd8

// [OPR_decoder] To give operations controls

`define opr_none			3'd0
`define opr_aci_awm		    3'd1
`define opr_awm  		    3'd2
`define opr_inc				3'd3
`define opr_pc				3'd4
`define opr_rst				3'd5
`define opr_dec             3'd6

// [RST_decoder] To give reset controls

`define rst_none			3'd0
`define rst_ART				3'd1
`define rst_ARG				3'd2
`define rst_AWT				3'd3
`define rst_AWG				3'd4
`define rst_MDAR			3'd5
`define rst_all				3'd6

//memory signals

`define mem_none          3'b000
`define mem_dm_write      3'b100
`define mem_mddr_m_ci     3'b010
`define mem_midr_m_ci     3'b001

//parameter router

`define prm_none          2'd0
`define prm_jmp           2'd1
`define prm_adr           2'd2
`define prm_add_sub       2'd3