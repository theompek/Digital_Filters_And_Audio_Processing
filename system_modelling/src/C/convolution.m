clear;
%Dhmiourgoume 2 tuxaia shmata
Ny=5;
Nx=3;
y = (randn(Ny,1) + 1i*randn(Ny,1)).';
x = (randn(Nx,1) + 1i*randn(Nx,1)).';
%%
%Toeplitz Convolution
r = [y zeros(1,length(x)-1)];

c = [y(1) zeros(1,length(x)-1)];

Y = toeplitz(c,r);
toep_conv=x*Y; %Convolution

clear r c;
fprintf('toep_conv-conv(x,h)= %e\n', norm(toep_conv-conv(y,x)))

%%
%Circulant Convolution
%Sumplhrwnoume tous pinakes me mhdenika wste na exoun
%diastash pou na ikanopoiei thn sxesh Nx+Ny-1
Yc=[y zeros(1,length(x)-1)];
Xc=[x zeros(1,length(y)-1)];

C = [Yc(1) fliplr(Yc(end-length(Yc)+2:end))];

%Circulant Matrix
C = toeplitz(C,Yc);
%Convolution
Circ_conv=Xc*C;

clear Yc Xc
fprintf('Circ_conv-conv(x,h)= %e\n', norm(Circ_conv-conv(y,x)))
%%
Yc=[y zeros(1,length(x)-1)];
Xc=[x zeros(1,length(y)-1)];

fft_conv=ifft(fft(Yc).*fft(Xc));
clear Yc Xc
fprintf('fft_conv-conv(x,h)= %e\n', norm(fft_conv-conv(y,x)))