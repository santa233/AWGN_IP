///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			             Cosine Module [ Cos(2.pi.x) ]                   //
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
	
module cosine_module (
clock,
reset,
angle,
value,
);

//input
//clock
input clock;
//reset to initialize all registers coefficient table
input reset;
//angle at which cosine is to be found
input [15:0] angle;

//output
//cosine of angle
output [16:0] value;

//internal signals
wire [6:0] table_address_pos;
wire [6:0] table_address_neg;
wire [32:0] mul_result_pos;
wire [32:0] mul_result_neg;
wire [18:0] D_pos;
wire [18:0] D_neg;
wire [6:0] p_1; 
wire [19:0] value_t;
wire [19:0] cos_pos;
wire [19:0] cos_neg;
wire [1:0] quadrand,quadrand_p2;
wire [13:0] x_pos,x_pos_p2;
wire [13:0] x_neg,x_neg_p2;

//internal registers
reg [18:0] cos_c_0[127:0];
reg [18:0] cos_c_1[127:0];
reg [18:0] c_0_pos;
reg [18:0] c_1_pos;
reg [18:0] c_0_neg;
reg [18:0] c_1_neg;
reg [1:0] quadrand_d;
reg [13:0] x_pos_d;
reg [13:0] x_neg_d;

//combinational logic

//find quadrand of the angle.
assign quadrand = angle[15:14];

//find the address of the coefficient table (x_pos) 
assign table_address_pos = angle[13:7];
assign p_1 = angle[6:0];

//x_pos = x;
assign x_pos = {table_address_pos,p_1};

//x_neg = pi/2 - x
assign x_neg = 14'h3FFF - x_pos;

//find the address of the coefficient table (x_neg) 
assign table_address_neg = x_neg[13:7];

// get outputs of d ffs 
assign x_pos_p2 = x_pos_d;
assign x_neg_p2 = x_neg_d;
assign quadrand_p2 = quadrand_d;

//execute the piecewise polynomial.
assign mul_result_pos = x_pos_p2*c_1_pos;
assign mul_result_neg = x_neg_p2*c_1_neg;
assign D_pos = mul_result_pos[32:14];
assign D_neg = mul_result_neg[32:14];
assign cos_neg = c_0_neg - D_neg;
assign cos_pos = c_0_pos - D_pos;

//the current evaluation (cos(x) and cos(1-x)) is from an angle of 0 to pi/2. 
//Now depending on the quadrand we choose either +ve or -ve of cos(x) or cos(1-x)
assign value_t = (quadrand_p2 == 2'b00)?cos_pos:( (quadrand_p2 == 2'b01)?(~cos_neg) +1:( (quadrand_p2 == 2'b10)?(~cos_pos) +1:cos_neg ) );

//get cosine of angle
assign value = value_t[19:3];

//sequential logic
always@(posedge clock)
begin
//reset =0? update all registers and coefficient table
	if(reset == 1'b0)
	begin
		
		x_pos_d = x_pos;
		x_neg_d = x_neg;
		quadrand_d = quadrand;
		
		cos_c_0[0] = 19'h40002;
		cos_c_0[1] = 19'h40029;
		cos_c_0[2] = 19'h40078;
		cos_c_0[3] = 19'h400EF;
		cos_c_0[4] = 19'h4018C;
		cos_c_0[5] = 19'h40251;
		cos_c_0[6] = 19'h4033E;
		cos_c_0[7] = 19'h40451;
		cos_c_0[8] = 19'h4058B;
		cos_c_0[9] = 19'h406EC;
		cos_c_0[10] = 19'h40874;
		cos_c_0[11] = 19'h40A23;
		cos_c_0[12] = 19'h40BF7;
		cos_c_0[13] = 19'h40DF2;
		cos_c_0[14] = 19'h41012;
		cos_c_0[15] = 19'h41259;
		cos_c_0[16] = 19'h414C4;
		cos_c_0[17] = 19'h41755;
		cos_c_0[18] = 19'h41A0A;
		cos_c_0[19] = 19'h41CE4;
		cos_c_0[20] = 19'h41FE2;
		cos_c_0[21] = 19'h42303;
		cos_c_0[22] = 19'h42648;
		cos_c_0[23] = 19'h429B0;
		cos_c_0[24] = 19'h42D3B;
		cos_c_0[25] = 19'h430E8;
		cos_c_0[26] = 19'h434B6;
		cos_c_0[27] = 19'h438A6;
		cos_c_0[28] = 19'h43CB7;
		cos_c_0[29] = 19'h440E8;
		cos_c_0[30] = 19'h44539;
		cos_c_0[31] = 19'h449AA;
		cos_c_0[32] = 19'h44E39;
		cos_c_0[33] = 19'h452E6;
		cos_c_0[34] = 19'h457B1;
		cos_c_0[35] = 19'h45C99;
		cos_c_0[36] = 19'h4619E;
		cos_c_0[37] = 19'h466BF;
		cos_c_0[38] = 19'h46BFB;
		cos_c_0[39] = 19'h47151;
		cos_c_0[40] = 19'h476C2;
		cos_c_0[41] = 19'h47C4C;
		cos_c_0[42] = 19'h481EF;
		cos_c_0[43] = 19'h487A9;
		cos_c_0[44] = 19'h48D7B;
		cos_c_0[45] = 19'h49364;
		cos_c_0[46] = 19'h49962;
		cos_c_0[47] = 19'h49F75;
		cos_c_0[48] = 19'h4A59D;
		cos_c_0[49] = 19'h4ABD8;
		cos_c_0[50] = 19'h4B226;
		cos_c_0[51] = 19'h4B885;
		cos_c_0[52] = 19'h4BEF6;
		cos_c_0[53] = 19'h4C577;
		cos_c_0[54] = 19'h4CC08;
		cos_c_0[55] = 19'h4D2A7;
		cos_c_0[56] = 19'h4D954;
		cos_c_0[57] = 19'h4E00E;
		cos_c_0[58] = 19'h4E6D4;
		cos_c_0[59] = 19'h4EDA4;
		cos_c_0[60] = 19'h4F47F;
		cos_c_0[61] = 19'h4FB64;
		cos_c_0[62] = 19'h50250;
		cos_c_0[63] = 19'h50945;
		cos_c_0[64] = 19'h5103F;
		cos_c_0[65] = 19'h5173F;
		cos_c_0[66] = 19'h51E44;
		cos_c_0[67] = 19'h5254C;
		cos_c_0[68] = 19'h52C57;
		cos_c_0[69] = 19'h53363;
		cos_c_0[70] = 19'h53A70;
		cos_c_0[71] = 19'h5417D;
		cos_c_0[72] = 19'h54888;
		cos_c_0[73] = 19'h54F91;
		cos_c_0[74] = 19'h55696;
		cos_c_0[75] = 19'h55D97;
		cos_c_0[76] = 19'h56492;
		cos_c_0[77] = 19'h56B87;
		cos_c_0[78] = 19'h57274;
		cos_c_0[79] = 19'h57958;
		cos_c_0[80] = 19'h58033;
		cos_c_0[81] = 19'h58702;
		cos_c_0[82] = 19'h58DC6;
		cos_c_0[83] = 19'h5947D;
		cos_c_0[84] = 19'h59B26;
		cos_c_0[85] = 19'h5A1C0;
		cos_c_0[86] = 19'h5A849;
		cos_c_0[87] = 19'h5AEC1;
		cos_c_0[88] = 19'h5B527;
		cos_c_0[89] = 19'h5BB79;
		cos_c_0[90] = 19'h5C1B6;
		cos_c_0[91] = 19'h5C7DE;
		cos_c_0[92] = 19'h5CDEF;
		cos_c_0[93] = 19'h5D3E8;
		cos_c_0[94] = 19'h5D9C7;
		cos_c_0[95] = 19'h5DF8D;
		cos_c_0[96] = 19'h5E537;
		cos_c_0[97] = 19'h5EAC5;
		cos_c_0[98] = 19'h5F036;
		cos_c_0[99] = 19'h5F587;
		cos_c_0[100] = 19'h5FAB9;
		cos_c_0[101] = 19'h5FFCA;
		cos_c_0[102] = 19'h604B9;
		cos_c_0[103] = 19'h60985;
		cos_c_0[104] = 19'h60E2D;
		cos_c_0[105] = 19'h612B0;
		cos_c_0[106] = 19'h6170C;
		cos_c_0[107] = 19'h61B40;
		cos_c_0[108] = 19'h61F4C;
		cos_c_0[109] = 19'h6232E;
		cos_c_0[110] = 19'h626E6;
		cos_c_0[111] = 19'h62A71;
		cos_c_0[112] = 19'h62DD0;
		cos_c_0[113] = 19'h63101;
		cos_c_0[114] = 19'h63402;
		cos_c_0[115] = 19'h636D3;
		cos_c_0[116] = 19'h63973;
		cos_c_0[117] = 19'h63BE1;
		cos_c_0[118] = 19'h63E1B;
		cos_c_0[119] = 19'h64021;
		cos_c_0[120] = 19'h641F1;
		cos_c_0[121] = 19'h6438B;
		cos_c_0[122] = 19'h644ED;
		cos_c_0[123] = 19'h64617;
		cos_c_0[124] = 19'h64707;
		cos_c_0[125] = 19'h647BC;
		cos_c_0[126] = 19'h64837;
		cos_c_0[127] = 19'h64874;

		cos_c_1[0] = 19'h9DE;
		cos_c_1[1] = 19'h1D9B;
		cos_c_1[2] = 19'h3157;
		cos_c_1[3] = 19'h4510;
		cos_c_1[4] = 19'h58C7;
		cos_c_1[5] = 19'h6C7B;
		cos_c_1[6] = 19'h802B;
		cos_c_1[7] = 19'h93D5;
		cos_c_1[8] = 19'hA77A;
		cos_c_1[9] = 19'hBB18;
		cos_c_1[10] = 19'hCEAF;
		cos_c_1[11] = 19'hE23F;
		cos_c_1[12] = 19'hF5C5;
		cos_c_1[13] = 19'h10942;
		cos_c_1[14] = 19'h11CB5;
		cos_c_1[15] = 19'h1301D;
		cos_c_1[16] = 19'h14379;
		cos_c_1[17] = 19'h156C8;
		cos_c_1[18] = 19'h16A0B;
		cos_c_1[19] = 19'h17D3F;
		cos_c_1[20] = 19'h19065;
		cos_c_1[21] = 19'h1A37B;
		cos_c_1[22] = 19'h1B681;
		cos_c_1[23] = 19'h1C977;
		cos_c_1[24] = 19'h1DC5A;
		cos_c_1[25] = 19'h1EF2B;
		cos_c_1[26] = 19'h201EA;
		cos_c_1[27] = 19'h21494;
		cos_c_1[28] = 19'h2272A;
		cos_c_1[29] = 19'h239AA;
		cos_c_1[30] = 19'h24C15;
		cos_c_1[31] = 19'h25E69;
		cos_c_1[32] = 19'h270A5;
		cos_c_1[33] = 19'h282CA;
		cos_c_1[34] = 19'h294D5;
		cos_c_1[35] = 19'h2A6C8;
		cos_c_1[36] = 19'h2B8A0;
		cos_c_1[37] = 19'h2CA5D;
		cos_c_1[38] = 19'h2DBFE;
		cos_c_1[39] = 19'h2ED84;
		cos_c_1[40] = 19'h2FEEC;
		cos_c_1[41] = 19'h31037;
		cos_c_1[42] = 19'h32164;
		cos_c_1[43] = 19'h33272;
		cos_c_1[44] = 19'h34360;
		cos_c_1[45] = 19'h3542E;
		cos_c_1[46] = 19'h364DB;
		cos_c_1[47] = 19'h37567;
		cos_c_1[48] = 19'h385D0;
		cos_c_1[49] = 19'h39617;
		cos_c_1[50] = 19'h3A63B;
		cos_c_1[51] = 19'h3B63A;
		cos_c_1[52] = 19'h3C615;
		cos_c_1[53] = 19'h3D5CA;
		cos_c_1[54] = 19'h3E55A;
		cos_c_1[55] = 19'h3F4C3;
		cos_c_1[56] = 19'h40405;
		cos_c_1[57] = 19'h41320;
		cos_c_1[58] = 19'h42212;
		cos_c_1[59] = 19'h430DC;
		cos_c_1[60] = 19'h43F7C;
		cos_c_1[61] = 19'h44DF2;
		cos_c_1[62] = 19'h45C3E;
		cos_c_1[63] = 19'h46A5E;
		cos_c_1[64] = 19'h47854;
		cos_c_1[65] = 19'h4861D;
		cos_c_1[66] = 19'h493B9;
		cos_c_1[67] = 19'h4A128;
		cos_c_1[68] = 19'h4AE6A;
		cos_c_1[69] = 19'h4BB7D;
		cos_c_1[70] = 19'h4C862;
		cos_c_1[71] = 19'h4D517;
		cos_c_1[72] = 19'h4E19D;
		cos_c_1[73] = 19'h4EDF2;
		cos_c_1[74] = 19'h4FA17;
		cos_c_1[75] = 19'h5060B;
		cos_c_1[76] = 19'h511CD;
		cos_c_1[77] = 19'h51D5D;
		cos_c_1[78] = 19'h528BB;
		cos_c_1[79] = 19'h533E5;
		cos_c_1[80] = 19'h53EDD;
		cos_c_1[81] = 19'h549A0;
		cos_c_1[82] = 19'h55430;
		cos_c_1[83] = 19'h55E8B;
		cos_c_1[84] = 19'h568B1;
		cos_c_1[85] = 19'h572A1;
		cos_c_1[86] = 19'h57C5C;
		cos_c_1[87] = 19'h585E0;
		cos_c_1[88] = 19'h58F2E;
		cos_c_1[89] = 19'h59846;
		cos_c_1[90] = 19'h5A126;
		cos_c_1[91] = 19'h5A9CE;
		cos_c_1[92] = 19'h5B23E;
		cos_c_1[93] = 19'h5BA77;
		cos_c_1[94] = 19'h5C276;
		cos_c_1[95] = 19'h5CA3D;
		cos_c_1[96] = 19'h5D1CB;
		cos_c_1[97] = 19'h5D920;
		cos_c_1[98] = 19'h5E03A;
		cos_c_1[99] = 19'h5E71B;
		cos_c_1[100] = 19'h5EDC1;
		cos_c_1[101] = 19'h5F42D;
		cos_c_1[102] = 19'h5FA5E;
		cos_c_1[103] = 19'h60054;
		cos_c_1[104] = 19'h6060F;
		cos_c_1[105] = 19'h60B8E;
		cos_c_1[106] = 19'h610D2;
		cos_c_1[107] = 19'h615DA;
		cos_c_1[108] = 19'h61AA6;
		cos_c_1[109] = 19'h61F35;
		cos_c_1[110] = 19'h62389;
		cos_c_1[111] = 19'h6279F;
		cos_c_1[112] = 19'h62B79;
		cos_c_1[113] = 19'h62F16;
		cos_c_1[114] = 19'h63276;
		cos_c_1[115] = 19'h63599;
		cos_c_1[116] = 19'h6387E;
		cos_c_1[117] = 19'h63B26;
		cos_c_1[118] = 19'h63D91;
		cos_c_1[119] = 19'h63FBE;
		cos_c_1[120] = 19'h641AD;
		cos_c_1[121] = 19'h6435E;
		cos_c_1[122] = 19'h644D2;
		cos_c_1[123] = 19'h64608;
		cos_c_1[124] = 19'h64700;
		cos_c_1[125] = 19'h647BA;
		cos_c_1[126] = 19'h64836;
		cos_c_1[127] = 19'h64874;
		
		c_0_pos = cos_c_0[table_address_pos];
		c_1_pos = cos_c_1[table_address_pos];
		c_0_neg = cos_c_0[table_address_neg];
		c_1_neg = cos_c_1[table_address_neg];
	end
//reset =1? update all registers and coefficient table	
	if(reset == 1'b1)
	begin
		
		x_pos_d = 14'h0;
		x_neg_d = 14'h3FFF;
		quadrand_d = quadrand;
		
		c_0_pos = 19'h0;
		c_1_pos = 19'h0;
		c_0_neg = 19'h0;
		c_1_neg = 19'h0;
		
		cos_c_0[0] = 19'h0;
		cos_c_0[1] = 19'h0;
		cos_c_0[2] = 19'h0;
		cos_c_0[3] = 19'h0;
		cos_c_0[4] = 19'h0;
		cos_c_0[5] = 19'h0;
		cos_c_0[6] = 19'h0;
		cos_c_0[7] = 19'h0;
		cos_c_0[8] = 19'h0;
		cos_c_0[9] = 19'h0;
		cos_c_0[10] = 19'h0;
		cos_c_0[11] = 19'h0;
		cos_c_0[12] = 19'h0;
		cos_c_0[13] = 19'h0;
		cos_c_0[14] = 19'h0;
		cos_c_0[15] = 19'h0;
		cos_c_0[16] = 19'h0;
		cos_c_0[17] = 19'h0;
		cos_c_0[18] = 19'h0;
		cos_c_0[19] = 19'h0;
		cos_c_0[20] = 19'h0;
		cos_c_0[21] = 19'h0;
		cos_c_0[22] = 19'h0;
		cos_c_0[23] = 19'h0;
		cos_c_0[24] = 19'h0;
		cos_c_0[25] = 19'h0;
		cos_c_0[26] = 19'h0;
		cos_c_0[27] = 19'h0;
		cos_c_0[28] = 19'h0;
		cos_c_0[29] = 19'h0;
		cos_c_0[30] = 19'h0;
		cos_c_0[31] = 19'h0;
		cos_c_0[32] = 19'h0;
		cos_c_0[33] = 19'h0;
		cos_c_0[34] = 19'h0;
		cos_c_0[35] = 19'h0;
		cos_c_0[36] = 19'h0;
		cos_c_0[37] = 19'h0;
		cos_c_0[38] = 19'h0;
		cos_c_0[39] = 19'h0;
		cos_c_0[40] = 19'h0;
		cos_c_0[41] = 19'h0;
		cos_c_0[42] = 19'h0;
		cos_c_0[43] = 19'h0;
		cos_c_0[44] = 19'h0;
		cos_c_0[45] = 19'h0;
		cos_c_0[46] = 19'h0;
		cos_c_0[47] = 19'h0;
		cos_c_0[48] = 19'h0;
		cos_c_0[49] = 19'h0;
		cos_c_0[50] = 19'h0;
		cos_c_0[51] = 19'h0;
		cos_c_0[52] = 19'h0;
		cos_c_0[53] = 19'h0;
		cos_c_0[54] = 19'h0;
		cos_c_0[55] = 19'h0;
		cos_c_0[56] = 19'h0;
		cos_c_0[57] = 19'h0;
		cos_c_0[58] = 19'h0;
		cos_c_0[59] = 19'h0;
		cos_c_0[60] = 19'h0;
		cos_c_0[61] = 19'h0;
		cos_c_0[62] = 19'h0;
		cos_c_0[63] = 19'h0;
		cos_c_0[64] = 19'h0;
		cos_c_0[65] = 19'h0;
		cos_c_0[66] = 19'h0;
		cos_c_0[67] = 19'h0;
		cos_c_0[68] = 19'h0;
		cos_c_0[69] = 19'h0;
		cos_c_0[70] = 19'h0;
		cos_c_0[71] = 19'h0;
		cos_c_0[72] = 19'h0;
		cos_c_0[73] = 19'h0;
		cos_c_0[74] = 19'h0;
		cos_c_0[75] = 19'h0;
		cos_c_0[76] = 19'h0;
		cos_c_0[77] = 19'h0;
		cos_c_0[78] = 19'h0;
		cos_c_0[79] = 19'h0;
		cos_c_0[80] = 19'h0;
		cos_c_0[81] = 19'h0;
		cos_c_0[82] = 19'h0;
		cos_c_0[83] = 19'h0;
		cos_c_0[84] = 19'h0;
		cos_c_0[85] = 19'h0;
		cos_c_0[86] = 19'h0;
		cos_c_0[87] = 19'h0;
		cos_c_0[88] = 19'h0;
		cos_c_0[89] = 19'h0;
		cos_c_0[90] = 19'h0;
		cos_c_0[91] = 19'h0;
		cos_c_0[92] = 19'h0;
		cos_c_0[93] = 19'h0;
		cos_c_0[94] = 19'h0;
		cos_c_0[95] = 19'h0;
		cos_c_0[96] = 19'h0;
		cos_c_0[97] = 19'h0;
		cos_c_0[98] = 19'h0;
		cos_c_0[99] = 19'h0;
		cos_c_0[100] = 19'h0;
		cos_c_0[101] = 19'h0;
		cos_c_0[102] = 19'h0;
		cos_c_0[103] = 19'h0;
		cos_c_0[104] = 19'h0;
		cos_c_0[105] = 19'h0;
		cos_c_0[106] = 19'h0;
		cos_c_0[107] = 19'h0;
		cos_c_0[108] = 19'h0;
		cos_c_0[109] = 19'h0;
		cos_c_0[110] = 19'h0;
		cos_c_0[111] = 19'h0;
		cos_c_0[112] = 19'h0;
		cos_c_0[113] = 19'h0;
		cos_c_0[114] = 19'h0;
		cos_c_0[115] = 19'h0;
		cos_c_0[116] = 19'h0;
		cos_c_0[117] = 19'h0;
		cos_c_0[118] = 19'h0;
		cos_c_0[119] = 19'h0;
		cos_c_0[120] = 19'h0;
		cos_c_0[121] = 19'h0;
		cos_c_0[122] = 19'h0;
		cos_c_0[123] = 19'h0;
		cos_c_0[124] = 19'h0;
		cos_c_0[125] = 19'h0;
		cos_c_0[126] = 19'h0;
		cos_c_0[127] = 19'h0;


		cos_c_1[0] = 19'h0;
		cos_c_1[1] = 19'h0;
		cos_c_1[2] = 19'h0;
		cos_c_1[3] = 19'h0;
		cos_c_1[4] = 19'h0;
		cos_c_1[5] = 19'h0;
		cos_c_1[6] = 19'h0;
		cos_c_1[7] = 19'h0;
		cos_c_1[8] = 19'h0;
		cos_c_1[9] = 19'h0;
		cos_c_1[10] = 19'h0;
		cos_c_1[11] = 19'h0;
		cos_c_1[12] = 19'h0;
		cos_c_1[13] = 19'h0;
		cos_c_1[14] = 19'h0;
		cos_c_1[15] = 19'h0;
		cos_c_1[16] = 19'h0;
		cos_c_1[17] = 19'h0;
		cos_c_1[18] = 19'h0;
		cos_c_1[19] = 19'h0;
		cos_c_1[20] = 19'h0;
		cos_c_1[21] = 19'h0;
		cos_c_1[22] = 19'h0;
		cos_c_1[23] = 19'h0;
		cos_c_1[24] = 19'h0;
		cos_c_1[25] = 19'h0;
		cos_c_1[26] = 19'h0;
		cos_c_1[27] = 19'h0;
		cos_c_1[28] = 19'h0;
		cos_c_1[29] = 19'h0;
		cos_c_1[30] = 19'h0;
		cos_c_1[31] = 19'h0;
		cos_c_1[32] = 19'h0;
		cos_c_1[33] = 19'h0;
		cos_c_1[34] = 19'h0;
		cos_c_1[35] = 19'h0;
		cos_c_1[36] = 19'h0;
		cos_c_1[37] = 19'h0;
		cos_c_1[38] = 19'h0;
		cos_c_1[39] = 19'h0;
		cos_c_1[40] = 19'h0;
		cos_c_1[41] = 19'h0;
		cos_c_1[42] = 19'h0;
		cos_c_1[43] = 19'h0;
		cos_c_1[44] = 19'h0;
		cos_c_1[45] = 19'h0;
		cos_c_1[46] = 19'h0;
		cos_c_1[47] = 19'h0;
		cos_c_1[48] = 19'h0;
		cos_c_1[49] = 19'h0;
		cos_c_1[50] = 19'h0;
		cos_c_1[51] = 19'h0;
		cos_c_1[52] = 19'h0;
		cos_c_1[53] = 19'h0;
		cos_c_1[54] = 19'h0;
		cos_c_1[55] = 19'h0;
		cos_c_1[56] = 19'h0;
		cos_c_1[57] = 19'h0;
		cos_c_1[58] = 19'h0;
		cos_c_1[59] = 19'h0;
		cos_c_1[60] = 19'h0;
		cos_c_1[61] = 19'h0;
		cos_c_1[62] = 19'h0;
		cos_c_1[63] = 19'h0;
		cos_c_1[64] = 19'h0;
		cos_c_1[65] = 19'h0;
		cos_c_1[66] = 19'h0;
		cos_c_1[67] = 19'h0;
		cos_c_1[68] = 19'h0;
		cos_c_1[69] = 19'h0;
		cos_c_1[70] = 19'h0;
		cos_c_1[71] = 19'h0;
		cos_c_1[72] = 19'h0;
		cos_c_1[73] = 19'h0;
		cos_c_1[74] = 19'h0;
		cos_c_1[75] = 19'h0;
		cos_c_1[76] = 19'h0;
		cos_c_1[77] = 19'h0;
		cos_c_1[78] = 19'h0;
		cos_c_1[79] = 19'h0;
		cos_c_1[80] = 19'h0;
		cos_c_1[81] = 19'h0;
		cos_c_1[82] = 19'h0;
		cos_c_1[83] = 19'h0;
		cos_c_1[84] = 19'h0;
		cos_c_1[85] = 19'h0;
		cos_c_1[86] = 19'h0;
		cos_c_1[87] = 19'h0;
		cos_c_1[88] = 19'h0;
		cos_c_1[89] = 19'h0;
		cos_c_1[90] = 19'h0;
		cos_c_1[91] = 19'h0;
		cos_c_1[92] = 19'h0;
		cos_c_1[93] = 19'h0;
		cos_c_1[94] = 19'h0;
		cos_c_1[95] = 19'h0;
		cos_c_1[96] = 19'h0;
		cos_c_1[97] = 19'h0;
		cos_c_1[98] = 19'h0;
		cos_c_1[99] = 19'h0;
		cos_c_1[100] = 19'h0;
		cos_c_1[101] = 19'h0;
		cos_c_1[102] = 19'h0;
		cos_c_1[103] = 19'h0;
		cos_c_1[104] = 19'h0;
		cos_c_1[105] = 19'h0;
		cos_c_1[106] = 19'h0;
		cos_c_1[107] = 19'h0;
		cos_c_1[108] = 19'h0;
		cos_c_1[109] = 19'h0;
		cos_c_1[110] = 19'h0;
		cos_c_1[111] = 19'h0;
		cos_c_1[112] = 19'h0;
		cos_c_1[113] = 19'h0;
		cos_c_1[114] = 19'h0;
		cos_c_1[115] = 19'h0;
		cos_c_1[116] = 19'h0;
		cos_c_1[117] = 19'h0;
		cos_c_1[118] = 19'h0;
		cos_c_1[119] = 19'h0;
		cos_c_1[120] = 19'h0;
		cos_c_1[121] = 19'h0;
		cos_c_1[122] = 19'h0;
		cos_c_1[123] = 19'h0;
		cos_c_1[124] = 19'h0;
		cos_c_1[125] = 19'h0;
		cos_c_1[126] = 19'h0;
		cos_c_1[127] = 19'h0;
	end
end

//end
endmodule