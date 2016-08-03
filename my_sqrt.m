%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    __                   %
%                       Polynomial aproximation of \/x                    % 
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

function res = my_sqrt(ii,sqrt_1_2_c_0,sqrt_1_2_c_1,sqrt_2_4_c_0,sqrt_2_4_c_1)
    ii = bitsll(ii,25);
    ii = floor(ii);
    ii = bitand(ii,4294967295);
    ii = bitsra(ii,25);
    jj =ii;
    count = 0;
    if(jj == 0)
        count = 31;
    else
        while(jj <= 64)
            jj = jj*2;
            count = count + 1;
        end
    end
    expo = 5 - count;
    expo_p = expo;
    if(rem(expo_p,2) == 0)
        check_p = 0;
        expo_sq = expo/2;
    else
        check_p = 1;
        expo_sq = (expo+1)/2;
    end
    if(expo >= 0)
        ii = bitsra(ii,expo);
        ii = bitsll(ii,25);
        ii = floor(ii);
        ii = bitand(ii,4294967295);
        ii = bitsra(ii,25);
    else
        ii = bitsll(ii,abs(expo));
        ii = bitsll(ii,25);
        ii = floor(ii);
        ii = bitand(ii,4294967295);
        ii = bitsra(ii,25);
    end
    if(check_p == 1)
        ii = bitsra(ii,1);
        ii = bitsll(ii,25);
        ii = floor(ii);
        ii = bitand(ii,4294967295);
        ii = bitsra(ii,25);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ls = bitsll(ii,6);
        ls = floor(ls);
        ls = bitand(ls,63);
        c_0 = sqrt_1_2_c_0(1,ls+1);
        c_0 = bitsll(c_0,19);
        c_0 = floor(c_0);
        c_0 = bitsra(c_0,19);
        c_1 = sqrt_1_2_c_1(1,ls+1);
        c_1 = bitsll(c_1,18);
        c_1 = floor(c_1);
        c_1 = bitsra(c_1,18);
        x = bitsll(ii,16);
        x = floor(x);
        x = bitsra(x,16);
        sqrt_ap = c_0 + c_1*x;
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2-4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ls = bitsll(ii,5);
        ls = floor(ls);
        ls = bitand(ls,63);
        c_0 = sqrt_2_4_c_0(1,ls+1);
        c_0 = bitsll(c_0,19);
        c_0 = floor(c_0);
        c_0 = bitsra(c_0,19);
        c_1 = sqrt_2_4_c_1(1,ls+1);
        c_1 = bitsll(c_1,18);
        c_1 = floor(c_1);
        c_1 = bitsra(c_1,18);
        x = bitsll(ii,16);
        x = floor(x);
        x = bitsra(x,16);
        sqrt_ap = c_0 + c_1*x;
    end
    
    if(expo_sq >=0)
        sqrt_ap = bitsll(sqrt_ap,expo_sq);
    else
        sqrt_ap = bitsra(sqrt_ap,abs(expo_sq));
    end;
    sqrt_ap = bitsll(sqrt_ap,13);
    sqrt_ap = floor(sqrt_ap);
    sqrt_ap = bitand(sqrt_ap,131071);
    sqrt_ap = bitsra(sqrt_ap,13);
    res = sqrt_ap;
end
