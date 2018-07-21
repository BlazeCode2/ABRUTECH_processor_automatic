module bi2bcd(din,dout2,dout1,dout0);


input  [7:0] din;
output [6:0] dout0;
output [6:0] dout1;
output [6:0] dout2;

reg [3:0]  counter=3'b0;
reg [19:0] shifter=20'd0;

decoder d0(.din(shifter[11:8]),.dout(dout0));
decoder d1(.din(shifter[15:12]),.dout(dout1));
decoder d2(.din(shifter[19:16]),.dout(dout2));

always @(din)
begin
	shifter[7:0]=din;
	shifter[19:8]=12'b0;
	for (counter=4'd0;counter<4'd8;counter=counter+1) begin
		if(shifter[11:8]>4'd4)
			begin
				shifter[11:8]=shifter[11:8]+4'd3;
			end
		if(shifter[15:12]>4'd4)
			begin
				shifter[15:12]=shifter[15:12]+4'd3;
			end
		if(shifter[19:16]>4'd4)
			begin
				shifter[19:16]=shifter[19:16]+4'd3;
			end
		shifter=shifter<<1;
	end
end



endmodule
