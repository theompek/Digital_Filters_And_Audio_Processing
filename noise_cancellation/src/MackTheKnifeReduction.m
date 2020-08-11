clear 
close all

load('noise.mat')
load('sound.mat')

%Pernoume ena deigma-komati tou tragoudiou apo to sunoliko pinaka
%sound (d(n)) kai apo to sima 8orivou noise u(n) epeidh to sunoliko
%tragoudi einai polu megalo kai eixa problhma mnhmhs

N=600000; %/mege8os deigmatos/---/number of time steps/
begin=1650000; %arxh tou deigmatos
endd=N+begin; %telos deigmatos
a=d(begin:1:endd-1); %deigma tragoudiou
b=u(begin:1:endd-1); %deigma 8oruvou

% autocorrelation R = E[u u']
nCoeff = 3;
q = xcorr(b,b,nCoeff-1,'unbiased');
q = q(nCoeff:(2*nCoeff-1));
R = toeplitz(q);

%Μεγιστη τιμή του μ
mu_max=2/max(eig(R));

p = [0.72; 0; 0];  % cross correlation E[u d]
wo = R \ p;

w=[-1;-1;-1];
mu = 0.032;

wt = zeros([3,N]); wt(:,1) = w;
y = zeros(N, 1);

for i=3:N
  w = w + mu*(p-R*w); % Adaptation steps
  wt(:,i) = w;
  y(i) = b(i:-1:i-2)' * w; % filter
end

%figure(1)
%subplot(2,2,1)
%plot(a)
%legend({'d(n)'})

%% parameter error

we = (wt - wo*ones(1,N)).^2;
e = sqrt(sum(we));

%subplot(2,2,2)
%semilogy(e);
%xlabel('time step n');
%ylabel('Parameter error');
%title('Parameter error');

en=a-y;
%subplot(2,2,3)
%plot([en a])
%legend({'e(n))','d(n)'})

sound(en,fs)

%Mack the knife