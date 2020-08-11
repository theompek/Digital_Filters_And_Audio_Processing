clear
close all;
%mhkos shmatwn
N=200; 

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

%Ari8mos syntelestwn filtrou
   nCoeff = 20;
   M = nCoeff;

   mu = 0.025;
%%
%WienerSystem
tic;
%Autosysxetish
[r,lag] = xcorr(u,nCoeff-1,'unbiased');
r = r(lag>=0);

%Eterosysxetish
[p,lag] = xcorr(u,d,nCoeff,'unbiased');
p = p(lag>0);

%Syntelestew Wiener
R = toeplitz(r);
wo= R \ p;   

% initialize
    y = zeros(N, 1);
    e = zeros(N, 1);
    
 for i=(nCoeff+1):N
        y(i) = wo'*u(i:-1:(i-nCoeff+1));
        e(i) = d(i) - y(i);
          
 end
 display('Wiener');
toc
%% adaptation with LMS
    
    % initialize
    y = zeros(N, 1);
    eLMS = zeros(N, 1);
    wLMS = zeros(M, 1);
    tic;
    for i=(M+1):N
        y(i) = wLMS'*u(i:-1:(i-M+1));
        eLMS(i) = d(i) - y(i);
        wLMS = wLMS + mu*eLMS(i)*u(i:-1:(i-M+1));
    end
    display('LMS');
    toc
%% adaptation with NLMS
    % initialize
    y = zeros(N, 1);
    eNLMS = zeros(N, 1);
    wNLMS = zeros(M, 1);
    a=0.1;
    tic;
    for i=(M+1):N
        y(i) = wNLMS'*u(i:-1:(i-M+1));
        eNLMS(i) = d(i) - y(i);
        wNLMS = wNLMS + (mu/(a+sum(u(i:-1:(i-M+1)).^2)))*eNLMS(i)*u(i:-1:(i-M+1));
    end
    display('NLMS');
    toc
%% adaptation with RLS
lambda = 1;
delta = 1/250;
% initialize
wRLS = zeros(M, 1);
y = zeros(N, 1);
eRLS = zeros(N, 1);

    P = (1/delta) * eye(M, M);
    tic;
    for i = (M+1):N
        y(i) =   wRLS' * u(i:-1:i-M+1);
        k = ( (lambda^-1)*P*u(i:-1:i-M+1) / (1 + (lambda^-1)*u(i:-1:i-M+1)'*P*u(i:-1:(i-M+1))) );
        eRLS(i) = d(i) - y(i);
        wRLS = wRLS + k * eRLS(i);
        P = (lambda^-1)*P - (lambda^-1)*k*u(i:-1:(i-M+1))'*P;
    end
    display('RLS');
    toc;
%%
figure(1)
subplot(2,2,1)
plot([eLMS(nCoeff+1:end) x(nCoeff+1:end)]);
xlabel('time step n');
ylabel('e(n) se sxesh me to x(n)');
legend({'output e(n)','x(n) SpeakerB signal'});
title('Echo Cancellation (LMS mu=0.025)');

subplot(2,2,2)
plot([eNLMS(nCoeff+1:end) x(nCoeff+1:end)]);
xlabel('time step n');
ylabel('e(n) se sxesh me to x(n)');
legend({'output e(n)','x(n) SpeakerB signal'});
title('Echo Cancellation (NLMS mu=0.025)');

subplot(2,2,3)
plot([eRLS(2*nCoeff+1:end) x(2*nCoeff+1:end)]);
xlabel('time step n');
ylabel('e(n) se sxesh me to x(n)');
legend({'output e(n)','x(n) SpeakerB signal'});
title('Echo Cancellation (RLS)');

subplot(2,2,4)
plot([e(nCoeff+1:end) x(nCoeff+1:end)]);
xlabel('time step n');
ylabel('e(n) se sxesh me to x(n)');
legend({'output e(n)','x(n) SpeakerB signal'});
title('Echo Cancellation Wiener');


figure(2)
subplot(2,2,1)
plot((eLMS(nCoeff+1:end)-x(nCoeff+1:end)).^2);
xlabel('time step n');
ylabel('(e(n)-x(n))^2');
legend({'(e(n)-x(n))^2'});
title('Tetragwniko sfalma LMS');

subplot(2,2,2)
plot((eNLMS(nCoeff+1:end)-x(nCoeff+1:end)).^2);
xlabel('time step n');
ylabel('(e(n)-x(n))^2');
legend({'(e(n)-x(n))^2'});
title('Tetragwniko sfalma NLMS');

subplot(2,2,3)
plot((eRLS(nCoeff+1:end)-x(nCoeff+1:end)).^2);
xlabel('time step n');
ylabel('(e(n)-x(n))^2');
legend({'(e(n)-x(n))^2'});
title('Tetragwniko sfalma RLS');

subplot(2,2,4)
plot((e(nCoeff+1:end)-x(nCoeff+1:end)).^2);
xlabel('time step n');
ylabel('(e(n)-x(n))^2');
legend({'(e(n)-x(n))^2'});
title('Tetragwniko sfalma me Wiener');

figure(3)
subplot(2,2,1)
plot((eLMS(nCoeff+1:end)-x(nCoeff+1:end)));
xlabel('time step n');
ylabel('e(n)-x(n)');
legend({'e(n)-x(n)'});
title('Aplo sfalma LMS');

subplot(2,2,2)
plot((eNLMS(nCoeff+1:end)-x(nCoeff+1:end)));
xlabel('time step n');
ylabel('e(n)-x(n)');
legend({'e(n)-x(n)'});
title('Aplo sfalma NLMS');

subplot(2,2,3)
plot((eRLS(nCoeff+1:end)-x(nCoeff+1:end)));
xlabel('time step n');
ylabel('e(n)-x(n)');
legend({'e(n)-x(n)'});
title('Aplo sfalma RLS');

subplot(2,2,4)
plot((e(nCoeff+1:end)-x(nCoeff+1:end)));
xlabel('time step n');
ylabel('e(n)-x(n)');
legend({'e(n)-x(n)'});
title('Aplo sfalma me Wiener');

figure(4)
plot([wLMS wNLMS wRLS wo]);
xlabel('time step n');
ylabel('suntelestes wLMS wNLMS wRLS wo');
legend({'wLMS','wNLMS','wRLS','woWiener'});
title('Syntelestes w');