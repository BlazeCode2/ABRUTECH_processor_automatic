//`include "define.v" 

module RST_decoder(sel, ART, ARG, AWT, AWG, MDAR);

  input [2:0] sel;
  output reg ART, ARG, AWT, AWG, MDAR;

  always @ ( * ) begin
    case (sel)
      `rst_none: begin
        ART <= 1'b0;
        ARG <= 1'b0;
        AWT <= 1'b0;
        AWG <= 1'b0;
        MDAR <= 1'b0;
		end
			
      `rst_ART:	begin
        ART <= 1'b1;
        ARG <= 1'b0;
        AWT <= 1'b0;
        AWG <= 1'b0;
        MDAR <= 1'b0;
		  end

      `rst_ARG:	begin
        ART <= 1'b0;
        ARG <= 1'b1;
        AWT <= 1'b0;
        AWG <= 1'b0;
        MDAR <= 1'b0;
		  end

      `rst_AWT:	begin
        ART <= 1'b0;
        ARG <= 1'b0;
        AWT <= 1'b1;
        AWG <= 1'b0;
        MDAR <= 1'b0;
			end
			
      `rst_AWG:	begin
        ART <= 1'b0;
        ARG <= 1'b0;
        AWT <= 1'b0;
        AWG <= 1'b1;
        MDAR <= 1'b0;
		  end

      `rst_MDAR:	begin
        ART <= 1'b0;
        ARG <= 1'b0;
        AWT <= 1'b0;
        AWG <= 1'b0;
        MDAR <= 1'b1;
		  end

      `rst_all:	begin
        ART <= 1'b1;
        ARG <= 1'b1;
        AWT <= 1'b1;
        AWG <= 1'b1;
        MDAR <= 1'b1;
		  end

      default:	begin
        ART <= 1'b0;
        ARG <= 1'b0;
        AWT <= 1'b0;
        AWG <= 1'b0;
        MDAR <= 1'b0;
		  end
		  
    endcase
    end
endmodule // rstsel, reg_ctrl, clk,
