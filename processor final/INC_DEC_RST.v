// [INC_decoder] inc signals for registers
module INC_DEC_RST(I_sel,ADR,ART,ARG,AWT,AWG,AC,K0,K1);

input [7:0] I_sel;
output ADR,ART,ARG,AWT,AWG,AC,K0,K1;

assign ADR = I_sel[0];
assign ART = I_sel[1];
assign ARG = I_sel[2];
assign AWT = I_sel[3];
assign AWG = I_sel[4];
assign AC  = I_sel[5];
assign K0  = I_sel[6];
assign K1  = I_sel[7];

endmodule
