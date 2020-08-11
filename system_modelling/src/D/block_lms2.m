
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
%Dhmiourgoume ton katallhlo pinaka tou u 
umat=toeplitz(u(k*L:1:(k+1)*L-1),u(k*L:-1:(k-1)*L+1));
y(k*L:1:(k+1)*L-1)=umat*w;
%Sfalma
ev=d(k*L:1:(k+1)*L-1)-y(k*L:1:(k+1)*L-1);
e(k*L:1:(k+1)*L-1)=ev;
J(k*L:1:(k+1)*L-1) = e(k*L:1:(k+1)*L-1).^2;
average_Jm(k*L:1:(k+1)*L-1, mi) = average_Jm(k*L:1:(k+1)*L-1, mi) + J(k*L:1:(k+1)*L-1);
%Ypologismos tou pfi kai twn suntelestwn w
phi=umat.'*ev; 
w=w+phi*mu(mi);
end
           
end

end
time=toc;

%sunolikos xronos ekteleshs algori8mou BlockLMS
display(['BlockLms2-->Total time is ',num2str(time),' seconds'])

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
