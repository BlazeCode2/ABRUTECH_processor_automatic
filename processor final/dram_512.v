module dram_512(address,clock,data,wren,q);

input	[17:0] address;
input	       clock;
input	[7:0]  data;
input	       wren;
output[7:0]  q;

wire [1:0] selector;
wire [7:0] q1,q2,q3,q4;
wire wren1,wren2,wren3,wren4;

parameter DM1=2'b00;
parameter DM2=2'b01;
parameter DM3=2'b10;
parameter DM4=2'b11;

assign selector[1:0]=address[17:16];


dram d1(.address(address[15:0]),.clock(clock),.data(data),.wren(wren1),.q(q1));
dram d2(.address(address[15:0]),.clock(clock),.data(data),.wren(wren2),.q(q2));
dram d3(.address(address[15:0]),.clock(clock),.data(data),.wren(wren3),.q(q3));
dram d4(.address(address[15:0]),.clock(clock),.data(data),.wren(wren4),.q(q4));
dram_out_mux dram_out_mux(.data0x(q1),.data1x(q2),.data2x(q3),.data3x(q4),.sel(selector),.result(q));
dram_wen_sel_decoder dwsd(
	.data(selector),
	.enable(wren),
	.eq0(wren1),
	.eq1(wren2),
	.eq2(wren3),
	.eq3(wren4));

endmodule
