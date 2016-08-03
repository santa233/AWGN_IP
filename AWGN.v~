///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			                   AWGN IP core               		         //
//                                  By                                   //
//                        Santosh Kumar Krishnan                         //
//                                                                       //
//                           'TOP' level entity                          //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
/*  Copyright (C) 2016  Santosh Kumar Krishnan

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.*/
	
module AWGN (
clock,
reset,
urng_seed1,
urng_seed2,
urng_seed3,
urng_seed4,
urng_seed5,
urng_seed6,
awgn_out
);

//inputs

//clock
input clock;
//reset signal for inttializing the values of the registers
input reset;
//6 32 bit seeds for Traunsworthe URNG's 
input [31:0] urng_seed1;
input [31:0] urng_seed2;
input [31:0] urng_seed3;
input [31:0] urng_seed4;
input [31:0] urng_seed5;
input [31:0] urng_seed6;
//16 bit AWGN output with 5 integer bits and 11 fraction bits
output [15:0] awgn_out;

//internal registers
reg [16:0] cos_val_d;
reg [31:0] urng0_s0;
reg [31:0] urng0_s1;
reg [31:0] urng0_s2;
reg [31:0] urng1_s0;
reg [31:0] urng1_s1;
reg [31:0] urng1_s2;
reg [31:0] b1;
reg [31:0] b0;
reg state;

//internal signals
wire [31:0] t0_0,t0_1,t0_2,t0_3,t0_4,t0_5;
wire [31:0] t0_6,t0_7,t0_8,t0_9,t0_10,t0_11;
wire [31:0] t0_12,t0_13,t0_14,t0_15,t0_16,t0_17;
wire [31:0] t1_0,t1_1,t1_2,t1_3,t1_4,t1_5;
wire [31:0] t1_6,t1_7,t1_8,t1_9,t1_10,t1_11;
wire [31:0] t1_12,t1_13,t1_14,t1_15,t1_16,t1_17;
wire [15:0] temp_1;
wire [32:0] temp_2;
wire [15:0] temp_3;
wire [16:0] cos_val,cos_val_p2;
wire [30:0] log_e_val;
wire [16:0] sqrt_val;
wire [47:0] u_0;
wire [15:0] u_1;

//combinational part

//combinational logic for URNG0
assign t0_0 = {urng0_s0[31-13:0],13'b0}; 
assign t0_1 = t0_0 ^ urng0_s0;
assign t0_2 = {19'b0,t0_1[31:19]};
assign t0_3 = urng0_s0 & 32'hFFFFFFFE;
assign t0_4 = {t0_3[31-12:0],12'b0};
assign t0_5 = t0_4 ^ t0_2;
assign t0_6 = {urng0_s1[31-2:0],2'b0}; 
assign t0_7 = t0_6 ^ urng0_s1;
assign t0_8 = {25'b0,t0_7[31:25]};
assign t0_9 = urng0_s1 & 32'hFFFFFFF8;
assign t0_10 = {t0_9[31-4:0],4'b0};
assign t0_11 = t0_10 ^ t0_8;
assign t0_12 = {urng0_s2[31-3:0],3'b0}; 
assign t0_13 = t0_12 ^ urng0_s2;
assign t0_14 = {11'b0,t0_13[31:11]};
assign t0_15 = urng0_s2 & 32'hFFFFFFF0;
assign t0_16 = {t0_15[31-17:0],17'b0};
assign t0_17 = t0_16 ^ t0_14; 

//combinational logic for URNG1
assign t1_0 = {urng1_s0[31-13:0],13'b0}; 
assign t1_1 = t1_0 ^ urng1_s0;
assign t1_2 = {19'b0,t1_1[31:19]};
assign t1_3 = urng1_s0 & 32'hFFFFFFFE;
assign t1_4 = {t1_3[31-12:0],12'b0};
assign t1_5 = t1_4 ^ t1_2;
assign t1_6 = {urng1_s1[31-2:0],2'b0}; 
assign t1_7 = t1_6 ^ urng1_s1;
assign t1_8 = {25'b0,t1_7[31:25]};
assign t1_9 = urng1_s1 & 32'hFFFFFFF8;
assign t1_10 = {t1_9[31-4:0],4'b0};
assign t1_11 = t1_10 ^ t1_8;
assign t1_12 = {urng1_s2[31-3:0],3'b0}; 
assign t1_13 = t1_12 ^ urng1_s2;
assign t1_14 = {11'b0,t1_13[31:11]};
assign t1_15 = urng1_s2 & 32'hFFFFFFF0;
assign t1_16 = {t1_15[31-17:0],17'b0};
assign t1_17 = t1_16 ^ t1_14; 

//48 bit u_0 is a combination of URNG0 output and first half word of URNG1
//16 bit u_1 is  the second half word of URNG0
assign u_0 = {b0,b1[31:16]};
assign u_1 = b1[15:0];

//instantiate cosine unit
cosine_module COS(clock,reset,u_1,cos_val);

//instantiate logarithm unit
log_module LOG(clock,reset,u_0,log_e_val);

//instantiate square root unit
sqrt_module SQ_RT(clock,reset,log_e_val,sqrt_val);

//assign signal to output of d ff for cos value
assign cos_val_p2 = cos_val_d;

//multiplication of output square root module and signal from cos module d ff
assign temp_1 = (cos_val_p2[16] == 0)?cos_val_p2[15:0]:(~cos_val_p2[15:0])+1;
assign temp_2 = temp_1 * sqrt_val; 
assign temp_3 = (cos_val_p2[16] == 0)?temp_2[32:17]:(~temp_2[32:17])+1;

//assign the output.
assign awgn_out = temp_3;

//sequential part
always @ (posedge clock)
begin
//reset = 1? then initialize all registers
	if(reset == 1'b1)
	begin
		cos_val_d <= 17'h00000;
		urng0_s0 <= 32'h00000000;
		urng0_s1 <= 32'h00000000;
		urng0_s2 <= 32'h00000000;
		urng1_s0 <= 32'h00000000;
		urng1_s1 <= 32'h00000000;
		urng1_s2 <= 32'h00000000;
		b0 <= 32'h00000000; 
		b1 <= 32'h00000000;
		state <= 2'b00;
	end
//reset = 0? then start
	if(reset == 1'b0)
	begin
//set value of cosine module d ff
		cos_val_d <= cos_val;
		case(state)
//initialize the URNG registers storing the seed values.
		2'b00: begin
			urng0_s0 <= urng_seed1;
			urng0_s1 <= urng_seed2;
			urng0_s2 <= urng_seed3;
			urng1_s0 <= urng_seed4;
			urng1_s1 <= urng_seed5;
			urng1_s2 <= urng_seed6;
			state <= 2'b01;
		end
//update the URNG registers storing the seed values.
		2'b01: begin
			urng0_s0 <= t0_5;
			urng0_s1 <= t0_11;
			urng0_s2 <= t0_17;
			urng1_s0 <= t1_5;
			urng1_s1 <= t1_11;
			urng1_s2 <= t1_17;
//update the URNG0 output register
			b0 <= t0_5 ^ t0_11 ^ t0_17;
//update the URNG1 output register
			b1 <= t1_5 ^ t1_11 ^ t1_17;
//stay in the state
			state <= 2'b01;
		end
		default: state <= 2'b01;
		endcase
	end
end

//end
endmodule