# AWGN_IP

Softwares required: MATLAb 2016 or better, Modelsim PE edu 10.4a or better

Important notes:
Assumed that seed values,clock are available before reset is pulled to 0.

Instructions:
Clone the repository onto your device to access the project.

Open seed_decimal.txt . Enter the values of the 6 seeds. Note that these seeds must be non trival (ie not 0) and sufficiently large.

Open MATLAB. Give the appropriate path so that the project is visible.

Open try1.m and click run.
The following files will be created: norm_dist_values.txt, sqrt_values.txt, cosin_values.txt, log_values.txt, seed_hex.txt
You will also see the histohram of the normal distribution values generated and the result of kstest on the console(it should br 0)

Open ModelSim. Hover over file, click open project.

A window appears. Search for AWGN.mpf and click it to open the AWGN project. Click the library tab on the left side, expand work tab and click tb_AWGN.

The simulation window opens. On the left is the top module and the instantiated sub modules.In the middle is the objects window ehich show the different signals dor the hilighted odule on the left (default is top). And on the right is the wave window where you can see the simulation results. You can add the signals you want by right clicking the signal in the objects window and selecting the 'add wave' option. Similarly you can delete signals in the wave window by rightclicking the signal and selecting Edit->Delete. 

Run the simulation for 100500ns.

Observe the error signals for awgn, cosine, log and square root. if the difference between theoretical and actual value exceed the threshold, the respective error signal is incremented.You can also view the output of the awgn core by viewing the awgn_out signal.

Important comments:
You can get the coefficients for the polynomials by using the fminimax and polyfit functions however they are a part of the optimization toolchain that are not included in the standard MATLAB software that I have(it costs $30 to buy the toolchain from Mathworks). So I used a software called MAPLE. It has a function called minimax which does the same thing. And the best thing is that it has a trial version that is available for 15 days for a cost of only $10. The coefficients obtained by this function in MAPLE corroborate with the results in the paper mentioned in the documentation. The error between the polynomial approximation and the actual matlab function is identical to the similar error E_approx  considered in the paper.
