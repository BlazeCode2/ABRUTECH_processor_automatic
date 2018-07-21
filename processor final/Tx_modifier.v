module Tx_modifier(
					Tx_tick_retreiver,
					wen_retreiver,
					Tx_tick_Tx,
					wen_Tx,
					end_address,
					address);


input        wen_retreiver;
input        Tx_tick_Tx;
input [17:0] address;
input [17:0] end_address;

output wen_Tx;
output Tx_tick_retreiver;


reg mux_out=0;

//hijack transmit signals when needed

two_way_mux for_wen(
	.data0(wen_retreiver),
	.data1(0),
	.sel(mux_out),
	.result(wen_Tx));

two_way_mux for_tx_tick(
	.data0(Tx_tick_Tx),
	.data1(1),
	.sel(mux_out),
	.result(Tx_tick_retreiver));


always @ (address)
 	begin
 		if((address[17:9] <= end_address[17:9]) & (address[8:0] <=end_address[8:0])) mux_out<=0; //if the address is in range maintain normal transmition
 		else mux_out<=1;  //if address is out of range hijack the 2 wires connecting Tx and retreiver
 	end

endmodule
