clear
close all;
load('music.mat')
%8a xrhsimopoihsoume ena komati apo to tragoudi gia logous euxrhstias
N=800000; %/mege8os deigmatos/---/number of time steps/
begin=50000; %arxh tou deigmatos
endd=N+begin; %telos deigmatos
a=s(begin:1:endd-1); %deigma tragoudiou

%Shma me ka8usterhsh
delta=100;
Ud=zeros(N,1);
for i=delta+1:1:N
Ud(i)=a(i-delta);
end

%Ari8mos suntelestwn filtrou
nCoeff=200;
% autocorrelation r
[r,lag] = xcorr(Ud,nCoeff,'unbiased');
r = r(lag>=0);

[A, G, L, Dp] = LevinsonDurbin_iterative(nCoeff,r);
w=-A(2:end);

y=zeros(N,1);
for i=nCoeff:1:N
 y(i) = Ud(i:-1:i-(nCoeff-1))' * w; % filter
end
y=[y(delta:end);zeros(delta-1,1)];

%Pollaplasiazoume me 20 gia na dynamosoume ligo ton hxo
sound(20*(a-y),fs)