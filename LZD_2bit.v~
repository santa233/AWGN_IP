///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			             2 bit leading zero detector                     //
//                                  By                                   //
//                        Santosh Kumar Krishnan                         //
//                                                                       //
//                         'TOP - 3' level entity                        //
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
	
module LZD_2bit(
ip,
p,
v);

//input
input [1:0] ip;

//output
output p;
output v;

//internal signals
wire t_1;

//combinational logic
assign t_1 = ~ip[1];
assign p = ip[0] & t_1;
assign v = ip[0] | ip[1];

//end
endmodule