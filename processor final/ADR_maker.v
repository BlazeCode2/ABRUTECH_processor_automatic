`include "define.v"
module ADR_maker (AWREF,in_Clock, A, ART, ARG, AWT, AWG, inc, 
					dec, TOG_inc, SEL, reset, d_out,TOG,d_to_ART, d_to_ARG,d_to_AWT,d_to_AWG,
					cin_ART, cin_ARG,cin_AWT,cin_AWG,cin_ART_ref, cin_ARG_ref);

input           in_Clock, inc, dec,TOG_inc, reset;
input wire[3:0] SEL;
input wire[7:0] A;
input wire[8:0] ART, ARG,AWT,AWG;

output reg TOG=0;
output reg[17:0] d_out=18'd0;  //MDAR
output reg[17:0] AWREF=18'd0;
output reg[8:0] d_to_ART=9'd0, d_to_ARG=9'd0,d_to_AWT=9'd0,d_to_AWG=9'd0;
output reg cin_ART=0, cin_ARG=0,cin_AWT=0,cin_AWG=0,cin_ART_ref=0, cin_ARG_ref=0;

reg [17:0] TEMP_MDAR=18'd0;
wire  clk;
assign clk=in_Clock;

always @ (posedge clk)				//Control signals given in posedge, we check them in negedge
begin
	if(TOG == 0)	AWREF <= {AWG, AWT};
	else				AWREF <= {AWT, AWG};
	
	if(TOG_inc)		TOG <= ~TOG;    //Toggle

	if(inc)				d_out <= d_out+1;
	else if(dec)		d_out <= d_out-1;
	else if(reset)		d_out <= 18'd0;
	else
	begin
		case (SEL)
		`adr_matrix_r:						//MDAR is formed by read registers 
			begin
				if(TOG == 0)	d_out <= {ARG, ART};
				else				d_out <= {ART, ARG};
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end

		`adr_matrix_w:						//MDAR is formed by write registers 
			begin
				if(TOG == 0)	d_out <= {AWG, AWT};
				else				d_out <= {AWT, AWG};
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end

		`adr_last8:							//MDAR, last 8 is filled by A 
			begin
				TEMP_MDAR[7:0]   <= A;
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end
		`adr_mid8:							//MDAR, mid 8 is filled by A 
			begin
				TEMP_MDAR[15:8]  <= A;
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end
		`adr_first2:						//MDAR, first 8 is filled by A 
			begin
				TEMP_MDAR[17:16] <= A[1:0];
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end
		`adr_to_mdar:
			begin
				d_out   <= TEMP_MDAR;
				cin_ART     <= 0;
				cin_ARG     <= 0;
				cin_ARG_ref <= 0;
				cin_ART_ref <= 0;
				cin_AWG     <= 0;
				cin_AWT     <= 0;
			end
		`adr_to_ar:
				begin
					cin_ART     <= 1;
					cin_ARG     <= 1;
					cin_ARG_ref <= 0;
					cin_ART_ref <= 0;
					cin_AWG     <= 0;
					cin_AWT     <= 0;
					if(TOG == 0)	
						begin
							d_to_ARG <= TEMP_MDAR[17:9];
							d_to_ART <= TEMP_MDAR[8:0];
						end
					else
						begin
							d_to_ART <= TEMP_MDAR[17:9];
							d_to_ARG <= TEMP_MDAR[8:0];
						end
				end
		`adr_to_aw:
				begin
					cin_ART     <= 0;
					cin_ARG     <= 0;
					cin_ARG_ref <= 0;
					cin_ART_ref <= 0;
					cin_AWG     <= 1;
					cin_AWT     <= 1;
					if(TOG == 0)	
						begin
							d_to_AWG <= TEMP_MDAR[17:9];
							d_to_AWT <= TEMP_MDAR[8:0];
						end
					else
						begin
							d_to_AWT <= TEMP_MDAR[17:9];
							d_to_AWG <= TEMP_MDAR[8:0];
						end
				end
		`adr_to_ar_ref:
				begin
					cin_ART     <= 0;
					cin_ARG     <= 0;
					cin_ARG_ref <= 1;
					cin_ART_ref <= 1;
					cin_AWG     <= 0;
					cin_AWT     <= 0;
					if(TOG == 0)	
						begin
							d_to_ARG <= TEMP_MDAR[17:9];
							d_to_ART <= TEMP_MDAR[8:0];
						end
					else
						begin
							d_to_ART <= TEMP_MDAR[17:9];
							d_to_ARG <= TEMP_MDAR[8:0];
						end
				end
		 `adr_none:
				begin
					cin_ART     <= 0;
					cin_ARG     <= 0;
					cin_ARG_ref <= 0;
					cin_ART_ref <= 0;
					cin_AWG     <= 0;
					cin_AWT     <= 0;
				end
			default:
				begin
					cin_ART     <= 0;
					cin_ARG     <= 0;
					cin_ARG_ref <= 0;
					cin_ART_ref <= 0;
					cin_AWG     <= 0;
					cin_AWT     <= 0;
				end
		endcase
	end
end


endmodule
