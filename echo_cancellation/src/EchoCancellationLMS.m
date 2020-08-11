
close all;

load('speakerA.mat')
load('speakerB.mat')


%8a xrhsimopoihsoume ena komati apo to tragoudi gia logous euxrhstias
N=400000; %/mege8os deigmatos/---/number of time steps/
begin=50000; %arxh tou deigmatos
endd=N+begin; %telos deigmatos
u=u(begin:1:endd-1); %deigma 
d=d(begin:1:endd-1);

%% adaptation with LMS
% initialize
%Ari8mos syntelestwn filtrou
nCoeff = 6600;
y = zeros(N, 1);
e = zeros(N, 1);
w = zeros(nCoeff, 1);
mu = 0.00025;

    for i=(nCoeff+1):N
        y(i) = w'*u(i:-1:(i-nCoeff+1));
        e(i) = d(i) - y(i);
        w = w + mu*e(i)*u(i:-1:(i-nCoeff+1));
    
    end
   
player = audioplayer(e,fs);
play(player);

