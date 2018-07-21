`include "define.v"

module OPR(MIDR,select,ACI,AWM,INC,DEC,din_PC,RST);

input      [7:0] MIDR;
input      [2:0] select;
output reg [7:0] ACI=8'd0;
output reg [7:0] AWM=8'd0;
output reg [7:0] INC=8'd0;
output reg [7:0] DEC=8'd0;
output reg [7:0] din_PC=8'd0;
output reg [7:0] RST=8'd0;

always @(*)
  begin
    case(select)
      `opr_none:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= 8'd0;
            DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
      `opr_awm:
          begin
            ACI    <= 8'd0;
            AWM    <= MIDR;
            INC    <= 8'd0;
				DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
      `opr_aci_awm:
          begin
            ACI    <= {3'd0,MIDR[4:0]};
            AWM    <= {5'd0,MIDR[7:5]};
            INC    <= 8'd0;
				DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
      `opr_inc:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= MIDR;
				DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
      `opr_dec:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= 8'd0;
				DEC    <= MIDR;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
      `opr_pc:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= 8'd0;
				DEC    <= 8'd0;
            din_PC <= MIDR;
            RST    <= 8'd0;
          end
      `opr_rst:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= 8'd0;
				DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= MIDR;
          end
      default:
          begin
            ACI    <= 8'd0;
            AWM    <= 8'd0;
            INC    <= 8'd0;
				DEC    <= 8'd0;
            din_PC <= 8'd0;
            RST    <= 8'd0;
          end
    endcase
  end

endmodule
