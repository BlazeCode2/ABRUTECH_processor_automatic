module key_split(in,Tx_out,p_out,i_d_out,enable,selector);

input in;
input enable;
input [1:0] selector;    
output reg Tx_out=1,p_out=1,i_d_out=1;

parameter  DIRECT_TO_IDLE =2'b00;
parameter  DIRECT_TO_Rx   =2'b01;
parameter  DIRECT_TO_P    =2'b10;
parameter  DIRECT_TO_Tx   =2'b11;

always @(in,selector,enable)
	if (enable==1)
		begin
			case(selector)
				DIRECT_TO_IDLE:
					begin
						Tx_out  <= 1;
						p_out   <= 1;
						i_d_out <= in;
					end
				DIRECT_TO_Rx:
					begin
						Tx_out  <= 1;
						p_out   <= 1;
						i_d_out <= in;
					end
				DIRECT_TO_P:
					begin
						Tx_out  <= 1;
						p_out   <= in;
						i_d_out <= 1;
					end
				DIRECT_TO_Tx:
					begin
						Tx_out  <= in;
						p_out   <= 1;
						i_d_out <= 1;
					end
				default:
					begin
						Tx_out  <= 1;
						p_out   <= 1;
						i_d_out <= 1;
					end				
			endcase
		end
	else 
		begin
			Tx_out  <= 1;
			p_out   <= 1;
			i_d_out <= 1;
		end
endmodule
