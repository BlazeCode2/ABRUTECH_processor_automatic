

module processor(
						clock,
						D_address,
						D_din,
						D_dout,
						D_wen,
						p_enable,
						I_dout,
						I_address,
						STATE,
						status,
						ADR_to_Tx);

input         clock,p_enable;
input [7:0]   D_dout;
input [7:0]   I_dout;


output [17:0] D_address;
output [17:0] ADR_to_Tx;
output [7:0]  D_din;
output        D_wen;
output [7:0]  I_address;
output [7:0]  STATE;
output        status;


//wiring

wire [7:0] AC_to_AWM;
wire [7:0] K0_to_AWM;
wire [7:0] K1_to_AWM;
wire [7:0] G0_to_AWM;
wire [7:0] G1_to_AWM;
wire [7:0] G2_to_AWM;
wire [7:0] MDDR_out;
wire [7:0] MIDR_out;
wire [7:0] A_BUS;

wire [7:0] OPR_to_INC;
wire [7:0] OPR_to_DEC;
wire [7:0] OPR_to_ACI;
wire [7:0] OPR_to_AWM;
wire [7:0] OPR_to_din_PC;
wire [7:0] OPR_to_RST;

wire       SM_to_ADR_TOG;
wire [4:0] SM_to_ACI;
wire [2:0] SM_to_AWM;
wire [2:0] SM_to_MEM;
wire [2:0] SM_to_ALU;
wire [3:0] SM_to_PRM_param;   
wire [1:0] SM_to_PRM_sel;    
wire [2:0] SM_to_OPR;
wire [3:0] SM_to_ADR;
wire       SM_to_PC;

wire ACI_to_MDDR;
wire ACI_to_MDDR_Cin2;
wire ACI_to_K0_Cin;
wire ACI_to_K1_Cin;
wire ACI_to_G_SHF;
wire ACI_to_AC;

wire [3:0] PRM_to_ADR;
wire [3:0] PRM_to_JMP; 
wire [2:0] PRM_to_AWM;

wire INC_to_ART;
wire INC_to_ARG;
wire INC_to_AWT;
wire INC_to_AWG;
wire INC_to_AC;
wire INC_to_K0;
wire INC_to_K1;


wire DEC_to_ART;
wire DEC_to_ARG;
wire DEC_to_AWT;
wire DEC_to_AWG;
wire DEC_to_AC;
wire DEC_to_K0;
wire DEC_to_K1;
wire AC_Z;


wire [8:0]  ART_to_ADR;
wire [8:0]  ARG_to_ADR;
wire [8:0]  AWT_to_ADR;
wire [8:0]  AWG_to_ADR;
wire        INC_to_ADR;
wire        DEC_to_ADR;
wire [17:0] ADR_to_DMEM;
wire        ADR_to_JMP_TOG;
wire        ADR_to_AWG_cin;
wire        ADR_to_AWT_cin;
wire        ADR_to_ARG_cin;
wire        ADR_to_ART_cin;
wire        ADR_to_ARG_ref_cin;
wire        ADR_to_ART_ref_cin;
wire [8:0]  ADR_to_ART_data;
wire [8:0]  ADR_to_ARG_data;
wire [8:0]  ADR_to_AWT_data;
wire [8:0]  ADR_to_AWG_data;

wire ARG_to_JMP_Z;
wire ART_to_JMP_Z;
wire K0_to_JMP_Z;
wire K1_to_JMP_Z;

wire       JMP_to_PC_Cin;
wire [7:0] PC_IMEM;

wire RST_to_AC;
wire RST_to_ADR;
wire RST_to_ART;
wire RST_to_ARG;
wire RST_to_AWT;
wire RST_to_AWG;
wire RST_to_K0;
wire RST_to_K1;

wire [7:0] IMEM_to_MIDR;
wire [7:0] DMEM_to_MDDR;


assign DMEM_to_MDDR=D_dout;
assign IMEM_to_MIDR=I_dout;
assign I_address=PC_IMEM;
assign D_address=ADR_to_DMEM;
assign D_wen=SM_to_MEM[2];
assign D_din=MDDR_out;

//STATE MACHINE

state_machine SM(
			.clock(clock),
			.MIDR(MIDR_out),
			.TOG(SM_to_ADR_TOG),
			.ACI(SM_to_ACI),
			.AWM(SM_to_AWM),
			.MEM(SM_to_MEM),
			.ALU(SM_to_ALU),
			.PRM_param(SM_to_PRM_param),
			.PRM(SM_to_PRM_sel),
			.OPR(SM_to_OPR),
			.ADR(SM_to_ADR),
			.PCI(SM_to_PC),
			.STATE(STATE),
			.start(p_enable),
			.status(status));
			
					
//PRM ROUTER

PRM prm_router(
			.PARAM(SM_to_PRM_param),
			.select(SM_to_PRM_sel),
			.to_ADR(PRM_to_ADR),
			.to_JMP(PRM_to_JMP),
			.to_AWM(PRM_to_AWM));

//ACI DECODER
			
ACI_decoder ACI(
			.A_sel(SM_to_ACI | OPR_to_ACI[4:0]),
			.MDDR(ACI_to_MDDR_Cin2),
			.K0(ACI_to_K0_Cin),
			.K1(ACI_to_K1_Cin),
			.G(ACI_to_G_SHF),
			.AC(ACI_to_AC));

//AWM MULTIPLEXER

AWM_mux AWM_mux(
		  .data0x(AC_to_AWM[7:0]),    //AC
		  .data1x(MDDR_out),        	//MDDR
		  .data2x(K0_to_AWM),			//K0
		  .data3x(K1_to_AWM),			//K1
		  .data4x(G0_to_AWM),			//G0
		  .data5x(G1_to_AWM),			//G1
		  .data6x(G2_to_AWM),			//G2
		  .data7x(MIDR_out),				//MIDR
		  .sel(OPR_to_AWM[2:0] | SM_to_AWM | PRM_to_AWM),
		  .result(A_BUS));		      //A_Bus

//INC DECODER		  
		  
INC_DEC_RST INC(       //instantiate increment
		  .I_sel(OPR_to_INC),
		  .ADR(INC_to_ADR),
		  .ART(INC_to_ART),
		  .ARG(INC_to_ARG),
		  .AWT(INC_to_AWT),
		  .AWG(INC_to_AWG),
		  .AC(INC_to_AC),
		  .K0(INC_to_K0),
		  .K1(INC_to_K1));


//ALU

ALU ALU(
		  .select(SM_to_ALU),
		  .A_bus(A_BUS),
		  .Z_out(AC_Z),           //Z
		  .AC(AC_to_AWM),         //AC
		  .cin_AC(ACI_to_AC),
		  .inc_AC(INC_to_AC),     //inc_AC
		  .dec_AC(DEC_to_AC),	  //dec_AC
		  .clk(clock),
		  .rst(RST_to_AC));
		  
//ADDRESS MAKER

ADR_maker ADR(
	     .AWREF(ADR_to_Tx),
		  .in_Clock(clock),
		  .A(A_BUS),
		  .ART(ART_to_ADR),
		  .ARG(ARG_to_ADR),
		  .AWT(AWT_to_ADR),
		  .AWG(AWG_to_ADR),
		  .inc(INC_to_ADR),
		  .dec(DEC_to_ADR),
		  .TOG_inc(SM_to_ADR_TOG),
		  .TOG(ADR_to_JMP_TOG),
		  .SEL(PRM_to_ADR | SM_to_ADR),
		  .reset(RST_to_ADR),
		  .d_out(ADR_to_DMEM),
		  .d_to_ART(ADR_to_ART_data),      
		  .d_to_ARG(ADR_to_ARG_data),
		  .d_to_AWT(ADR_to_AWT_data),
		  .d_to_AWG(ADR_to_AWG_data),
		  .cin_ART(ADR_to_ART_cin), 
		  .cin_ARG(ADR_to_ARG_cin),
		  .cin_AWT(ADR_to_AWT_cin),
		  .cin_AWG(ADR_to_AWG_cin),
		  .cin_ART_ref(ADR_to_ART_ref_cin), 
		  .cin_ARG_ref(ADR_to_ARG_ref_cin));
		  
//JUMP MULTIPLEXER

JMP_mux JMP(
		  .JMP_sel(PRM_to_JMP),
		  .AC_Z(AC_Z),
		  .ZT(ADR_to_JMP_TOG),
		  .ZRG(ARG_to_JMP_Z),
		  .ZRT(ART_to_JMP_Z),
		  .ZK0(K0_to_JMP_Z),
		  .ZK1(K1_to_JMP_Z),
		  .J(JMP_to_PC_Cin));

//OPR

OPR OPR(
		  .MIDR(MIDR_out),				//output of MIDR goes in here
		  .select(SM_to_OPR),			//control signals of OPR
		  .ACI(OPR_to_ACI),				//output MIDR value to ACI input
		  .AWM(OPR_to_AWM),				//output MIDR value to AWM input
		  .INC(OPR_to_INC),				//output MIDR value to INC input
		  .DEC(OPR_to_DEC),				//output MIDR value to DEC input
		  .din_PC(OPR_to_din_PC),     //output MIDR value to din_PC input
		  .RST(OPR_to_RST));				//output MIDR value to RST input
		  
//RESET DECODER

INC_DEC_RST RST(
		  .I_sel(OPR_to_RST),
		  .ADR(RST_to_ADR),
		  .ART(RST_to_ART),
		  .ARG(RST_to_ARG),
		  .AWT(RST_to_AWT),
		  .AWG(RST_to_AWG),
		  .AC(RST_to_AC), 
		  .K0(RST_to_K0),
		  .K1(RST_to_K1));
		  
//DECREMENT DECODER

INC_DEC_RST DEC(   
		  .I_sel(OPR_to_DEC),
		  .ADR(DEC_to_ADR),
		  .ART(DEC_to_ART),
		  .ARG(DEC_to_ARG),
		  .AWT(DEC_to_AWT),
		  .AWG(DEC_to_AWG),
		  .AC(DEC_to_AC),
		  .K0(DEC_to_K0),
		  .K1(DEC_to_K1));



//registers

//PC

reg_PC PC(
		  .clk(clock),
		  .cin(JMP_to_PC_Cin),
		  .inc(SM_to_PC),
		  .d_in(OPR_to_din_PC),
		  .d_out(PC_IMEM));

//MIDR
		  
reg_DATA MIDR(
		  .clk(clock),
		  .d_in1(8'd0),
		  .d_in2(IMEM_to_MIDR),
		  .c_in1(0),
		  .c_in2(SM_to_MEM[0]),
		  .d_out(MIDR_out));
		  
//MDDR

reg_DATA MDDR(
		  .clk(clock),
		  .d_in1(DMEM_to_MDDR),
		  .d_in2(A_BUS),
		  .c_in1(SM_to_MEM[1]),
		  .c_in2(ACI_to_MDDR_Cin2),
		  .d_out(MDDR_out));
		  
//ART

reg_ARG_ART ART(
		  .clk(clock),
		  .inc(INC_to_ART),
		  .dec(DEC_to_ART),
		  .reset(RST_to_ART),
		  .Z_OUT(ART_to_JMP_Z),       //ZRT
		  .d_out(ART_to_ADR),
		  .cin(ADR_to_ART_cin), 
		  .cin_ref(ADR_to_ART_ref_cin),
		  .d_from_ADR(ADR_to_ART_data));
		  
//ARG

reg_ARG_ART ARG(
		  .clk(clock),
		  .inc(INC_to_ARG),
		  .dec(DEC_to_ARG),
		  .reset(RST_to_ARG),
		  .Z_OUT(ARG_to_JMP_Z),     //ZRG
		  .d_out(ARG_to_ADR),
		  .cin(ADR_to_ARG_cin), 
		  .cin_ref(ADR_to_ARG_ref_cin),
		  .d_from_ADR(ADR_to_ARG_data));
		  
//AWT

reg_AWG_AWT AWT(
		  .clk(clock),
		  .inc(INC_to_AWT),      		 //inc_AWT
		  .dec(DEC_to_AWT),       		 //dec_AWT
		  .reset(RST_to_AWT),
		  .d_out(AWT_to_ADR),    	    //AWT out
		  .d_from_ADR(ADR_to_AWT_data),
		  .cin(ADR_to_AWT_cin)); 
		  
//AWG

reg_AWG_AWT AWG(
		  .clk(clock),
		  .inc(INC_to_AWG),             //inc_AWG
		  .dec(DEC_to_AWG), 				 //dec_AWG
		  .reset(RST_to_AWG),
		  .d_out(AWG_to_ADR),          //AWG out
		  .d_from_ADR(ADR_to_AWG_data),
		  .cin(ADR_to_AWG_cin));          
		  
//K0

reg_K K0(
        .din(A_BUS),
		  .dout(K0_to_AWM),
		  .clk(clock),
		  .write(ACI_to_K0_Cin),
		  .rst(RST_to_K0),
		  .inc(INC_to_K0),
		  .dec(DEC_to_K0),
		  .k_Z(K0_to_JMP_Z));
		  
//K1

reg_K K1(
        .din(A_BUS),
		  .dout(K1_to_AWM),
		  .clk(clock),
		  .write(ACI_to_K1_Cin),
		  .rst(RST_to_K1),
		  .inc(INC_to_K1),
		  .dec(DEC_to_K1),
		  .k_Z(K1_to_JMP_Z));
		  
//G

reg_G G(
        .din(A_BUS),
		  .G0_out(G0_to_AWM),
		  .G1_out(G1_to_AWM),
        .G2_out(G2_to_AWM),
		  .clk(clock),
		  .shift(ACI_to_G_SHF));

endmodule
