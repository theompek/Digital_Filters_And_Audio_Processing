
%clear 
%n =15*1024; % time steps
%T = 5; % number of independent trials
%var = 0.57; % noise variance
%L = 1024; % order of the filter

%% channel

mu = [0.0015];
mtrials = length(mu);
average_Jm = zeros(n, mtrials);

%Blocks Number 
Blocks=n/L;
tic;
for t=1:T
%%
for mi=1:mtrials

    u=var*randn(n,1); %Input
    
    % initialize
    w = zeros(L, 1);
    y = zeros(n, 1);
    e = zeros(n, 1);
    J = zeros(n, 1);
    %To epi8umhto shma e3odou apo to plant
    d=plant(u.').';
    
%Loop, BlockLMS
for k=1:Blocks-1
%To dhgma timwn tou u mhkous 2*L 
U_ = u(k*L-L+1:1:k*L+L);
%FFT metasxhmatismos
fftU_=fft(U_);
%Ypologismos tou y,e3iswsh 1 selida 15 Lecture 6
C_=ifft(fft([w ; zeros(L,1)]).*fftU_);
y(k*L+1:1:(k+1)*L)=C_(L+1:1:2*L);
%Sfalma
ev=d(k*L+1:1:(k+1)*L)-y(k*L+1:1:(k+1)*L);
%Ypologimsos tou phi,e3iswsh 2 selida 15 Lecture 6
qq=ifft(fft([zeros(L,1) ; ev]).*(fftU_').');
phi=qq(1:1:L);
%Apo8ukeush tou sfalmatos
e(k*L:1:(k+1)*L-1)=ev;
J(k*L:1:(k+1)*L-1) = e(k*L:1:(k+1)*L-1).^2;
average_Jm(k*L:1:(k+1)*L-1, mi) = average_Jm(k*L:1:(k+1)*L-1, mi) + J(k*L:1:(k+1)*L-1);
%Ypologimsos twn suntelestwn w,e3iswsh 3 selida 15 Lecture 6
w=ifft(fft([w;zeros(L,1)])+mu(mi)*fft([phi;zeros(L,1)]));
w=w(1:1:L);
end
           
end

end
time=toc;

%sunolikos xronos ekteleshs algori8mou BlockLMS
display(['BlockLms3-->Total time is ',num2str(time),' seconds'])

average_Jm = average_Jm / T;

%figure(1)
semilogy(average_Jm(L+1:end,:));
xlabel('time step n');
ylabel('Ee^{2}(n)');
legend({'mu=0.0015'});
title(['Learning curve-Blocks=',num2str(Blocks)]);

%figure(2)
%plot(d(L:end)-y(L:end));
%xlabel('time step n');
%ylabel('d-y');
%legend({'mu=0.0015'});
%title('Difference d-y');