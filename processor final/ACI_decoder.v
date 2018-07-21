//A bus to registers write => control instructions
module ACI_decoder(A_sel,MDDR,K0,K1,G,AC); 

input [4:0] A_sel;

output   MDDR,K0,K1,G,AC;

assign AC   = A_sel[0];
assign MDDR = A_sel[1];
assign K0   = A_sel[2];
assign K1   = A_sel[3];
assign G    = A_sel[4];


endmodule 