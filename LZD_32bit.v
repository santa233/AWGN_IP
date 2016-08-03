///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			             32 bit leading zero detector                    //
//                                  By                                   //
//                        Santosh Kumar Krishnan                         //
//                                                                       //
//                         'TOP - 2' level entity                        //
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
	
module LZD_32(
num,
zeros);

//input
input [31:0] num;

//output
output [5:0] zeros;

//internal signals
wire level1_p[15:0];
wire level1_v[15:0];
wire [1:0] level2_p[7:0];
wire level2_v[7:0];
wire [2:0] level3_p[3:0];
wire level3_v[3:0];
wire [3:0] level4_p[1:0];
wire level4_v[1:0];
wire [4:0] level5_p;
wire t_1,t_2,t_3,t_4,t_5,t_6,t_7,t_8;
wire [1:0] t_9,t_10,t_11,t_12;
wire [2:0] t_13,t_14;
wire [3:0] t_15;
genvar i;

//combinational logic

//instantiate 16 2 bit leading zero deteector modules. They form level 1
generate
	for(i=0;i<16;i=i+1)
	begin
		LZD_2bit L ({num[2*i+1],num[2*i]},level1_p[i],level1_v[i]);
	end
endgenerate

//assign all v field of level 2, level 3 and level 4 
assign level2_v[0] = level1_v[0] | level1_v[1];
assign level2_v[1] = level1_v[2] | level1_v[3];
assign level2_v[2] = level1_v[4] | level1_v[5];
assign level2_v[3] = level1_v[6] | level1_v[7];
assign level2_v[4] = level1_v[8] | level1_v[9];
assign level2_v[5] = level1_v[10] | level1_v[11];
assign level2_v[6] = level1_v[12] | level1_v[13];
assign level2_v[7] = level1_v[14] | level1_v[15];
assign level3_v[0] = level2_v[0] | level2_v[1]; 
assign level3_v[1] = level2_v[2] | level2_v[3];
assign level3_v[2] = level2_v[4] | level2_v[5]; 
assign level3_v[3] = level2_v[6] | level2_v[7];
assign level4_v[0] = level3_v[0] | level3_v[1];
assign level4_v[1] = level3_v[2] | level3_v[3];

//assign all p fields of level 2, level 3 and level 4
assign t_1 = (level1_v[1]==0)?level1_p[0]:level1_p[1];
assign t_2 = (level1_v[3]==0)?level1_p[2]:level1_p[3];
assign t_3 = (level1_v[5]==0)?level1_p[4]:level1_p[5];
assign t_4 = (level1_v[7]==0)?level1_p[6]:level1_p[7];
assign t_5 = (level1_v[9]==0)?level1_p[8]:level1_p[9];
assign t_6 = (level1_v[11]==0)?level1_p[10]:level1_p[11];
assign t_7 = (level1_v[13]==0)?level1_p[12]:level1_p[13];
assign t_8 = (level1_v[15]==0)?level1_p[14]:level1_p[15];
assign level2_p[0] = {~level1_v[1],t_1};
assign level2_p[1] = {~level1_v[3],t_2};
assign level2_p[2] = {~level1_v[5],t_3};
assign level2_p[3] = {~level1_v[7],t_4};
assign level2_p[4] = {~level1_v[9],t_5};
assign level2_p[5] = {~level1_v[11],t_6};
assign level2_p[6] = {~level1_v[13],t_7};
assign level2_p[7] = {~level1_v[15],t_8};
assign t_9 = (level2_v[1]==0)?level2_p[0]:level2_p[1];
assign t_10 = (level2_v[3]==0)?level2_p[2]:level2_p[3];
assign t_11 = (level2_v[5]==0)?level2_p[4]:level2_p[5];
assign t_12 = (level2_v[7]==0)?level2_p[6]:level2_p[7];
assign level3_p[0] = {~level2_v[1],t_9};
assign level3_p[1] = {~level2_v[3],t_10};
assign level3_p[2] = {~level2_v[5],t_11};
assign level3_p[3] = {~level2_v[7],t_12};
assign t_13 = (level3_v[1] == 0)?level3_p[0]:level3_p[1];
assign t_14 = (level3_v[3] == 0)?level3_p[2]:level3_p[3];
assign level4_p[0] = {~level3_v[1],t_13};
assign level4_p[1] = {~level3_v[3],t_14};
assign t_15 = (level4_v[1] == 0)?level4_p[0]:level4_p[1];
assign level5_p = {~level4_v[1],t_15};

//special case: when input is all zeros. 
assign zeros = (num == 32'h00000000)?6'b100000:{1'b0,level5_p};

//end
endmodule