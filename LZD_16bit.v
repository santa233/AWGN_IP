///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			             16 bit leading zero detector                    //
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
	
module LZD_16 (
num,
zeros);

//input
input [15:0] num;

//output
output [4:0] zeros;

//internal signals
wire level1_p[7:0];
wire level1_v[7:0];
wire [1:0] level2_p[3:0];
wire level2_v[3:0];
wire [2:0] level3_p[1:0];
wire level3_v[1:0];
wire [3:0] level4_p;
wire t_1,t_2,t_3,t_4;
wire [1:0] t_5,t_6;
wire [2:0] t_7;
genvar i;

//combinational logic

//instantiate 8 2 bit leading zero deteector modules. They form level 1
generate
	for(i=0;i<8;i=i+1)
	begin
		LZD_2bit L ({num[2*i+1],num[2*i]},level1_p[i],level1_v[i]);
	end
endgenerate

//assign all v field of level 2 and level 3 
assign level2_v[0] = level1_v[0] | level1_v[1];
assign level2_v[1] = level1_v[2] | level1_v[3];
assign level2_v[2] = level1_v[4] | level1_v[5];
assign level2_v[3] = level1_v[6] | level1_v[7];
assign level3_v[0] = level2_v[0] | level2_v[1]; 
assign level3_v[1] = level2_v[2] | level2_v[3];

// assign all p fields of level 2 and level 3
assign t_1 = (level1_v[1]==0)?level1_p[0]:level1_p[1];
assign t_2 = (level1_v[3]==0)?level1_p[2]:level1_p[3];
assign t_3 = (level1_v[5]==0)?level1_p[4]:level1_p[5];
assign t_4 = (level1_v[7]==0)?level1_p[6]:level1_p[7];
assign level2_p[0] = {~level1_v[1],t_1};
assign level2_p[1] = {~level1_v[3],t_2};
assign level2_p[2] = {~level1_v[5],t_3};
assign level2_p[3] = {~level1_v[7],t_4};
assign t_5 = (level2_v[1]==0)?level2_p[0]:level2_p[1];
assign t_6 = (level2_v[3]==0)?level2_p[2]:level2_p[3];
assign level3_p[0] = {~level2_v[1],t_5};
assign level3_p[1] = {~level2_v[3],t_6};
assign t_7 = (level3_v[1] == 0)?level3_p[0]:level3_p[1];
assign level4_p = {~level3_v[1],t_7};

//special case: when input is all zeros.
assign zeros = (num == 16'h0000)?5'b10000:{1'b0,level4_p};

//end
endmodule