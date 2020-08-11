clear 
Blocks=20;
n =Blocks*1024; % time steps
T = 5; % number of independent trials
var = 0.57; % noise variance
L = 1024; % order of the filter

subplot(2,2,1)
block_lms1;
subplot(2,2,2)
block_lms2;
subplot(2,2,3)
block_lms3;
subplot(2,2,4)
block_lms4;