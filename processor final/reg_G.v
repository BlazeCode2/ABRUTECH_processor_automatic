module reg_G (din, G0_out, G1_out,
              G2_out, clk, shift);

input clk, shift;
input[7:0] din;
output reg [7:0] G0_out = 8'd0, G1_out = 8'd0, G2_out = 8'd0;


always @(posedge clk)
	begin
	  if (shift == 1'b1)
		 begin
			G2_out <= G1_out;
			G1_out <= G0_out;
			G0_out <= din;
		 end
	end

endmodule // reg_G0
