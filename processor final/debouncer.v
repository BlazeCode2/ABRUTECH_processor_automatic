module debouncer(button_in,clk,button_out);

input clk,button_in;
output reg button_out=1;

reg [3:0] counter=4'd0;

always @(posedge clk)
begin
	if (button_in==0)
		begin
			counter<=counter+1;
			if (counter==4'b1111) button_out<=0;
		end
	else
		begin
			counter<=4'd0;
			button_out<=1;
		end
end

endmodule
