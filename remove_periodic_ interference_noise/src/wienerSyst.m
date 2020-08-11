clear
close all;
%Suntelestes
n=(1:1:100000).'; 
N=length(n); %mhkos shmatwn

fo=1/4;
fi=pi/2;
A=4.2;
sigmav2=0.54;
%ka8usterhsh
delta=10;

%Shma parembolhs
x=A*(sin(2*pi*fo.*n+fi) + cos(4*pi*fo.*n+fi) + cos(7*pi*fo.*n+fi/3));

%Epi8umhto shma
u = rand(N,1); u = u - mean(u); u = sqrt(sigmav2)* u / norm(u);
u=max(x).*u;
%Shma pou katagrafete
d=x+u;

%Shma me ka8usterhsh delta=10
Ud=zeros(N,1);
for i=delta+1:1:N
Ud(i)=d(i-delta);
end
%%
%Ari8mos syntelestwn filtrou
nCoeff = 100;

% autocorrelation r
[r,lag] = xcorr(Ud,nCoeff,'unbiased');
p = r(lag>0);
r = r(lag>=0);
% autocorrelation matrix R = E[u u']
[t,lag] = xcorr(Ud,nCoeff-1,'unbiased');
R = toeplitz(t(lag>=0));
%Syntelestes filtrou Wiener
wo = R \ p;

y=zeros(N,1);
for i=nCoeff:1:N
 y(i) = Ud(i:-1:i-(nCoeff-1))'* wo; % filter
end  
y=[y(delta:end);zeros(delta-1,1)];

%%
%Sunarthsh Levinson tou Matlab gia ton ypologismo
%twn backward kai forward prediction erros
[weight_mat, Po_mat]=levinson(r,nCoeff);

%Forward/Backward prediction error Lecture 7 selida 4
Po=r(1)-r(2:end)'*wo;

%Forward/Backward prediction error
fprintf('Forward/Backward prediction power error: %e\n', Po-Po_mat);

%%
sfalma=u-(d-y);
%Ypologizoume to sflama meta apo tis protes nCoeff times
sfalma=sfalma(nCoeff+1:end);
fprintf('Tergagomiko sfalma shmatos filtrou e(n) kai epi8umhtou u(n): %e\n', mean(sfalma.^2));

figure(1);
plot([(d(500:650)-y(500:650)) u(500:650)])
title('Shma meta apo thn aferesh foruvou se sugrish me to epi8ymhto')
legend({'d(n)-y(n)','u(n)'})

