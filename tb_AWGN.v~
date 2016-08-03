///////////////////////////////////////////////////////////////////////////
//                                                                       //
//			              AWGN Verilog Testbench                         //
//                                  By                                   //
//                        Santosh Kumar Krishnan                         //
//                                                                       //
//                              TESTBENCH                                //
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

//simulator clock planned is of 10ns

module tb_AWGN ();

//internal registers
reg clk;
reg reset;
reg [31:0] seed_arr[5:0];
reg [31:0] urng_seed1;
reg [31:0] urng_seed2;
reg [31:0] urng_seed3;
reg [31:0] urng_seed4;
reg [31:0] urng_seed5;
reg [31:0] urng_seed6;
reg [15:0] curr_awgn_val,diff_awgn,from_table_awgn;
reg [16:0] curr_cosine_val,diff_cosine,from_table_cosine;
reg [16:0] curr_sqrt_val,diff_sqrt,from_table_sqrt;
reg [30:0] curr_log_val,diff_log,from_table_log;
reg [15:0] awgn_check[9999:0];
reg [30:0] log_check[9999:0];
reg [16:0] cosine_check[9999:0];
reg [16:0] sqrt_check[9999:0];
reg start;
reg stop;
integer is_open0,is_open1,is_open2,is_open3,is_open4;
integer i,error_awgn,error_cosin,error_log,error_sqrt;

//output from top level entity
wire [15:0] awgn_out;

//initialize the values
initial begin

//at time = 0,
	i = 0;
	
//error counters.
//if the absolute difference between theoretical answer and actual answer is greater than the threshold, 
//the respective counters are incremented.
	error_awgn = 0;
	error_cosin = 0;
	error_log = 0;
	error_sqrt = 0;
	
//initial value of clock @ t=0ns
	clk = 1'b1;
	
//reset is set @t=0ns
	reset = 1'b1;
	
//start verification indicator is reset @t=0ns
	start = 1'b0;
	
//stop verification indicator is reset @t=0ns
	stop = 1'b0;
	
//they store the current output value of the awgn module, absolute difference between thertotical and obtained values, and current therotical value respectively
	curr_awgn_val = 16'h0;
	diff_awgn = 16'h0;
	from_table_awgn = 16'h0;
	
//they store the current output value of the cosine sub-module, absolute difference between thertotical and obtained values, and current therotical value respectively
	curr_cosine_val = 17'h0;
	diff_cosine = 17'h0;
	from_table_cosine = 17'h0;
	
//they store the current output value of the log sub-module, absolute difference between thertotical and obtained values, and current therotical value respectively
	curr_log_val = 31'h0;
	diff_log = 31'h0;
	from_table_log = 31'h0;
	
//they store the current output value of the square root sub module, absolute difference between thertotical and obtained values, and current therotical value respectively
	curr_sqrt_val = 17'h0;
	diff_sqrt = 17'h0;
	from_table_sqrt = 17'h0;
		
//read the therotical values from the files ind store them into the respective register array.
	is_open0 = $fopen("seed_hex.txt","r");
	is_open1 = $fopen("norm_dist_values.txt","r");
	is_open2 = $fopen("cosin_values.txt","r");
	is_open3 = $fopen("log_values.txt","r");
	is_open4 = $fopen("sqrt_values.txt","r");
	
//are the files available?
	if(is_open1 == 0 || is_open2 == 0 || is_open3 == 0 || is_open4 == 0)
		$display("error in opening file");
	else
	begin
// begin reading the files.
		$readmemh("seed_hex.txt",seed_arr);
		$readmemh("norm_dist_values.txt",awgn_check);
		$readmemh("cosin_values.txt",cosine_check);
		$readmemh("log_values.txt",log_check);
		$readmemh("sqrt_values.txt",sqrt_check);
	end
	
//initial seed values.
	urng_seed1 = seed_arr[0];
	urng_seed2 = seed_arr[1];
	urng_seed3 = seed_arr[2];
	urng_seed4 = seed_arr[3];
	urng_seed5 = seed_arr[4];
	urng_seed6 = seed_arr[5];
	
//reset is pulled down to 0 @t=10ns
	#10 reset = 1'b0;
	
//start verification indicator signal is set @t = 50ns.
	#40 start = 1'b1;
end

//always block for clock
always
 #5 clk = ~clk; // every five nanoseconds invert

//instantiate the AWGN module; 
AWGN AW(.clock(clk),
.reset(reset),
.urng_seed1(urng_seed1),
.urng_seed2(urng_seed2),
.urng_seed3(urng_seed3),
.urng_seed4(urng_seed4),
.urng_seed5(urng_seed5),
.urng_seed6(urng_seed6),
.awgn_out(awgn_out));

//always block for comparison
always@(posedge clk)
begin
//start = 0? dont start verification
	if(start == 1'b0)
	begin
		$display("verification not started");
	end
	else
	begin
		//verification has started.
		if(stop == 1'b0)
		begin
			curr_awgn_val = tb_AWGN.AW.awgn_out;
			from_table_awgn = awgn_check[i]; 
			curr_cosine_val = tb_AWGN.AW.COS.value;
			from_table_cosine = cosine_check[i+1];
			curr_log_val = tb_AWGN.AW.LOG.value;
			from_table_log = log_check[i+1];
			curr_sqrt_val = tb_AWGN.AW.SQ_RT.value;
			from_table_sqrt = sqrt_check[i];
			
			//AWGN VERIFICATION
			if(curr_awgn_val > awgn_check[i])
				diff_awgn = curr_awgn_val - awgn_check[i];
			else
				diff_awgn = awgn_check[i] - curr_awgn_val;
			if(diff_awgn > 16'h0001)
			begin
				$display("error at %d",i);
				error_awgn = error_awgn+1;
			end 
			
			//COSINE VERIFICATION.
			if(curr_cosine_val > cosine_check[i+1])
				diff_cosine = curr_cosine_val - cosine_check[i+1];
			else
				diff_cosine = cosine_check[i+1] - curr_cosine_val;
			if(diff_cosine > 17'h00001)
			begin
				$display("error at %d",i);
				error_cosin = error_cosin+1;
			end 
			
			//LOG VERIFICATION
			if(curr_log_val > log_check[i+1])
				diff_log = curr_log_val - log_check[i+1];
			else
				diff_log = log_check[i+1] - curr_log_val;
			if(diff_log > 31'h00000020)
			begin
				$display("error at %d",i);
				error_log = error_log+1;
			end
			
			//SQUARE ROOT VERIFICATION
			if(curr_sqrt_val > sqrt_check[i])
				diff_sqrt = curr_sqrt_val - sqrt_check[i];
			else
				diff_sqrt = sqrt_check[i] - curr_sqrt_val;
			if(diff_sqrt > 17'h00001)
			begin
				$display("error at %d",i);
				error_sqrt = error_sqrt+1;
			end
			i = i+1;
			if(i == 9999)
				stop = 1'b1;
		end
		else
		begin
			//verification has ended.
			$display("verification has ended");
		end
	end
end

endmodule