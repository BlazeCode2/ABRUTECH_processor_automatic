module reg_PC (clk, cin, inc,d_in, d_out);

input           clk, cin, inc;
input wire[7:0] d_in;
output reg[7:0] d_out = 8'd0;


always @ ( posedge clk )
begin
  if(cin)       d_out <= d_in;
  else if(inc)  d_out <= d_out + 1;
  else          d_out <= d_out;
end


endmodule
