module Data_writer(clk,Rx_tick,Din,Wen,Addr,Dout,fin,memory_size);

input        Rx_tick,clk;
input [7:0]  Din;
input [17:0] memory_size;

output reg [17:0] Addr=18'b0;
output reg [7:0]  Dout;
output reg        Wen=1'b0;
output reg        fin=0; 

reg       flag = 0;
reg [1:0] STATE=2'b0;

parameter IDLE=2'b0;
parameter STORING1=2'b01;
parameter STORING2=2'b10;
parameter DONE=2'b11;

always @(posedge clk)
begin
	case(STATE)
		IDLE:
			if(Rx_tick==1)
				begin
					fin<=0;
					Wen<=1;
					Dout<=Din;
					STATE<=STORING2;
				end
		STORING1:
			if(Rx_tick==1)
				begin
					Wen<=1;
					Dout<=Din;
					Addr<=Addr+1;
					STATE<=STORING2;
				end
		STORING2:
			begin
				Wen<=0;
				if(Addr==memory_size) STATE<=DONE;
				else                  STATE<=STORING1;
			end
		DONE:
			begin
			Addr<=0;
			fin<=1;
			Wen<=0;
			STATE<=IDLE;
			end
		default:STATE<=IDLE;
	endcase	
	
end

endmodule
