module reg_DATA (clk, d_in1, d_in2, c_in1, c_in2, d_out);

input wire[7:0] d_in1, d_in2;
output reg[7:0] d_out=8'd0;

input c_in1, c_in2, clk;

always @ (posedge clk)
begin
  if      (c_in1) d_out <= d_in1;
  else if (c_in2) d_out <= d_in2;
  else            d_out <= d_out;
end

endmodule
