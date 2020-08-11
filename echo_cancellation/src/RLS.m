clear
close all;
%mhkos shmatwn
N=300; 

sigmaU=0.32; %SpeakerA
sigmaX=0.56; %SpeakerB
sigmaU1=0.42;
sigmaU2=0.72;

%Noise
u1 = sqrt(sigmaU1).*randn(N,1);  u1=u1-mean(u1);
u2 = sqrt(sigmaU2).*randn(N,1);  u2=u2-mean(u2);

%SpeakerA
u = sqrt(sigmaU).*randn(N,1);  u=u-mean(u);

for i=4:1:N
u(i)= -0.87*u(i-1)-0.22*u(i-2)+0.032*u(i-3)+u1(i);
end

%SpeakerB
x = sqrt(sigmaX).*randn(N,1);  x=x-mean(x);

for i=4:1:N
x(i)=-0.57*u(i-1)-0.16*u(i-2)+0.08*u(i-3)+u2(i);
end

%Echo
s=zeros(N,1);
for i=4:1:N
s(i)= -0.13*u(i)+0.67*u(i-1)-0.18*u(i-2)+0.39*u(i-3);
end

%Desired sign
d=s+x;

%% adaptation with RLS
%Ari8mos syntelestwn filtrou
nCoeff = 10;
lambda = 1;
delta = 1/250;
M=nCoeff;
% initialize
wr = zeros(M, 1);
y = zeros(N, 1);
e = zeros(N, 1);
Jr = zeros(N, 1);



    P = (1/delta) * eye(M, M);
    for i = (M+1):N
        y(i) =   wr' * u(i:-1:i-M+1);
        k = ( (lambda^-1)*P*u(i:-1:i-M+1) / (1 + (lambda^-1)*u(i:-1:i-M+1)'*P*u(i:-1:(i-M+1))) );
        e(i) = d(i) - y(i);
        wr = wr + k * e(i);
        P = (lambda^-1)*P - (lambda^-1)*k*u(i:-1:(i-M+1))'*P;
        %Jr(i) = (e(i)-x(i)).^2;
    end

figure(1)
plot([e(nCoeff+1:end) x(nCoeff+1:end)]);
xlabel('time step n');
ylabel('e(n) se sxesh me to x(n)');
legend({'output e(n)','x(n) SpeakerB signal'});
title('Echo Cancellation (RLS)');
