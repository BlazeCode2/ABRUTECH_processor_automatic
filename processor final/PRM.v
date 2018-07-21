`include "define.v"

module PRM(
		PARAM,
		select,
		to_ADR,
		to_JMP,
		to_AWM);

input      [3:0] PARAM;
input      [1:0] select;
output reg [3:0] to_ADR=4'd0;
output reg [3:0] to_JMP=4'd0;
output reg [2:0] to_AWM=2'd0;

always @(*)
  begin
    case(select)
      `prm_none:
          begin
            to_ADR   <= 4'd0;
            to_JMP   <= 4'd0;
            to_AWM   <= 3'd0;
          end
		`prm_adr:
          begin
            to_ADR   <= PARAM;
            to_JMP   <= 4'd0; 
            to_AWM   <= 3'd0;
          end
		`prm_jmp:
          begin
            to_ADR   <= 4'd0;
            to_JMP   <= PARAM;
            to_AWM   <= 3'd0;
          end  
		`prm_add_sub:
          begin
            to_ADR   <= 4'd0;
            to_JMP   <= 4'd0;
            to_AWM   <= PARAM[2:0];
          end          
      default:
          begin
            to_ADR   <= 4'd0;
            to_JMP   <= 4'd0;
            to_AWM   <= 3'd0;
          end
    endcase
  end

endmodule
