%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                    Polynomial aproximation of cos(2.pi.x)               % 
%                                   By                                    % 
%                           Santosh Kumar Krishnan                        % 
%                                                                         %
%                           Software verification                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Copyright (C) 2016  Santosh Kumar Krishnan
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see http://www.gnu.org/licenses/.

function res = my_cosine(ii,cos_c_0,cos_c_1)
    ii = bitsll(ii,16);
    ii = floor(ii);
    check = bitand(ii,49152);
    dec = bitand(ii,16383);
    negdec = 16383 - dec;
    dec = bitsra(dec,14);
    negdec = bitsra(negdec,14);
    check = bitsra(check,14);
    check = floor(check);
    ls = bitsll(dec,7);
    ls = floor(ls);
    ls = bitand(ls,127);
    c_0 = cos_c_0(1,ls+1);
    c_0 = bitsll(c_0,18);
    c_0 = floor(c_0);
    c_0 = bitsra(c_0,18);
    c_1 = cos_c_1(1,ls+1);
    c_1 = bitsll(c_1,18);
    c_1 = floor(c_1);
    c_1 = bitsra(c_1,18);
    x = bitsll(dec,14);
    x = floor(x);
    x = bitsra(x,14); 
    cosine_ap_p=c_0 - c_1*x;
    ls = bitsll(negdec,7);
    ls = floor(ls);
    ls = bitand(ls,127);
    c_0 = cos_c_0(1,ls+1);
    c_0 = bitsll(c_0,18);
    c_0 = floor(c_0);
    c_0 = bitsra(c_0,18);
    c_1 = cos_c_1(1,ls+1);
    c_1 = bitsll(c_1,18);
    c_1 = floor(c_1);
    c_1 = bitsra(c_1,18);
    x = bitsll(negdec,14);
    x = floor(x);
    x = bitsra(x,14); 
    cosine_ap_n=c_0 - c_1*x;
    switch check
        case 0
            res = cosine_ap_p;
        case 1
            res = cosine_ap_n*(-1);
        case 2
            res = cosine_ap_p*(-1);
        case 3 
            res = cosine_ap_n;
    end
end