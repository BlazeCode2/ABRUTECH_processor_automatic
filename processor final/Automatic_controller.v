module Automatic_controller(
			clk,
			mode,
			ram_mode,
			p_start,
			tx_start,
			receive_status,
			processor_status,
			tx_status,
			reset,
			idle_mode
);

input clk,receive_status,processor_status,tx_status,reset,idle_mode;

output reg [1:0] mode = 2'b01;
output reg ram_mode   = 1'b1;
output reg tx_start   = 1'b0;
output reg p_start    = 1'b0;

parameter LOAD_INS = 3'b000;
parameter LOAD_DAT = 3'b001;
parameter PROCESS  = 3'b010;
parameter TRANSMIT = 3'b011;
parameter IDLE_INS = 3'b100;
parameter IDLE_DAT = 3'b101;

reg [2:0] STATE = 3'b000;

reg a = 1'b0;
reg b = 1'b0;
reg c = 1'b0;
reg d = 1'b0;
reg e = 1'b0;
reg f = 1'b0;
reg g = 1'b0;
reg h = 1'b0;
reg i = 1'b0;
reg j = 1'b0;

always @(negedge clk)
	case(STATE)
		IDLE_DAT:
			begin
				i        <= reset;
				j        <= i;
				g        <= idle_mode;
				h        <= g;
				ram_mode <= 1'b0;
				if(~g & h) 
					begin
						STATE <= LOAD_DAT;
						mode     <= 2'b01;
					end
				else if(~i & j)
					begin
						STATE    <= IDLE_INS;
						p_start  <= 1'b0;
						mode     <= 2'b00;
					end
			end
		IDLE_INS:
			begin
				g        <= idle_mode;
				h        <= g;
				i        <= reset;
				j        <= i;
				ram_mode <= 1'b1;
				if(~g & h)
					begin	
						STATE <= LOAD_DAT;
						mode     <= 2'b01;
					end
				else if(~i & j)
					begin
						STATE    <= IDLE_DAT;
						p_start  <= 1'b0;
						mode     <= 2'b00;
					end
			end
		LOAD_INS:
			begin
				a        <= receive_status;
				b        <= a;
				c        <= 1'b0;
				d        <= 1'b0;
				e        <= 1'b0;
				f        <= 1'b0;
				mode     <= 2'b01;
				ram_mode <= 1'b1;
				tx_start <= 1'b0;
				p_start  <= 1'b0;
				if(a & ~b)
					STATE <= LOAD_DAT;
			end
		LOAD_DAT:
			begin
				a        <= receive_status;
				b        <= a;
				c        <= 1'b0;
				d        <= 1'b0;
				e        <= 1'b0;
				f        <= 1'b0;
				g        <= idle_mode;
				h        <= g;
				ram_mode <= 1'b0;
				tx_start <= 1'b0;
				if(~reset)
					STATE <= LOAD_INS;
				else if(a & ~b)
					begin
						STATE    <= PROCESS;
						p_start  <= 1'b1;
						mode     <= 2'b10;
					end
				else if(~g & h)
					begin
						STATE    <= IDLE_DAT;
						p_start  <= 1'b0;
						mode     <= 2'b00;
					end
				else
					begin
						p_start  <= 1'b0;
						mode     <= 2'b01;
					end
			end
		PROCESS:
			begin
				c <= processor_status;
				d <= c;
				e        <= 1'b0;
				f        <= 1'b0;
				ram_mode <= 1'b0;
				tx_start <= 1'b0;
				p_start  <= 1'b0;
				if (~c & d)
					begin
						STATE <= TRANSMIT;
						tx_start <= 1'b1;
						mode     <= 2'b11;
					end
				else
					begin
						tx_start <= 1'b0;
						mode     <= 2'b10;
					end
			end
		TRANSMIT:
			begin
				e <= tx_status;
				f <= e;
				c        <= 1'b0;
				d        <= 1'b0;
				ram_mode <= 1'b0;
				tx_start <= 1'b0;
				p_start  <= 1'b0;
				if (e & ~f)
					begin
						STATE <= 2'b01;
						mode     <= 2'b01;
					end
				else mode     <= 2'b11;		
			end
		default:	
			begin
				a        <= 1'b0;
				b        <= 1'b0;
				c        <= 1'b0;
				d        <= 1'b0;
				e        <= 1'b0;
				f        <= 1'b0;
				g        <= 1'b0;
				h        <= 1'b0;
				i        <= 1'b0;
				j        <= 1'b0;
				mode     <= 2'b01;
				ram_mode <= 1'b1;
				tx_start <= 1'b0;
				p_start  <= 1'b0;
				STATE    <= LOAD_INS;
			end
	endcase
endmodule 