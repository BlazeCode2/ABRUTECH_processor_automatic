module memory_router(wen,address,din,
										i_wen,i_add,i_din,
										p_wen,p_address,p_din,p_ins_address,
										memory_size_select,rx_wen,rx_address,rx_din,
										tx_address,
										user_address,
										mode,d_or_i);

//iram access ports

output       i_wen;
output [7:0] i_add;
output [7:0] i_din; 


//dram accsess ports


output        wen;
output [7:0]  din;
output [17:0] address;

//Tx ports

input  [17:0] tx_address;

//Rx ports

input             rx_wen;
input      [17:0] rx_address;
input      [7:0]  rx_din;
output reg [17:0] memory_size_select=18'd262143;

//processor ports

input         p_wen;
input  [17:0] p_address;
input  [7:0]  p_din;
input  [7:0]  p_ins_address;


//user ports

input [17:0] user_address;

//mode selector for 4 modes

input [1:0] mode;

//instruction mode or data mode

input d_or_i;



//splitter wiring

wire d_out_wen;
wire [7:0] d_out_din;
wire [17:0] d_out_d_address;
wire [17:0] i_out_i_address;
wire [17:0] i_out_i_user_address;
wire [17:0] d_out_d_user_address;

D_Wen_mux D_Wen_mux (
						.data0(0),
						.data1(d_out_wen),
						.data2(p_wen),
						.data3(0),
						.sel(mode),
						.result(wen));
						
D_Address_mux  D_Address_mux (
						.data0x(d_out_d_user_address),
						.data1x(d_out_d_address),
						.data2x(p_address),
						.data3x(tx_address),
						.sel(mode),
						.result(address));
						
I_Address_mux	I_Address_mux (
						.data0x(i_out_i_user_address[7:0]),
						.data1x(i_out_i_address),
						.data2x(p_ins_address),
						.data3x(8'd0),
						.sel(mode),
						.result(i_add));
											

din_mux din_mux (
						.data0x(8'd0),
						.data1x(d_out_din),
						.data2x(p_din),
						.data3x(8'd0),
						.sel(mode),
						.result(din));	


splitter #(.bit_width(1)) wen_split (
						.in(rx_wen),
						.d_out(d_out_wen),
						.i_out(i_wen),
						.enable(((~mode[1])&(mode[0]))), //in Rx operation mode
						.selector(d_or_i));

splitter #(.bit_width(8)) din_split (
						.in(rx_din),
						.d_out(d_out_din),
						.i_out(i_din),
						.enable(((~mode[1])&(mode[0]))), //in Rx operation mode
						.selector(d_or_i));
						
splitter #(.bit_width(18)) address_split (
						.in(rx_address),
						.d_out(d_out_d_address),
						.i_out(i_out_i_address),
						.enable(((~mode[1])&(mode[0]))),  //in Rx operation mode
						.selector(d_or_i));

splitter #(.bit_width(18)) user_address_split (
						.in(user_address),
						.d_out(d_out_d_user_address),
						.i_out(i_out_i_user_address),
						.enable(((~mode[1])&(~mode[0]))), //in IDLE operation mode
						.selector(d_or_i));
						
						
always @(d_or_i)
	begin
		case(d_or_i)
			0:memory_size_select<=18'd262143;
			1:memory_size_select<=18'd255;
			default:memory_size_select<=18'd262143;
		endcase
	end
						
endmodule
