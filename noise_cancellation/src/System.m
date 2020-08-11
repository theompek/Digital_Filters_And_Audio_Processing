clear 
close all

%rng(0,'twister'); %initialize the random number generator 
                  %to make the results in this example repeatable

N = 50; % number of time steps

%% signal A(n)
A = sqrt(0.15)*randn(N,1); 
%A = A - mean(A);

%The signal sin(...)
n=0:1:N-1;
Sin=sin((pi/8)*n+pi/6)';

%The signal X(n)
X=A.*Sin;

%Noise
Un = sqrt(0.32)*randn(N,1); Un = Un - mean(Un); % white noise

% Desired signal
d=X+Un; % add noise

u = zeros(N,1);

u(1) = Un(1);
u(2) = 0.25*u(1)+Un(2);

for i=3:N
  u(i) =0.25*u(i-1) - 0.12*u(i-2) + Un(i);
end

%% fir filter

% autocorrelation R = E[u u']
R = [0.3417 0.0763 -0.0219;
    0.0763 0.3417 0.0763;
    -0.0219 0.0763 0.3417]; % autocorrelation E[u u']
p = [0.32; 0; 0];  % cross correlation E[u d]
wo = R \ p;

%Μεγιστη τιμή του μ
mu_max=2/max(eig(R));

w=[-1;-1;-1];
mu =1;

wt = zeros([3,N]); wt(:,1) = w;
y = zeros(N, 1);

for i=3:N
  w = w + mu*(p-R*w); % Adaptation steps
  wt(:,i) = w;
  y(i) = u(i:-1:i-2)' * w; % filter
end

%Grafikh apeikonhsh apotelesmatwn
figure(1)

subplot(2,2,1)
plot([d X])
legend({'d(n)','X(n)'})
title('Επιθυμητό σήμα Χ(n) και με θόρυβο d(n))');

%% parameter error

we = (wt - wo*ones(1,N)).^2;
e = sqrt(sum(we));

subplot(2,2,2)
semilogy(e);
xlabel('time step n');
ylabel('Parameter error');
title('Parameter error');

en=d-y;

subplot(2,2,3)
plot([en X])
legend({'e(n))','X(n)'})
title('Αποθορυβοποιημένο e(n) και επιθυμητό Χ(n)');
xlabel('αριθμός δείγματος Ν=50 συντελεστής μ=1');

subplot(2,2,4)
plot([wt(1,:)' wt(2,:)' wt(3,:)'])
legend({'w0','w1','w2'})
title('Συντελεστές wo,w1,w2');
xlabel('αριθμός δείγματος Ν=50 συντελεστής μ=1');
