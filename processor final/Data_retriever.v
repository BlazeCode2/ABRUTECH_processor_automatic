module Data_retriever(clk,addr,wen_Tx,fin,start,Tx_tick_from_tx,end_add);

input        clk,Tx_tick_from_tx,start;
input [17:0] end_add;

output reg [17:0] addr=18'b0;
output            wen_Tx;
output reg        fin=0;

reg       wen=0;
reg [1:0] STATE=2'b00;
reg       a=1;
reg       b=1;
wire      Tx_tick;

parameter IDLE=2'b0;
parameter TRANSMITTING=2'b01;
parameter DONE=2'b10;


Tx_modifier  Tx_modifier(
					.Tx_tick_retreiver(Tx_tick),
					.wen_retreiver(wen),
					.Tx_tick_Tx(Tx_tick_from_tx),
					.wen_Tx(wen_Tx),
					.end_address(end_add), //change this inorder to SEND different sizes of images   .put "end_add"/18'b111111111111111111 in brackets
					.address(addr)
					);

					

always @(posedge clk)
 case(STATE)
	 IDLE:
		begin
			addr<=18'b0;
			if (start)
				begin
					fin<=0;
					STATE<=TRANSMITTING;
				end
		end
	 TRANSMITTING:
		begin
			wen<=1;
			if (addr==18'd262143 )
				begin
					STATE<=DONE;
				end
			else if(Tx_tick==1)
				begin
					addr<=addr+1;
				end
		end
	 DONE:
			if(Tx_tick==1)
				begin
					STATE<=IDLE;
					fin<=1;
					wen<=0;
				end
	 default: STATE<=IDLE;
 endcase
 
endmodule
