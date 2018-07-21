module reg_K (din, dout, clk, write,rst,inc,dec,k_Z);

input clk, write, rst, inc, dec;
input [7:0] din;
output reg [7:0] dout = 8'd0;
output reg k_Z=1;
  
reg [7:0] k_ref = 8'd0;
reg tog=0;

always @(dout,k_ref)
	begin
		if(k_ref == dout) k_Z <=1;
		else 			   	k_Z <=0;
	end
	
always @ ( posedge clk )
	begin
		if (rst ==1 )
			begin
				tog   <= 0;
				dout  <= 8'd0;
				k_ref <= 8'd0;
			end
		else if (write == 1) 
			begin
				dout <= din;
				if ( tog == 0)
					begin
						k_ref <= din;
						tog   <= 1;
					end
			end
		else if (inc == 1) dout <= dout + 1;
		else if (dec == 1) dout <= dout - 1;
	end

endmodule // reg_Kdin, dout, clk, writeinput clk, write;
