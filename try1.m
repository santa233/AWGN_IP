%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                       AWGN verification and analysis                    % 
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

clc;
close all;

s_0 = 0;
s_1 = 0;
s_2 = 0;

s_3 = 0;
s_4 = 0;
s_5 = 0;

x = zeros(1,10000);

fid0 = fopen('seed_decimal.txt','r');
fid5 = fopen('seed_hex.txt','wt');
Seed_values = fgetl(fid0);
seed_nos = 1;

%read the seed values from the text file, innitialize the variables and 
%write the hex value to a text file. 
while ischar(Seed_values)
    if(seed_nos == 1)
        s_0 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_0,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    if(seed_nos == 2)
        s_1 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_1,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    if(seed_nos == 3)
        s_2 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_2,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    if(seed_nos == 4)
        s_3 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_3,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    if(seed_nos == 5)
        s_4 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_4,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    if(seed_nos == 6)
        s_5 = str2num(Seed_values);
        seed_hex_val = dec2hex(s_5,8);
        fprintf(fid5,'%s\n',seed_hex_val);
    end
    Seed_values = fgetl(fid0);
    seed_nos = seed_nos+1;
end

fid1 = fopen('norm_dist_values.txt','wt');
fid2 = fopen('cosin_values.txt','wt');
fid3 = fopen('log_values.txt','wt');
fid4 = fopen('sqrt_values.txt','wt');

%load the coefficients
load('cos_c_0.mat');
load('cos_c_1.mat');
load('sqrt_1_2_c_0.mat');
load('sqrt_1_2_c_1.mat');
load('sqrt_2_4_c_0.mat');
load('sqrt_2_4_c_1.mat');
load('ln_c_0.mat');
load('ln_c_1.mat');
load('ln_c_2.mat');

%for 10000 samples...
for i = 1:10000
    
%___________________Traunsworthe URNG_0____________________________________    
    % b0 = (((s0 << 13 ) ^ s0) >> 19)
    g1 = bitsll(s_0,13);
    g1 = bitand(g1,4294967295);
    g1 = bitxor(g1,s_0);
    if(g1 == 1 || g1 == 0)
        if(g1 == 1)
            b0 = bitsra(1,19);
        else
            b0 = bitsra(0,19);
        end
    else
        b0 = bitsra(g1,19);
    end
    b0 = floor(b0);

    %s0 = (((s0 & 0xFFFFFFFE) << 12) ^ b0) 
    g2 = bitand(s_0 , 4294967294);
    if(g2 == 1 || g2 == 0)
        if(g2 == 1)
            g3 = bitsll(1,12);
            g3 = bitand(g3,4294967295);
        else
            g3 = bitsll(0,12);
            g3 = bitand(g3,4294967295);
        end
    else
        g3 = bitsll(g2,12);
        g3 = bitand(g3,4294967295);
    end
    s_0 = bitxor(g3, b0);

    % b0 = (((s1 << 2 ) ^ s1) >> 25)
    g4 = bitsll(s_1,2);
    g4 = bitand(g4,4294967295);
    g4 = bitxor(g4,s_1);
    if(g4 == 1 || g4 == 0)
        if(g4 == 1)
            b0 = bitsra(1,25);
        else
            b0 = bitsra(0,25);
        end
    else
        b0 = bitsra(g4,25);
    end
    b0 = floor(b0);

    %s1 = (((s1 & 0xFFFFFFF8) << 4) ^ b0) 
    g5 = bitand(s_1 , 4294967288);
    if(g5 == 1 || g5 == 0)
        if(g5 == 1)
            g6 = bitsll(1,4);
            g6 = bitand(g6,4294967295);
        else
            g6 = bitsll(0,4);
            g6 = bitand(g6,4294967295);
        end
    else
        g6 = bitsll(g5,4);
        g6 = bitand(g6,4294967295);
    end
    s_1 = bitxor(g6, b0);

    % b0 = (((s2 << 3 ) ^ s2) >> 11)
    g7 = bitsll(s_2,3);
    g7 = bitand(g7,4294967295);
    g7 = bitxor(g7,s_2);
    if(g7 == 1 || g7 == 0)
        if(g7 == 1)
            b0 = bitsra(1,11);
        else
            b0 = bitsra(0,11);
        end
    else
        b0 = bitsra(g7,11);
    end
    b0 = floor(b0);

    %s2 = (((s2 & 0xFFFFFFF0) << 17) ^ b0) 
    g8 = bitand(s_2 , 4294967280);
    if(g8 == 1 || g8 == 0)
        if(g8 == 1)
            g9 = bitsll(1,17);
            g9 = bitand(g9,4294967295);
        else
            g9 = bitsll(0,17);
            g9 = bitand(g9,4294967295);
        end
    else
        g9 = bitsll(g8,17);
        g9 = bitand(g9,4294967295);
    end
    s_2 = bitxor(g9, b0);
    
    %u0 = s0 ^ s1 ^ s2
    p1 = bitxor(s_0,s_1);
    p1_1 = (bitxor(p1,s_2));
    u_0 = bitsra(p1_1,32);
    
%___________________Traunsworthe URNG_1____________________________________
    % b1 = (((s3 << 13 ) ^ s3) >> 19)
    g10 = bitsll(s_3,13);
    g10 = bitand(g10,4294967295);
    g10 = bitxor(g10,s_3);
    if(g10 == 1 || g10 == 0)
        if(g10 == 1)
            b1 = bitsra(1,19);
        else
            b1 = bitsra(0,19);
        end
    else
        b1 = bitsra(g10,19);
    end
    b1 = floor(b1);

    %s1 = (((s1 & 0xFFFFFFFE) << 12) ^ b1)
    g11 = bitand(s_3 , 4294967294);
    if(g11 == 1 || g11 == 0)
        if(g11 == 1)
            g12 = bitsll(1,12);
            g12 = bitand(g12,4294967295);
        else
            g12 = bitsll(0,12);
            g12 = bitand(g12,4294967295);
        end
    else
        g12 = bitsll(g11,12);
        g12 = bitand(g12,4294967295);
    end
    s_3 = bitxor(g12, b1);

    % b1 = (((s4 << 2 ) ^ s4) >> 25)
    g13 = bitsll(s_4,2);
    g13 = bitand(g13,4294967295);
    g13 = bitxor(g13,s_4);
    if(g13 == 1 || g13 == 0)
        if(g13 == 1)
            b1 = bitsra(1,25);
        else
            b1 = bitsra(0,25);
        end
    else
        b1 = bitsra(g13,25);
    end
    b1 = floor(b1);

    %s4 = (((s4 & 0xFFFFFFF8) << 4) ^ b1) 
    g14 = bitand(s_4 , 4294967288);
    if(g14 == 1 || g14 == 0)
        if(g14 == 1)
            g15 = bitsll(1,4);
            g15 = bitand(g15,4294967295);
        else
            g15 = bitsll(0,4);
            g15 = bitand(g15,4294967295);
        end
    else
        g15 = bitsll(g14,4);
        g15 = bitand(g15,4294967295);
    end
    s_4 = bitxor(g15, b1);

    % b1 = (((s5 << 3 ) ^ s5) >> 11)
    g16 = bitsll(s_5,3);
    g16 = bitand(g16,4294967295);
    g16 = bitxor(g16,s_5);
    if(g16 == 1 || g16 == 0)
        if(g16 == 1)
            b1 = bitsra(1,11);
        else
            b1 = bitsra(0,11);
        end
    else
        b1 = bitsra(g16,11);
    end
    b1 = floor(b1);

    %s5 = (((s5 & 0xFFFFFFF0) << 17) ^ b1) 
    g17 = bitand(s_5 , 4294967280);
    if(g17 == 1 || g17 == 0)
        if(g17 == 1)
            g18 = bitsll(1,17);
            g18 = bitand(g18,4294967295);
        else
            g18 = bitsll(0,17);
            g18 = bitand(g18,4294967295);
        end
    else
        g18 = bitsll(g17,17);
        g18 = bitand(g18,4294967295);
    end
    s_5 = bitxor(g18, b1);

    %u0 = s3 ^ s4 ^ s5
    p1 = bitxor(s_3,s_4);
    p1_1 = (bitxor(p1,s_5));
    u_1 = bitsra(p1_1,32);
    
%__________U_0 and U_1 transforms to 48 and 16 bits respectively___________   
    
    u_0_1 = bitsll(u_0,32);
    u_1_1 = bitsll(u_1,32);
    u_0_1 = bitsll(u_0_1,16);
    first_part = bitand(u_1_1,4294901760);
    second_part = bitand(u_1_1,65535);
    first_part = bitsra(first_part,16);
    first_part = floor(first_part);
    u_0_1 = u_0_1 + first_part;
    u_0_1 = bitsra(u_0_1,48);
    u_1_1 = second_part;
    u_1_1 = bitsra(u_1_1,16);

%_________________________lnval_my = -2ln(u_0_1)___________________________
    lnval_my = my_log(u_0_1,ln_c_0,ln_c_1,ln_c_2);
    
%_______________________sq_roor_my = sqrt(lnval_my)________________________    
    sq_root_my = my_sqrt(lnval_my,sqrt_1_2_c_0,sqrt_1_2_c_1,sqrt_2_4_c_0,sqrt_2_4_c_1);
    
%_____________________cosine_val_my = cos(2*pi*u_1_1)______________________    
    cosin_val_my = my_cosine(u_1_1,cos_c_0,cos_c_1);

%______________answer = square root answer * cosine answer ________________
    see = sq_root_my * cosin_val_my;
    x(1,i) = see;
    
%________convert answer into hex and store it in the relevant file_________
    jpc1 = bitsll(see,11);
    jpc1 = floor(jpc1);
    if(jpc1 < 0)
        jpc1 = ndec2hex(jpc1,16);
    else
        jpc1= dec2hex(jpc1,4);
    end
    fprintf(fid1,'%s\n',jpc1);
    
%______convert cosin_val_my into hex and store it in the relevant file_____    
    jpc2 = bitsll(cosin_val_my,15);
    jpc2 = floor(jpc2);
    if(jpc2 < 0)
        jpc2 = ndec2hex(jpc2,17);
    else
        jpc2= dec2hex(jpc2,5);
    end
    fprintf(fid2,'%s\n',jpc2);
    
%________convert lnval_my into hex and store it in the relevant file_______
    jpc3 = bitsll(lnval_my,24);
    jpc3 = floor(jpc3);
    if(jpc3 < 0)
        jpc3 = ndec2hex(jpc3,31);
    else
        jpc3= dec2hex(jpc3,8);
    end
    fprintf(fid3,'%s\n',jpc3);
    
%_______convert sq_root_my into hex and store it in the relevant file______    
    jpc4 = bitsll(sq_root_my,13);
    jpc4 = floor(jpc4);
    if(jpc4 < 0)
        jpc4 = ndec2hex(jpc4,17);
    else
        jpc4= dec2hex(jpc4,5);
    end
    fprintf(fid4,'%s\n',jpc4);
end
%____________________Kolmogorov–Smirnov test result________________________
kstest(x)
%_________________________histogram of result______________________________
histogram(x)
%___________________________close all files________________________________
fclose(fid0);
fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);
fclose(fid5);