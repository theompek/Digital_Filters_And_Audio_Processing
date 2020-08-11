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

%Shma meta apo thn ka8usterhsh delta=10
Ud=zeros(N,1);
for i=delta+1:1:N
Ud(i)=d(i-delta);
end
%%
%Ari8mos syntelestwn filtrou
nCoeff = 100;

% autocorrelation r
[r,lag] = xcorr(Ud,nCoeff,'unbiased');
r = r(lag>=0);

%H sunarthsh epistrefei
%   A: tap-weight vector
%   G: vector of reflection coefficients
%   L: Lower triangular matrix used to orthogonalize  b
%   b(n) = L*u(n) (see Gram-Schmidt orthogonalization)
%   Dp: Diagonal of the autocorrelation  matrix of the 
%   backward prediction error 
[weight, reflect, L, Dp] = LevinsonDurbin_iterative(nCoeff, r);

%Suntelestes filtrou
w=-weight(2:end);

%Syntelestes gama apo thn sxesh L'*gama=w ths selidas 10 Lecture 8
%Oi suntelestes w einai upologismenh apo thn timh u(n-1) enw gia thn
%dhmiourgia tou pinaka L apo thn shmeiwseis vlepoume oti xrhsimopoioume
%kai thn timh u(n).Profanws sto filtro h timh gia to u(n) antistoixei se 1
gama=L'\[1;w];

y=zeros(N,1);
for i=nCoeff:1:N
 y(i) = Ud(i:-1:i-(nCoeff-1))'* w; % filter
end  
y=[y(delta:end);zeros(delta-1,1)];
%%
%Sunarthsh Levinson tou Matlab
[weight_mat, Po_mat, reflect_matl]=levinson(r,nCoeff);

%Forward/Backward prediction error Lecture 7 selida 4
Po=r(1)-r(2:end)'*w;

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

figure(2);
plot(weight-weight_mat')
title('Suntelestes provlepseis se sugrish me Matlab')

figure(3);
plot(reflect-reflect_matl)
title('Parametroi anaklashs se sugrish me Matlab')