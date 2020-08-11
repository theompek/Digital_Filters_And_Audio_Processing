function [W1, W2, W3,Jit,Jt] = backpropagation_train(u, d)

%u: vector training data set (input)
%d: vector cluster ids (desired signal)
%w1,2,3: initial weights

%O algorith for 3 layers,first for input,one hidden and the output
%Initialize
Neaurons=size(u,1); %number of input neaurons
Nset=size(u,2); %number of samples
epoch = 0; % epoch counter
max_epochs =6; % number of epochs

lamda=0.8;
b=1; %slope parameter

%Input layer
n1=Neaurons;
n2=4*Neaurons;
W1=0.2*randn(n2,n1);

%Hidden layer
n3=2*Neaurons;
W2=0.2*randn(n3,n2);

%Output layer
n4=size(d,1) %output size
W3=0.2*randn(n4,n3);

h = @(x) (1 ./ (1+exp(-b*x))); % activation function
dh = @(x) (b.*(h(x)).*(1-h(x))); % first derivative 

%Initialize
%Square error
Jit=zeros(n4,Nset+1,max_epochs);
Jt=zeros(n4,Nset+1,max_epochs);
while(epoch < max_epochs)

dJit_dw1=zeros(n2,n1);
dJit_dw2=zeros(n3,n2);
dJit_dw3=zeros(n4,n3);


for i=1:1:Nset
%Input layer
u1=u(:,i);
U1 = W1*u1;
u2 = h(U1);
%Hidden layer
U2=W2*u2;
u3 = h(U2);
%Output layer    
U3=W3*u3;
u4 = h(U3);

%Error
e=d(:,i)-u4;
%Square error
Jt(:,i,epoch+1)=e'*e;
%Accumulate the square error
Jit(:,i+1,epoch+1)=Jit(:,i,epoch+1)+Jt(:,i,epoch+1);

delta3=e.*dh(U3);
delta2=dh(U2).*(W3'*delta3);
delta1=dh(U1).*(W2'*delta2);


dJt_dw1 = -delta1*u1';
dJt_dw2 = -delta2*u2';
dJt_dw3 = -delta3*u3';

%Accumulate the gradient elements
dJit_dw1=dJit_dw1+dJt_dw1;
dJit_dw2=dJit_dw2+dJt_dw2;
dJit_dw3=dJit_dw3+dJt_dw3;

%Renewal the weights
W1=W1-lamda.*dJt_dw1;
W2=W2-lamda.*dJt_dw2;
W3=W3-lamda.*dJt_dw3;
end

epoch=epoch+1;
end





end