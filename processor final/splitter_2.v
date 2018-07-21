module splitter_2 #(parameter bit_width=1) (in,d_out,i_out,enable,selector);

input [bit_width-1:0] in;
input enable;
input selector;    // [D or I]
output reg [bit_width-1:0] d_out,i_out;

parameter  DIRECT_TO_D=0;
parameter  DIRECT_TO_I=1;

always @(in,selector,enable)
	if (enable==1)
		begin
			case(selector)
				DIRECT_TO_D:
					begin
						d_out<=in;
						i_out<=1;
					end
				DIRECT_TO_I:
					begin
						i_out<=in;
						d_out<=1;
					end
				default:
					begin
						i_out<=1;
						d_out<=1;
					end				
			endcase
		end
	else 
		begin
			d_out<=1;
			i_out<=1;
		end
endmodule
