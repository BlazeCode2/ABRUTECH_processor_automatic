module reg_ARG_ART (clk, inc, dec, reset, Z_OUT, d_out, cin, cin_ref,d_from_ADR);

input       clk, inc, dec, reset, cin, cin_ref;
input [8:0] d_from_ADR;

output reg       Z_OUT = 1;
output reg [8:0] d_out = 9'd0;

reg [8:0] ref=9'd0;

always @ (posedge clk)
	begin
		 if(inc)         d_out <= d_out+1;
		 else if(dec)    d_out <= d_out-1;
		 else if(reset)  d_out <= 9'd0;
		 else if (cin) d_out <= d_from_ADR;
		 else if (cin_ref) ref <= d_from_ADR;
	end

always @ (d_out)
	begin
		if(d_out == ref)   Z_OUT <= 1;
		else               Z_OUT <= 0;
	end
  
endmodule
