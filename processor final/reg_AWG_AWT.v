module reg_AWG_AWT (clk, inc, dec, reset, d_out,d_from_ADR,cin);

input clk, inc, dec, reset,cin;
input [8:0] d_from_ADR;
output reg [8:0] d_out = 9'd0;

always @ (posedge clk)
begin

    if(inc)         d_out <= d_out+1;
    else if(dec)    d_out <= d_out-1;
    else if(reset)  d_out <= 9'd0;
	 else if (cin)   d_out <= d_from_ADR;
	 
end

endmodule 