///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			             48 bit right barrel shifter                     //
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
	
module barrel_shifter_48_right (
num,
shift_needed,
shifted);

//inputs
input [47:0] num;
input [5:0] shift_needed;

//output
output [47:0] shifted;

//internal  signals
wire [47:0] level0_ip;
wire [47:0] level1_ip;
wire [47:0] level2_ip;
wire [47:0] level3_ip;
wire [47:0] level4_ip;
wire [47:0] level5_ip;
wire [47:0] level0_op;
wire [47:0] level1_op;
wire [47:0] level2_op;
wire [47:0] level3_op;
wire [47:0] level4_op;
wire [47:0] level5_op;

//combinational logic

//input to level 5 of barrel shifter shifted right by 32 
assign level5_ip = {32'b0,num[47:32]};

//input to level 4 of barrel shifter shifted right by 16
assign level4_ip = {16'b0,level5_op[47:16]};

//input to level 3 of barrel shifter shifted right by 8
assign level3_ip = {8'b0,level4_op[47:8]};

//input to level 2 of barrel shifter shifted right by 4
assign level2_ip = {4'b0,level3_op[47:4]};

//input to level 1 of barrel shifter shifted right by 2
assign level1_ip = {2'b0,level2_op[47:2]};

//input to level 0 of barrel shifter shifted right by 1
assign level0_ip = {1'b0,level1_op[47:1]};

//output from level5
assign level5_op = (shift_needed[5] == 0)?num:level5_ip;

//output from level4
assign level4_op = (shift_needed[4] == 0)?level5_op:level4_ip;

//output from level3
assign level3_op = (shift_needed[3] == 0)?level4_op:level3_ip;

//output from level2
assign level2_op = (shift_needed[2] == 0)?level3_op:level2_ip;

//output from level1
assign level1_op = (shift_needed[1] == 0)?level2_op:level1_ip;

//output from level0
assign level0_op = (shift_needed[0] == 0)?level1_op:level0_ip;

//output of barrel shifter
assign shifted = level0_op;

//end
endmodule