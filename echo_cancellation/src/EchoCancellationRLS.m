clear
close all;

load('speakerA.mat')
load('speakerB.mat')

%8a xrhsimopoihsoume ena komati apo to tragoudi gia logous euxrhstias
N=200000; %/mege8os deigmatos/---/number of time steps/
begin=50000; %arxh tou deigmatos
endd=N+begin; %telos deigmatos
u=u(begin:1:endd-1); %deigma 
d=d(begin:1:endd-1);
%Ari8mos syntelestwn filtrou
nCoeff = 6600;

%% adaptation with RLS
lambda = 1;
delta = 1/250;
M=nCoeff;
% initialize
wr = zeros(M, 1);
y = zeros(N, 1);
e = zeros(N, 1);

    P = (1/delta) * eye(M, M);
    for i = (M+1):N
        y(i) =   wr' * u(i:-1:i-M+1);
        k = ( (lambda^-1)*P*u(i:-1:i-M+1) / (1 + (lambda^-1)*u(i:-1:i-M+1)'*P*u(i:-1:(i-M+1))) );
        e(i) = d(i) - y(i);
        wr = wr + k * e(i);
        P = (lambda^-1)*P - (lambda^-1)*k*u(i:-1:(i-M+1))'*P;
   end

player = audioplayer(e,fs);
play(player);
