module top_level_module(hex7,hex6,hex5,hex4,hex3,hex2,hex1,hex0,user_addr_control, write_done,
							in_Clock, rx_serial,
							manual_clk,clk_mode, tx_serial, retrieve_done, tx_active,
							processor_status,iram_output,
							test_wire,
							reset_processor,idle_button
							);
input idle_button;
input reset_processor;         //Reset Processor to load intructions again
input in_Clock;                //50Mhz clock(original clock)
input rx_serial;               //receiving serial line
input manual_clk;              //key0    manual clock button
input clk_mode;                //key1    clock mode selection button to select 10MHz|1Hz|manual|25MHz
input [17:0]user_addr_control; //address bus to 18 switches

output write_done;             //LEDR0 to indicate Memory storage from Rx is done
output tx_serial;              //transmission serial line
output retrieve_done;		    //LEDR2 to indicate transmission from Tx is done
output tx_active; 				 //LEDR1 to indicate Tx status(lit means transmitting)
output processor_status; 		 //LEDG7 indicates processor status(busy or not)
output [6:0]hex7; 				 //seven segment display(SSD) indicates current mode of operation
output [6:0]hex6;					 //seven segment display(SSD) indicates Selected ram D_ram|I_ram
output [6:0]hex5;					 //2 (SSDs) indicates Current state of state machine
output [6:0]hex4;              
output [6:0]hex3;					 //seven segment display(SSD) indicates current clock speed when processing 10MHz|1Hz|manual|25MHz
output [6:0]hex2;  				 //3 SSDs indicates the current dram memory output
output [6:0]hex1;
output [6:0]hex0;
output [7:0]iram_output;       //also wired to RLED17-RLED10
output [6:0]test_wire;			 //GLED3-GLED0 => 4LSB of AWT | GLED6-GLED4 => 3LSB of AWG



//processor related wires

wire        processor_en;		//processor starts when this is low
wire [7:0]  SM_STATE;         //Current state of the state machine (goes to 2 SSDs)
wire [17:0] ADR_p_Tx;         //bus sending the address, the transmitter use as reference

//Tx related wires

wire       tx_tick_wire;            
wire       retrieve_enable;     //to activate the Tx through data retreiver
wire[17:0] retriver_EXSM_addr;
wire       retrieve_image;      //wire giving signal to start transmitting image to pc

//Rx related wires

wire        rx_tick_wire ;
wire [7:0]  uart_to_writer_data;//wire connecting Rx byte and writer data_in
wire [7:0]  writer_to_ram_data; //wire connecting D_ram_din and writer data_in
wire [17:0] writer_to_ram_addr; //wire carrying the address to be written , to D_ram

//Debounced button outputs

wire        manual_clk_debounced;
wire        clk_mode_debounced;
wire        reset_processor_debounced;
wire        idle_button_debounced;

//Dram related wires

wire        ram_write_enable;  //wire connecting EXSM and write enable of D_ram
wire [17:0] dram_address_bus;  //wire connecting EXSM and address bus of D_ram
wire [7:0]  dram_EXSM_din;     //wire connecting EXSM and din of D_ram
wire [7:0]  dram_dout;         //wire connected to dout of D_ram

//Iram related wires

wire [7:0]  iram_p_dout;       //I_ram dout connects only to processor
wire [7:0]  iram_EXSM_din;     //wire connecting EXSM and din of D_ram
wire [7:0]  iram_address_bus;  //wire connecting EXSM and address bus of I_ram
wire        iram_write_enable; //wire connecting EXSM and write enable of I_ram

//Memory router related wires

wire        writer_EXSM_wen;   //For writer to access wen of Dram/Iram
wire        p_EXSM_wen;        //For processor to access wen of Dram
wire [7:0]  p_EXSM_din;        //For processor to access din of Dram
wire [17:0] p_EXSM_address;    //For processor to access address of Dram
wire [7:0]  p_EXSM_ins_address;//For processor to access address of Iram
wire [17:0] mem_size;          //wire sending the size of memory locations to be written by writer 255 or 262143


//clock related wires 
 
wire      clk;                 //this wire goes to everything
reg [1:0] CLOCK_MODE=2'd0;     //state of this decide the clock given when processing 10MHz|1Hz|manual|25MHz

//mode of operations and ram selection

wire [1:0] STATE;              //state of this decide the mode of operation IDLE|Rx|Process|Tx
wire       DATA_INS;           //state of this decide the Ram to be used when writing Dram|Iram
wire[6:0] hex;                 //erase (not used(a dummy wire))




//SSD to display current mode of operation/Ram using/clock mode

decoder mode_out(
			.din({2'd0,STATE}),
			.dout(hex7));
			
decoder d_or_i_disp(
			.din({3'd0,DATA_INS}),
			.dout(hex6)); 
			
decoder clk_mode_disp(
			.din({2'd0,CLOCK_MODE}),
			.dout(hex3));

//processor instantiation


processor Processor(
			.clock(clk),
			.D_address(p_EXSM_address),
			.D_din(p_EXSM_din),
			.D_dout(dram_dout),
			.D_wen(p_EXSM_wen),
			.p_enable(processor_en),
			.I_dout(iram_p_dout),
			.I_address(p_EXSM_ins_address),
			.status(processor_status),//processor busy or not
			.STATE(SM_STATE),        //current state of state machine
			.ADR_to_Tx(ADR_p_Tx));   //reference address to Tx


//Module connecting Rx and Memory

Data_writer writer(
			.Rx_tick(rx_tick_wire), 
			.Din(uart_to_writer_data),
			.Dout(writer_to_ram_data), 
			.Addr(writer_to_ram_addr),
			.fin(write_done),
			.clk(clk), 
			.Wen(writer_EXSM_wen),
			.memory_size(mem_size));

//Uart receiver

uart_rx reciever(
			.clk(clk), 
			.i_Rx_Serial(rx_serial), 
			.o_Rx_DV(rx_tick_wire),
			.o_Rx_Byte(uart_to_writer_data));

//Module to convert 8 bit number to 3 digit decimal number

bi2bcd bcd(
			.din(dram_dout),
			.dout2(hex2),
			.dout1(hex1),
			.dout0(hex0));
			
bi2bcd SM_st(
			.din(SM_STATE),
			.dout2(hex),
			.dout1(hex5),
			.dout0(hex4));


//18bit address Dram	 ** here it's instantiated to respond to neg edge on clk  **

dram_512 data_ram(
			.data(dram_EXSM_din),
			.address(dram_address_bus),
			.q(dram_dout),
			.clock(~clk),            //made ram negative edge sensitive
			.wren(ram_write_enable));

//8bit address Iram	 ** here it's instantiated to respond to neg edge on clk  **

iram IRAM(
			.address(iram_address_bus),
			.clock(~clk),           //made ram negative edge sensitive
			.data(iram_EXSM_din),
			.wren(iram_write_enable),
			.q(iram_p_dout));

//Module connecting Memory and uart Tx

Data_retriever retriever(
			.start(retrieve_image), //start transmition 
			.Tx_tick_from_tx(tx_tick_wire),
			.addr(retriver_EXSM_addr),
			.fin(retrieve_done),    //to indicate transmission done
			.wen_Tx(retrieve_enable),
			.clk(clk),
			.end_add(ADR_p_Tx));    //reference address to transmit

//Uart Tx

uart_tx transmitter(
			.i_Clock(clk), 
			.i_Tx_DV(retrieve_enable),
			.i_Tx_Byte(dram_dout), 
			.o_Tx_Serial(tx_serial),
			.o_Tx_Done(tx_tick_wire), 
			.o_Tx_Active(tx_active));


//Memory router to map memory ports to required users in different modes of operations

memory_router EXSM(
			.wen(ram_write_enable),.address(dram_address_bus),.din(dram_EXSM_din),                       //Dram related ports
			.i_wen(iram_write_enable),.i_add(iram_address_bus),.i_din(iram_EXSM_din),                    //Iram related ports
			.p_wen(p_EXSM_wen),.p_address(p_EXSM_address),.p_din(p_EXSM_din),.p_ins_address(p_EXSM_ins_address), //processor related ports
			.memory_size_select(mem_size),.rx_wen(writer_EXSM_wen),.rx_address(writer_to_ram_addr),.rx_din(writer_to_ram_data),       //Rx related ports
			.tx_address(retriver_EXSM_addr),                                                             //Tx related ports
			.user_address(user_addr_control),                                                            //user access related ports
			.mode(STATE),.d_or_i(DATA_INS) );                                                            //mode of operation/ram select related ports

//Automatic_controller

Automatic_controller Auto(
			.clk(clk),
			.mode(STATE),
			.ram_mode(DATA_INS),
			.p_start(processor_en),
			.tx_start(retrieve_image),
			.receive_status(write_done),
			.processor_status(processor_status),
			.tx_status(retrieve_done),
			.reset(reset_processor_debounced),
			.idle_mode(idle_button_debounced));


//clock mux

clock_control clk_cntrl(
			.in_clock(in_Clock),   //50MHz clock in
			.sel(CLOCK_MODE),      
			.mode(STATE),
			.manual(manual_clk_debounced), //debounced manual clock wire in
			.out_clock(clk)        //10MHz,1Hz,Manual,25MHz
			);


//Debouncing the push buttons (uses 50MHz clock)

debouncer   idler(
			.button_in(idle_button),
			.button_out(idle_button_debounced),
			.clk(in_Clock));
			
debouncer   rst(
			.button_in(reset_processor),
			.button_out(reset_processor_debounced),
			.clk(in_Clock));
			
debouncer   clock_mode_button(
			.button_in(clk_mode),
			.button_out(clk_mode_debounced),
			.clk(in_Clock));
			
debouncer   manual_clock(
			.button_in(manual_clk),
			.button_out(manual_clk_debounced),
			.clk(in_Clock));
   



assign iram_output=iram_p_dout;
assign test_wire[6:4]=ADR_p_Tx[11:9];
assign test_wire[3:0]=ADR_p_Tx[3:0];



//update clock mode per button pressed in correct mode(any(but affects only in processor mode))
		
always @(negedge clk_mode_debounced)
		begin
			CLOCK_MODE<=CLOCK_MODE+1;
		end

endmodule
