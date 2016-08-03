%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                     Polynomial aproximation of -2ln(x)                  % 
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

function res = my_log(ii,ln_c_0,ln_c_1,ln_c_2)
    ii = bitsll(ii,47);
    ii = floor(ii);
    ii = bitand(ii,281474976710655);
    ii = bitsra(ii,47);
    jj =ii;
    count = 0;
    if(jj == 0 )
        count = 48;
    else
        while(jj < 1)
            jj = jj*2;
            count = count + 1;
        end
    end
    expo = count;
    ii = bitsll(ii,count);
    ii = bitsll(ii,47);
    ii = floor(ii);
    ii = bitand(ii,281474976710655);
    ii = bitsra(ii,47);
    ls = bitsll(ii,8);
    ls = floor(ls);
    ls = bitand(ls,255);
    c_0 = ln_c_0(1,ls+1);
    c_0 = bitsll(c_0,30);
    c_0 = floor(c_0);
    c_0 = bitsra(c_0,30);
    c_1 = ln_c_1(1,ls+1);
    c_1 = bitsll(c_1,22);
    c_1 = floor(c_1);
    c_1 = bitsra(c_1,22);
    c_2 = ln_c_2(1,ls+1);
    c_2 = bitsll(c_2,18);
    c_2 = floor(c_2);
    c_2 = bitsra(c_2,18);
    ii = bitsll(ii,28);
    ii = floor(ii);
    ii = bitsra(ii,28);
    ln_ap = c_2*ii*ii - c_1*ii + c_0;
    ln_ap = ln_ap + 2*log(2)*expo;
    res = ln_ap;
end
