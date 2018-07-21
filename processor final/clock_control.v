module clock_control(
					in_clock, //50MHz
					sel,
					mode,
					manual,
					out_clock  //10MHz,1Hz,Manual,25MHz
);

input       in_clock;
input       manual;   
input [1:0] mode,sel;

output      out_clock;

reg   [1:0] select=2'd0;

wire _1MHz,_10MHz,_25MHz;

parameter _10mhz=2'b00;
parameter _1hz=2'b01;
parameter _manual=2'b10;
parameter _25mhz=2'b11;

//Selects the needed clock to give out

four_way_mux four_way_mux(
 			.data0(_10MHz),
			.data1(_1Hz),
			.data2(manual),
			.data3(_25MHz),
			.sel(select),
			.result(out_clock));

//Convert 10MHz clock to 1Hz clock						
						
clock_divider _10MHz_to_1Hz(
			.inclk(_10MHz),
			.ena(1),
			.clk(_1Hz));
			
//Convert 50MHz clock to 10MHz clock	
			
pll _50MHz_to_10MHz(
	.inclk0(in_clock),
	.c0(_10MHz));
	
//Convert 50MHz clock to 25MHz clock	
	
pll_25mhz _50MHz_to_25MHz(
	.inclk0(in_clock),
	.c0(_25MHz));
			
always @(in_clock)
	begin
	   if(mode==2'b10) //processor mode
	   	    begin
	   			case (sel) 
	   				  _10mhz :  select<=2'b00; 
	   				  _1hz   :  select<=2'b01;
	   				  _manual:  select<=2'b10;
	   				  _25mhz :  select<=2'b11; 
	   				  default:  select<=2'b00;
	   			endcase
	   		end
	   	else select<=2'd0; //any other mode use 10MHz clock
	end

endmodule
