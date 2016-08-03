///////////////////////////////////////////////////////////////////////////
//                                              __                       //
//			             Square root module [ \/x  ]                     //
//                                  By                                   //
//                        Santosh Kumar Krishnan                         //
//                                                                       //
//                         'TOP - 1' level entity                        //
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
	
module sqrt_module (
clock,
reset,
num,
value);

//input
input clock; 
input reset;
input [30:0] num;

//output
output [16:0] value;

//internal registers
reg [18:0] sqrt_1_2_c_0[63:0];
reg [17:0] sqrt_1_2_c_1[63:0];
reg [18:0] sqrt_2_4_c_0[63:0];
reg [17:0] sqrt_2_4_c_1[63:0];
reg [18:0] c_0_1_2,c_0_2_4;
reg [17:0] c_1_1_2,c_1_2_4;
reg [5:0] expo_sqrt_d;
reg sqrt_sign_d;
reg [25:0] corrected_value_d;
reg even_odd_d;

//internal signals
wire [18:0] c_0;
wire [17:0] c_1; 
wire [5:0] zeros;
wire [6:0] expo;
wire [6:0] expo_1;
wire [5:0] expo_sqrt,expo_sqrt_p2;
wire sqrt_sign,sqrt_sign_p2;
wire left_or_right;
wire [25:0] corrected_value_t;
wire [25:0] corrected_value,corrected_value_p2;
wire [5:0] to_barrel_shifter;
wire [5:0] to_barrel_shifter_sq;
wire [47:0] from_left_shift;
wire [47:0] from_right_shift; 
wire [47:0] from_left_shift_sq;
wire [47:0] from_right_shift_sq; 
wire [5:0] table_address_1_2,table_address_2_4;
wire [37:0] temp1;
wire [20:0] temp2;
wire even_odd,even_odd_p2;

//combinational logic

//instantiate 32 bit leading zero detector
LZD_32 L_32_sqrt({1'b0,num},zeros);

//instantiate 48 bit left barrel shifter
barrel_shifter_48 B_S_48_left({17'h00000,num},to_barrel_shifter,from_left_shift);

////instantiate 48 bit right barrel shifter
barrel_shifter_48_right B_S_48_right({17'h00000,num},to_barrel_shifter,from_right_shift);

//instantiate 48 bit left barrel shifter
barrel_shifter_48 B_S_48_left_sq({30'h00000000,temp2[20:3]},to_barrel_shifter_sq,from_left_shift_sq);

////instantiate 48 bit right barrel shifter
barrel_shifter_48_right B_S_48_right_sq({30'h00000000,temp2[20:3]},to_barrel_shifter_sq,from_right_shift_sq);

//combinational logic

//get exponent 
assign expo = 7'b0000101 - zeros + 1;

//whether to left shift or right shift number.
assign left_or_right = (expo[6] == 1)?1:0;
assign to_barrel_shifter = (left_or_right == 1)? (~expo[5:0]) +1 : expo[5:0];

//obtain the shifted value from either the left shifter or the right shifter 
//the shifted value now lies in the range of [2,4)
assign corrected_value_t = (left_or_right == 1)?from_left_shift[25:0]:from_right_shift[25:0];

//is the exponent odd? if so then increment exponent by 1 else leave it as it is.
assign even_odd = expo[0];
assign expo_1 = expo + 1;
assign sqrt_sign = expo_sqrt[5];
assign expo_sqrt = (even_odd == 0)?{expo[6],expo[5:1]}:{expo_1[6],expo_1[5:1]};

//is the exponent odd? if so then right shift the shifted value obtained by 1.
assign corrected_value = (even_odd == 1)?{1'b0,corrected_value_t[25:1]}:corrected_value_t;

//get the address of the coefficient table
assign table_address_1_2 = corrected_value[23:18];
assign table_address_2_4 = corrected_value[24:19];

//assign signals to respective dff values
assign corrected_value_p2 = corrected_value_d;
assign expo_sqrt_p2 = expo_sqrt_d;
assign sqrt_sign_p2 = sqrt_sign_d;
assign even_odd_p2 = even_odd_d;

//evaluate the piecewise polynomial
assign c_0 = (even_odd_p2 == 1)?c_0_1_2:c_0_2_4;
assign c_1 = (even_odd_p2 == 1)?c_1_1_2:c_1_2_4;
assign temp1 = c_1*corrected_value_p2[25:6];
assign temp2 = temp1[37:17] + c_0;

//shift the result left or right depending on whether the exponent is positive or negative.
assign to_barrel_shifter_sq = (sqrt_sign_p2 == 1)? (~expo_sqrt_p2[5:0]) +1 : expo_sqrt_p2[5:0];
assign value = (sqrt_sign_p2 == 0)?from_left_shift_sq[19:3]:from_right_shift_sq[19:3];

//sequential logic

always@(posedge clock)
begin
//reset = 1? initialize all  registers
	if(reset == 1'b1)
	begin
		
		corrected_value_d = 26'h0;
		expo_sqrt_d = 6'h0;
		sqrt_sign_d = 1'b0;
		even_odd_d = 1'b0;
		
		c_0_1_2 = 19'h0;
		c_1_1_2 = 18'h0;
		c_0_2_4 = 19'h0;
		c_1_2_4 = 18'h0;
		
		sqrt_1_2_c_0[0] = 19'h0;
		sqrt_1_2_c_0[1] = 19'h0;
		sqrt_1_2_c_0[2] = 19'h0;
		sqrt_1_2_c_0[3] = 19'h0;
		sqrt_1_2_c_0[4] = 19'h0;
		sqrt_1_2_c_0[5] = 19'h0;
		sqrt_1_2_c_0[6] = 19'h0;
		sqrt_1_2_c_0[7] = 19'h0;
		sqrt_1_2_c_0[8] = 19'h0;
		sqrt_1_2_c_0[9] = 19'h0;
		sqrt_1_2_c_0[10] = 19'h0;
		sqrt_1_2_c_0[11] = 19'h0;
		sqrt_1_2_c_0[12] = 19'h0;
		sqrt_1_2_c_0[13] = 19'h0;
		sqrt_1_2_c_0[14] = 19'h0;
		sqrt_1_2_c_0[15] = 19'h0;
		sqrt_1_2_c_0[16] = 19'h0;
		sqrt_1_2_c_0[17] = 19'h0;
		sqrt_1_2_c_0[18] = 19'h0;
		sqrt_1_2_c_0[19] = 19'h0;
		sqrt_1_2_c_0[20] = 19'h0;
		sqrt_1_2_c_0[21] = 19'h0;
		sqrt_1_2_c_0[22] = 19'h0;
		sqrt_1_2_c_0[23] = 19'h0;
		sqrt_1_2_c_0[24] = 19'h0;
		sqrt_1_2_c_0[25] = 19'h0;
		sqrt_1_2_c_0[26] = 19'h0;
		sqrt_1_2_c_0[27] = 19'h0;
		sqrt_1_2_c_0[28] = 19'h0;
		sqrt_1_2_c_0[29] = 19'h0;
		sqrt_1_2_c_0[30] = 19'h0;
		sqrt_1_2_c_0[31] = 19'h0;
		sqrt_1_2_c_0[32] = 19'h0;
		sqrt_1_2_c_0[33] = 19'h0;
		sqrt_1_2_c_0[34] = 19'h0;
		sqrt_1_2_c_0[35] = 19'h0;
		sqrt_1_2_c_0[36] = 19'h0;
		sqrt_1_2_c_0[37] = 19'h0;
		sqrt_1_2_c_0[38] = 19'h0;
		sqrt_1_2_c_0[39] = 19'h0;
		sqrt_1_2_c_0[40] = 19'h0;
		sqrt_1_2_c_0[41] = 19'h0;
		sqrt_1_2_c_0[42] = 19'h0;
		sqrt_1_2_c_0[43] = 19'h0;
		sqrt_1_2_c_0[44] = 19'h0;
		sqrt_1_2_c_0[45] = 19'h0;
		sqrt_1_2_c_0[46] = 19'h0;
		sqrt_1_2_c_0[47] = 19'h0;
		sqrt_1_2_c_0[48] = 19'h0;
		sqrt_1_2_c_0[49] = 19'h0;
		sqrt_1_2_c_0[50] = 19'h0;
		sqrt_1_2_c_0[51] = 19'h0;
		sqrt_1_2_c_0[52] = 19'h0;
		sqrt_1_2_c_0[53] = 19'h0;
		sqrt_1_2_c_0[54] = 19'h0;
		sqrt_1_2_c_0[55] = 19'h0;
		sqrt_1_2_c_0[56] = 19'h0;
		sqrt_1_2_c_0[57] = 19'h0;
		sqrt_1_2_c_0[58] = 19'h0;
		sqrt_1_2_c_0[59] = 19'h0;
		sqrt_1_2_c_0[60] = 19'h0;
		sqrt_1_2_c_0[61] = 19'h0;
		sqrt_1_2_c_0[62] = 19'h0;
		sqrt_1_2_c_0[63] = 19'h0;
		 
		 
		sqrt_1_2_c_1[0] = 18'h0;
		sqrt_1_2_c_1[1] = 18'h0;
		sqrt_1_2_c_1[2] = 18'h0;
		sqrt_1_2_c_1[3] = 18'h0;
		sqrt_1_2_c_1[4] = 18'h0;
		sqrt_1_2_c_1[5] = 18'h0;
		sqrt_1_2_c_1[6] = 18'h0;
		sqrt_1_2_c_1[7] = 18'h0;
		sqrt_1_2_c_1[8] = 18'h0;
		sqrt_1_2_c_1[9] = 18'h0;
		sqrt_1_2_c_1[10] = 18'h0;
		sqrt_1_2_c_1[11] = 18'h0;
		sqrt_1_2_c_1[12] = 18'h0;
		sqrt_1_2_c_1[13] = 18'h0;
		sqrt_1_2_c_1[14] = 18'h0;
		sqrt_1_2_c_1[15] = 18'h0;
		sqrt_1_2_c_1[16] = 18'h0;
		sqrt_1_2_c_1[17] = 18'h0;
		sqrt_1_2_c_1[18] = 18'h0;
		sqrt_1_2_c_1[19] = 18'h0;
		sqrt_1_2_c_1[20] = 18'h0;
		sqrt_1_2_c_1[21] = 18'h0;
		sqrt_1_2_c_1[22] = 18'h0;
		sqrt_1_2_c_1[23] = 18'h0;
		sqrt_1_2_c_1[24] = 18'h0;
		sqrt_1_2_c_1[25] = 18'h0;
		sqrt_1_2_c_1[26] = 18'h0;
		sqrt_1_2_c_1[27] = 18'h0;
		sqrt_1_2_c_1[28] = 18'h0;
		sqrt_1_2_c_1[29] = 18'h0;
		sqrt_1_2_c_1[30] = 18'h0;
		sqrt_1_2_c_1[31] = 18'h0;
		sqrt_1_2_c_1[32] = 18'h0;
		sqrt_1_2_c_1[33] = 18'h0;
		sqrt_1_2_c_1[34] = 18'h0;
		sqrt_1_2_c_1[35] = 18'h0;
		sqrt_1_2_c_1[36] = 18'h0;
		sqrt_1_2_c_1[37] = 18'h0;
		sqrt_1_2_c_1[38] = 18'h0;
		sqrt_1_2_c_1[39] = 18'h0;
		sqrt_1_2_c_1[40] = 18'h0;
		sqrt_1_2_c_1[41] = 18'h0;
		sqrt_1_2_c_1[42] = 18'h0;
		sqrt_1_2_c_1[43] = 18'h0;
		sqrt_1_2_c_1[44] = 18'h0;
		sqrt_1_2_c_1[45] = 18'h0;
		sqrt_1_2_c_1[46] = 18'h0;
		sqrt_1_2_c_1[47] = 18'h0;
		sqrt_1_2_c_1[48] = 18'h0;
		sqrt_1_2_c_1[49] = 18'h0;
		sqrt_1_2_c_1[50] = 18'h0;
		sqrt_1_2_c_1[51] = 18'h0;
		sqrt_1_2_c_1[52] = 18'h0;
		sqrt_1_2_c_1[53] = 18'h0;
		sqrt_1_2_c_1[54] = 18'h0;
		sqrt_1_2_c_1[55] = 18'h0;
		sqrt_1_2_c_1[56] = 18'h0;
		sqrt_1_2_c_1[57] = 18'h0;
		sqrt_1_2_c_1[58] = 18'h0;
		sqrt_1_2_c_1[59] = 18'h0;
		sqrt_1_2_c_1[60] = 18'h0;
		sqrt_1_2_c_1[61] = 18'h0;
		sqrt_1_2_c_1[62] = 18'h0;
		sqrt_1_2_c_1[63] = 18'h0;
		 
		 
		sqrt_2_4_c_0[0] = 19'h0;
		sqrt_2_4_c_0[1] = 19'h0;
		sqrt_2_4_c_0[2] = 19'h0;
		sqrt_2_4_c_0[3] = 19'h0;
		sqrt_2_4_c_0[4] = 19'h0;
		sqrt_2_4_c_0[5] = 19'h0;
		sqrt_2_4_c_0[6] = 19'h0;
		sqrt_2_4_c_0[7] = 19'h0;
		sqrt_2_4_c_0[8] = 19'h0;
		sqrt_2_4_c_0[9] = 19'h0;
		sqrt_2_4_c_0[10] = 19'h0;
		sqrt_2_4_c_0[11] = 19'h0;
		sqrt_2_4_c_0[12] = 19'h0;
		sqrt_2_4_c_0[13] = 19'h0;
		sqrt_2_4_c_0[14] = 19'h0;
		sqrt_2_4_c_0[15] = 19'h0;
		sqrt_2_4_c_0[16] = 19'h0;
		sqrt_2_4_c_0[17] = 19'h0;
		sqrt_2_4_c_0[18] = 19'h0;
		sqrt_2_4_c_0[19] = 19'h0;
		sqrt_2_4_c_0[20] = 19'h0;
		sqrt_2_4_c_0[21] = 19'h0;
		sqrt_2_4_c_0[22] = 19'h0;
		sqrt_2_4_c_0[23] = 19'h0;
		sqrt_2_4_c_0[24] = 19'h0;
		sqrt_2_4_c_0[25] = 19'h0;
		sqrt_2_4_c_0[26] = 19'h0;
		sqrt_2_4_c_0[27] = 19'h0;
		sqrt_2_4_c_0[28] = 19'h0;
		sqrt_2_4_c_0[29] = 19'h0;
		sqrt_2_4_c_0[30] = 19'h0;
		sqrt_2_4_c_0[31] = 19'h0;
		sqrt_2_4_c_0[32] = 19'h0;
		sqrt_2_4_c_0[33] = 19'h0;
		sqrt_2_4_c_0[34] = 19'h0;
		sqrt_2_4_c_0[35] = 19'h0;
		sqrt_2_4_c_0[36] = 19'h0;
		sqrt_2_4_c_0[37] = 19'h0;
		sqrt_2_4_c_0[38] = 19'h0;
		sqrt_2_4_c_0[39] = 19'h0;
		sqrt_2_4_c_0[40] = 19'h0;
		sqrt_2_4_c_0[41] = 19'h0;
		sqrt_2_4_c_0[42] = 19'h0;
		sqrt_2_4_c_0[43] = 19'h0;
		sqrt_2_4_c_0[44] = 19'h0;
		sqrt_2_4_c_0[45] = 19'h0;
		sqrt_2_4_c_0[46] = 19'h0;
		sqrt_2_4_c_0[47] = 19'h0;
		sqrt_2_4_c_0[48] = 19'h0;
		sqrt_2_4_c_0[49] = 19'h0;
		sqrt_2_4_c_0[50] = 19'h0;
		sqrt_2_4_c_0[51] = 19'h0;
		sqrt_2_4_c_0[52] = 19'h0;
		sqrt_2_4_c_0[53] = 19'h0;
		sqrt_2_4_c_0[54] = 19'h0;
		sqrt_2_4_c_0[55] = 19'h0;
		sqrt_2_4_c_0[56] = 19'h0;
		sqrt_2_4_c_0[57] = 19'h0;
		sqrt_2_4_c_0[58] = 19'h0;
		sqrt_2_4_c_0[59] = 19'h0;
		sqrt_2_4_c_0[60] = 19'h0;
		sqrt_2_4_c_0[61] = 19'h0;
		sqrt_2_4_c_0[62] = 19'h0;
		sqrt_2_4_c_0[63] = 19'h0;
		 
		 
		sqrt_2_4_c_1[0] = 18'h0;
		sqrt_2_4_c_1[1] = 18'h0;
		sqrt_2_4_c_1[2] = 18'h0;
		sqrt_2_4_c_1[3] = 18'h0;
		sqrt_2_4_c_1[4] = 18'h0;
		sqrt_2_4_c_1[5] = 18'h0;
		sqrt_2_4_c_1[6] = 18'h0;
		sqrt_2_4_c_1[7] = 18'h0;
		sqrt_2_4_c_1[8] = 18'h0;
		sqrt_2_4_c_1[9] = 18'h0;
		sqrt_2_4_c_1[10] = 18'h0;
		sqrt_2_4_c_1[11] = 18'h0;
		sqrt_2_4_c_1[12] = 18'h0;
		sqrt_2_4_c_1[13] = 18'h0;
		sqrt_2_4_c_1[14] = 18'h0;
		sqrt_2_4_c_1[15] = 18'h0;
		sqrt_2_4_c_1[16] = 18'h0;
		sqrt_2_4_c_1[17] = 18'h0;
		sqrt_2_4_c_1[18] = 18'h0;
		sqrt_2_4_c_1[19] = 18'h0;
		sqrt_2_4_c_1[20] = 18'h0;
		sqrt_2_4_c_1[21] = 18'h0;
		sqrt_2_4_c_1[22] = 18'h0;
		sqrt_2_4_c_1[23] = 18'h0;
		sqrt_2_4_c_1[24] = 18'h0;
		sqrt_2_4_c_1[25] = 18'h0;
		sqrt_2_4_c_1[26] = 18'h0;
		sqrt_2_4_c_1[27] = 18'h0;
		sqrt_2_4_c_1[28] = 18'h0;
		sqrt_2_4_c_1[29] = 18'h0;
		sqrt_2_4_c_1[30] = 18'h0;
		sqrt_2_4_c_1[31] = 18'h0;
		sqrt_2_4_c_1[32] = 18'h0;
		sqrt_2_4_c_1[33] = 18'h0;
		sqrt_2_4_c_1[34] = 18'h0;
		sqrt_2_4_c_1[35] = 18'h0;
		sqrt_2_4_c_1[36] = 18'h0;
		sqrt_2_4_c_1[37] = 18'h0;
		sqrt_2_4_c_1[38] = 18'h0;
		sqrt_2_4_c_1[39] = 18'h0;
		sqrt_2_4_c_1[40] = 18'h0;
		sqrt_2_4_c_1[41] = 18'h0;
		sqrt_2_4_c_1[42] = 18'h0;
		sqrt_2_4_c_1[43] = 18'h0;
		sqrt_2_4_c_1[44] = 18'h0;
		sqrt_2_4_c_1[45] = 18'h0;
		sqrt_2_4_c_1[46] = 18'h0;
		sqrt_2_4_c_1[47] = 18'h0;
		sqrt_2_4_c_1[48] = 18'h0;
		sqrt_2_4_c_1[49] = 18'h0;
		sqrt_2_4_c_1[50] = 18'h0;
		sqrt_2_4_c_1[51] = 18'h0;
		sqrt_2_4_c_1[52] = 18'h0;
		sqrt_2_4_c_1[53] = 18'h0;
		sqrt_2_4_c_1[54] = 18'h0;
		sqrt_2_4_c_1[55] = 18'h0;
		sqrt_2_4_c_1[56] = 18'h0;
		sqrt_2_4_c_1[57] = 18'h0;
		sqrt_2_4_c_1[58] = 18'h0;
		sqrt_2_4_c_1[59] = 18'h0;
		sqrt_2_4_c_1[60] = 18'h0;
		sqrt_2_4_c_1[61] = 18'h0;
		sqrt_2_4_c_1[62] = 18'h0;
		sqrt_2_4_c_1[63] = 18'h0;
		
		
	end
//reset = 0? update all registers
	if(reset == 1'b0)
	begin
		
		corrected_value_d = corrected_value;
		expo_sqrt_d = expo_sqrt;
		sqrt_sign_d = sqrt_sign;
		even_odd_d = even_odd;
		
		sqrt_1_2_c_0[0] = 19'h403F9;
		sqrt_1_2_c_0[1] = 19'h40BE9;
		sqrt_1_2_c_0[2] = 19'h413CA;
		sqrt_1_2_c_0[3] = 19'h41B9B;
		sqrt_1_2_c_0[4] = 19'h4235E;
		sqrt_1_2_c_0[5] = 19'h42B13;
		sqrt_1_2_c_0[6] = 19'h432B9;
		sqrt_1_2_c_0[7] = 19'h43A52;
		sqrt_1_2_c_0[8] = 19'h441DD;
		sqrt_1_2_c_0[9] = 19'h4495B;
		sqrt_1_2_c_0[10] = 19'h450CB;
		sqrt_1_2_c_0[11] = 19'h4582F;
		sqrt_1_2_c_0[12] = 19'h45F87;
		sqrt_1_2_c_0[13] = 19'h466D2;
		sqrt_1_2_c_0[14] = 19'h46E11;
		sqrt_1_2_c_0[15] = 19'h47544;
		sqrt_1_2_c_0[16] = 19'h47C6C;
		sqrt_1_2_c_0[17] = 19'h48389;
		sqrt_1_2_c_0[18] = 19'h48A9A;
		sqrt_1_2_c_0[19] = 19'h491A1;
		sqrt_1_2_c_0[20] = 19'h4989C;
		sqrt_1_2_c_0[21] = 19'h49F8E;
		sqrt_1_2_c_0[22] = 19'h4A674;
		sqrt_1_2_c_0[23] = 19'h4AD51;
		sqrt_1_2_c_0[24] = 19'h4B424;
		sqrt_1_2_c_0[25] = 19'h4BAEC;
		sqrt_1_2_c_0[26] = 19'h4C1AB;
		sqrt_1_2_c_0[27] = 19'h4C861;
		sqrt_1_2_c_0[28] = 19'h4CF0D;
		sqrt_1_2_c_0[29] = 19'h4D5B0;
		sqrt_1_2_c_0[30] = 19'h4DC4A;
		sqrt_1_2_c_0[31] = 19'h4E2DB;
		sqrt_1_2_c_0[32] = 19'h4E963;
		sqrt_1_2_c_0[33] = 19'h4EFE3;
		sqrt_1_2_c_0[34] = 19'h4F65A;
		sqrt_1_2_c_0[35] = 19'h4FCC9;
		sqrt_1_2_c_0[36] = 19'h5032F;
		sqrt_1_2_c_0[37] = 19'h5098D;
		sqrt_1_2_c_0[38] = 19'h50FE4;
		sqrt_1_2_c_0[39] = 19'h51632;
		sqrt_1_2_c_0[40] = 19'h51C79;
		sqrt_1_2_c_0[41] = 19'h522B8;
		sqrt_1_2_c_0[42] = 19'h528EF;
		sqrt_1_2_c_0[43] = 19'h52F1F;
		sqrt_1_2_c_0[44] = 19'h53548;
		sqrt_1_2_c_0[45] = 19'h53B69;
		sqrt_1_2_c_0[46] = 19'h54183;
		sqrt_1_2_c_0[47] = 19'h54796;
		sqrt_1_2_c_0[48] = 19'h54DA2;
		sqrt_1_2_c_0[49] = 19'h553A8;
		sqrt_1_2_c_0[50] = 19'h559A6;
		sqrt_1_2_c_0[51] = 19'h55F9E;
		sqrt_1_2_c_0[52] = 19'h5658F;
		sqrt_1_2_c_0[53] = 19'h56B7A;
		sqrt_1_2_c_0[54] = 19'h5715E;
		sqrt_1_2_c_0[55] = 19'h5773C;
		sqrt_1_2_c_0[56] = 19'h57D14;
		sqrt_1_2_c_0[57] = 19'h582E6;
		sqrt_1_2_c_0[58] = 19'h588B1;
		sqrt_1_2_c_0[59] = 19'h58E76;
		sqrt_1_2_c_0[60] = 19'h59436;
		sqrt_1_2_c_0[61] = 19'h599EF;
		sqrt_1_2_c_0[62] = 19'h59FA3;
		sqrt_1_2_c_0[63] = 19'h5A551;


		sqrt_1_2_c_1[0] = 18'h1FE04;
		sqrt_1_2_c_1[1] = 18'h1FA1B;
		sqrt_1_2_c_1[2] = 18'h1F64A;
		sqrt_1_2_c_1[3] = 18'h1F28D;
		sqrt_1_2_c_1[4] = 18'h1EEE6;
		sqrt_1_2_c_1[5] = 18'h1EB54;
		sqrt_1_2_c_1[6] = 18'h1E7D4;
		sqrt_1_2_c_1[7] = 18'h1E468;
		sqrt_1_2_c_1[8] = 18'h1E10E;
		sqrt_1_2_c_1[9] = 18'h1DDC5;
		sqrt_1_2_c_1[10] = 18'h1DA8D;
		sqrt_1_2_c_1[11] = 18'h1D766;
		sqrt_1_2_c_1[12] = 18'h1D44F;
		sqrt_1_2_c_1[13] = 18'h1D147;
		sqrt_1_2_c_1[14] = 18'h1CE4E;
		sqrt_1_2_c_1[15] = 18'h1CB63;
		sqrt_1_2_c_1[16] = 18'h1C886;
		sqrt_1_2_c_1[17] = 18'h1C5B7;
		sqrt_1_2_c_1[18] = 18'h1C2F5;
		sqrt_1_2_c_1[19] = 18'h1C03F;
		sqrt_1_2_c_1[20] = 18'h1BD96;
		sqrt_1_2_c_1[21] = 18'h1BAF9;
		sqrt_1_2_c_1[22] = 18'h1B868;
		sqrt_1_2_c_1[23] = 18'h1B5E2;
		sqrt_1_2_c_1[24] = 18'h1B367;
		sqrt_1_2_c_1[25] = 18'h1B0F6;
		sqrt_1_2_c_1[26] = 18'h1AE90;
		sqrt_1_2_c_1[27] = 18'h1AC34;
		sqrt_1_2_c_1[28] = 18'h1A9E2;
		sqrt_1_2_c_1[29] = 18'h1A799;
		sqrt_1_2_c_1[30] = 18'h1A55A;
		sqrt_1_2_c_1[31] = 18'h1A324;
		sqrt_1_2_c_1[32] = 18'h1A0F6;
		sqrt_1_2_c_1[33] = 18'h19ED1;
		sqrt_1_2_c_1[34] = 18'h19CB5;
		sqrt_1_2_c_1[35] = 18'h19AA1;
		sqrt_1_2_c_1[36] = 18'h19894;
		sqrt_1_2_c_1[37] = 18'h19690;
		sqrt_1_2_c_1[38] = 18'h19493;
		sqrt_1_2_c_1[39] = 18'h1929D;
		sqrt_1_2_c_1[40] = 18'h190AF;
		sqrt_1_2_c_1[41] = 18'h18EC8;
		sqrt_1_2_c_1[42] = 18'h18CE7;
		sqrt_1_2_c_1[43] = 18'h18B0E;
		sqrt_1_2_c_1[44] = 18'h1893A;
		sqrt_1_2_c_1[45] = 18'h1876E;
		sqrt_1_2_c_1[46] = 18'h185A7;
		sqrt_1_2_c_1[47] = 18'h183E7;
		sqrt_1_2_c_1[48] = 18'h1822D;
		sqrt_1_2_c_1[49] = 18'h18078;
		sqrt_1_2_c_1[50] = 18'h17EC9;
		sqrt_1_2_c_1[51] = 18'h17D20;
		sqrt_1_2_c_1[52] = 18'h17B7D;
		sqrt_1_2_c_1[53] = 18'h179DE;
		sqrt_1_2_c_1[54] = 18'h17845;
		sqrt_1_2_c_1[55] = 18'h176B1;
		sqrt_1_2_c_1[56] = 18'h17522;
		sqrt_1_2_c_1[57] = 18'h17399;
		sqrt_1_2_c_1[58] = 18'h17213;
		sqrt_1_2_c_1[59] = 18'h17093;
		sqrt_1_2_c_1[60] = 18'h16F17;
		sqrt_1_2_c_1[61] = 18'h16DA0;
		sqrt_1_2_c_1[62] = 18'h16C2E;
		sqrt_1_2_c_1[63] = 18'h16ABF;


		sqrt_2_4_c_0[0] = 19'h5ADC7;
		sqrt_2_4_c_0[1] = 19'h5B901;
		sqrt_2_4_c_0[2] = 19'h5C425;
		sqrt_2_4_c_0[3] = 19'h5CF34;
		sqrt_2_4_c_0[4] = 19'h5DA2E;
		sqrt_2_4_c_0[5] = 19'h5E514;
		sqrt_2_4_c_0[6] = 19'h5EFE5;
		sqrt_2_4_c_0[7] = 19'h5FAA3;
		sqrt_2_4_c_0[8] = 19'h6054E;
		sqrt_2_4_c_0[9] = 19'h60FE6;
		sqrt_2_4_c_0[10] = 19'h61A6B;
		sqrt_2_4_c_0[11] = 19'h624DF;
		sqrt_2_4_c_0[12] = 19'h62F41;
		sqrt_2_4_c_0[13] = 19'h63992;
		sqrt_2_4_c_0[14] = 19'h643D1;
		sqrt_2_4_c_0[15] = 19'h64E00;
		sqrt_2_4_c_0[16] = 19'h6581F;
		sqrt_2_4_c_0[17] = 19'h6622D;
		sqrt_2_4_c_0[18] = 19'h66C2C;
		sqrt_2_4_c_0[19] = 19'h6761C;
		sqrt_2_4_c_0[20] = 19'h67FFC;
		sqrt_2_4_c_0[21] = 19'h689CD;
		sqrt_2_4_c_0[22] = 19'h69390;
		sqrt_2_4_c_0[23] = 19'h69D44;
		sqrt_2_4_c_0[24] = 19'h6A6EA;
		sqrt_2_4_c_0[25] = 19'h6B082;
		sqrt_2_4_c_0[26] = 19'h6BA0C;
		sqrt_2_4_c_0[27] = 19'h6C389;
		sqrt_2_4_c_0[28] = 19'h6CCF9;
		sqrt_2_4_c_0[29] = 19'h6D65C;
		sqrt_2_4_c_0[30] = 19'h6DFB2;
		sqrt_2_4_c_0[31] = 19'h6E8FB;
		sqrt_2_4_c_0[32] = 19'h6F238;
		sqrt_2_4_c_0[33] = 19'h6FB69;
		sqrt_2_4_c_0[34] = 19'h7048D;
		sqrt_2_4_c_0[35] = 19'h70DA6;
		sqrt_2_4_c_0[36] = 19'h716B3;
		sqrt_2_4_c_0[37] = 19'h71FB5;
		sqrt_2_4_c_0[38] = 19'h728AB;
		sqrt_2_4_c_0[39] = 19'h73196;
		sqrt_2_4_c_0[40] = 19'h73A76;
		sqrt_2_4_c_0[41] = 19'h7434C;
		sqrt_2_4_c_0[42] = 19'h74C16;
		sqrt_2_4_c_0[43] = 19'h754D6;
		sqrt_2_4_c_0[44] = 19'h75D8C;
		sqrt_2_4_c_0[45] = 19'h76637;
		sqrt_2_4_c_0[46] = 19'h76ED8;
		sqrt_2_4_c_0[47] = 19'h77770;
		sqrt_2_4_c_0[48] = 19'h77FFD;
		sqrt_2_4_c_0[49] = 19'h78881;
		sqrt_2_4_c_0[50] = 19'h790FB;
		sqrt_2_4_c_0[51] = 19'h7996C;
		sqrt_2_4_c_0[52] = 19'h7A1D3;
		sqrt_2_4_c_0[53] = 19'h7AA31;
		sqrt_2_4_c_0[54] = 19'h7B286;
		sqrt_2_4_c_0[55] = 19'h7BAD2;
		sqrt_2_4_c_0[56] = 19'h7C315;
		sqrt_2_4_c_0[57] = 19'h7CB50;
		sqrt_2_4_c_0[58] = 19'h7D382;
		sqrt_2_4_c_0[59] = 19'h7DBAB;
		sqrt_2_4_c_0[60] = 19'h7E3CC;
		sqrt_2_4_c_0[61] = 19'h7EBE4;
		sqrt_2_4_c_0[62] = 19'h7F3F4;
		sqrt_2_4_c_0[63] = 19'h7FBFC;

		sqrt_2_4_c_1[0] = 18'h168A2;
		sqrt_2_4_c_1[1] = 18'h165DF;
		sqrt_2_4_c_1[2] = 18'h1632B;
		sqrt_2_4_c_1[3] = 18'h16087;
		sqrt_2_4_c_1[4] = 18'h15DF2;
		sqrt_2_4_c_1[5] = 18'h15B6B;
		sqrt_2_4_c_1[6] = 18'h158F2;
		sqrt_2_4_c_1[7] = 18'h15686;
		sqrt_2_4_c_1[8] = 18'h15428;
		sqrt_2_4_c_1[9] = 18'h151D5;
		sqrt_2_4_c_1[10] = 18'h14F8F;
		sqrt_2_4_c_1[11] = 18'h14D54;
		sqrt_2_4_c_1[12] = 18'h14B24;
		sqrt_2_4_c_1[13] = 18'h14900;
		sqrt_2_4_c_1[14] = 18'h146E5;
		sqrt_2_4_c_1[15] = 18'h144D5;
		sqrt_2_4_c_1[16] = 18'h142CF;
		sqrt_2_4_c_1[17] = 18'h140D3;
		sqrt_2_4_c_1[18] = 18'h13EDF;
		sqrt_2_4_c_1[19] = 18'h13CF5;
		sqrt_2_4_c_1[20] = 18'h13B14;
		sqrt_2_4_c_1[21] = 18'h1393A;
		sqrt_2_4_c_1[22] = 18'h1376A;
		sqrt_2_4_c_1[23] = 18'h135A1;
		sqrt_2_4_c_1[24] = 18'h133E0;
		sqrt_2_4_c_1[25] = 18'h13226;
		sqrt_2_4_c_1[26] = 18'h13074;
		sqrt_2_4_c_1[27] = 18'h12EC9;
		sqrt_2_4_c_1[28] = 18'h12D25;
		sqrt_2_4_c_1[29] = 18'h12B87;
		sqrt_2_4_c_1[30] = 18'h129F0;
		sqrt_2_4_c_1[31] = 18'h12860;
		sqrt_2_4_c_1[32] = 18'h126D6;
		sqrt_2_4_c_1[33] = 18'h12552;
		sqrt_2_4_c_1[34] = 18'h123D4;
		sqrt_2_4_c_1[35] = 18'h1225B;
		sqrt_2_4_c_1[36] = 18'h120E9;
		sqrt_2_4_c_1[37] = 18'h11F7B;
		sqrt_2_4_c_1[38] = 18'h11E13;
		sqrt_2_4_c_1[39] = 18'h11CB1;
		sqrt_2_4_c_1[40] = 18'h11B53;
		sqrt_2_4_c_1[41] = 18'h119FB;
		sqrt_2_4_c_1[42] = 18'h118A7;
		sqrt_2_4_c_1[43] = 18'h11758;
		sqrt_2_4_c_1[44] = 18'h1160E;
		sqrt_2_4_c_1[45] = 18'h114C8;
		sqrt_2_4_c_1[46] = 18'h11387;
		sqrt_2_4_c_1[47] = 18'h1124A;
		sqrt_2_4_c_1[48] = 18'h11111;
		sqrt_2_4_c_1[49] = 18'h10FDC;
		sqrt_2_4_c_1[50] = 18'h10EAC;
		sqrt_2_4_c_1[51] = 18'h10D7F;
		sqrt_2_4_c_1[52] = 18'h10C56;
		sqrt_2_4_c_1[53] = 18'h10B31;
		sqrt_2_4_c_1[54] = 18'h10A10;
		sqrt_2_4_c_1[55] = 18'h108F2;
		sqrt_2_4_c_1[56] = 18'h107D8;
		sqrt_2_4_c_1[57] = 18'h106C2;
		sqrt_2_4_c_1[58] = 18'h105AF;
		sqrt_2_4_c_1[59] = 18'h1049F;
		sqrt_2_4_c_1[60] = 18'h10392;
		sqrt_2_4_c_1[61] = 18'h10289;
		sqrt_2_4_c_1[62] = 18'h10183;
		sqrt_2_4_c_1[63] = 18'h10080;
		
		c_0_1_2 = sqrt_1_2_c_0[table_address_1_2];
		c_1_1_2 = sqrt_1_2_c_1[table_address_1_2];
		c_0_2_4 = sqrt_2_4_c_0[table_address_2_4];
		c_1_2_4 = sqrt_2_4_c_1[table_address_2_4];
		
	end
end

//end
endmodule