function [ y ] = anadromikhFFT(x)

% root of unity
w = @(n) exp(-2*pi*1i.*((0:1:(n/2-1)).')/n);
    
n = length(x);
 
fe = x(1:2:n);
fo = x(2:2:n);
if n~=2
  X1 = anadromikhFFT(fe);
  X2 = anadromikhFFT(fo).*w(n); 
else
  X1 = fe; 
  X2 = fo;
end
F1 = X1 + X2;
F2 = X1 - X2;
y = [F1;F2];
    
end

