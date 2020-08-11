function [y] = backpropagation_classify(u,W1,W2,W3)

b=1;
h = @(x) (1 ./ (1+exp(-b*x))); % activation function

% single

u1=u;
U1 = W1*u1;
u2 = h(U1);

U2=W2*u2;
u3 = h(U2);
    
U3=W3*u3;
y = h(U3);
y = round(y);
end


