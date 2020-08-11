function [W1, W, WEnd,Jit,Jt] = backpropagation_train(u, d)

%u: vector training data set (input)
%d: vector cluster ids (desired signal)
%Jit: Accumulate square error
%Jt: Square error
%W1,2,3: Weigths for 3 layers

%Initialize
lamda=0.8;
b=1; %slope parameter

h = @(x) (1 ./ (1+exp(-b*x))); % activation function
dh = @(x) (b.*(h(x)).*(1-h(x))); % first derivative 

%We have a input layer,some hidden and a output layer
hidden_layers=3; %number of hidden layers

Neaurons=size(u,1); %number of inputs
Nset=size(u,2); %number of samples
epoch = 0; % epoch counter
max_epochs =200; % number of epochs


%Input layer
n1=Neaurons;
n2=5*Neaurons;
W1=0.2.*randn(n2,n1);

%Hidden layers
W=0.2.*randn(n2,n2,hidden_layers);
u_hidden=zeros(n2,hidden_layers+1);
U_hidden=zeros(n2,hidden_layers);
delta=zeros(n2,hidden_layers);

%Output layer
nEnd=size(d,1); %output size
WEnd=0.2.*randn(nEnd,n2);

%Initialize
%Square error
Jit=zeros(nEnd,Nset+1,max_epochs);
Jt=zeros(nEnd,Nset+1,max_epochs);

while(epoch < max_epochs)
dJit_dw1=zeros(n2,n1);
dJit_dw=zeros(n2,n2,hidden_layers);
dJt_dw=zeros(n2,n2,hidden_layers);
dJit_dwEnd=zeros(nEnd,n2);

for i=1:1:Nset
%Input layer
u1=u(:,i);
U1 = W1*u1;
u_hidden(:,1) = h(U1);
%Hidden layers
for k=1:hidden_layers
U_hidden(:,k)=W(:,:,k)*u_hidden(:,k);
u_hidden(:,k+1) = h(U_hidden(:,k));
end
%Output layer  
U_End_layers=WEnd*u_hidden(:,hidden_layers+1);
uEnd = h(U_End_layers);

%Error
e=d(:,i)-uEnd;
%Square error
Jt(:,i,epoch+1)=e'*e;
%Accumulate the square error
Jit(:,i+1,epoch+1)=Jit(:,i,epoch+1)+Jt(:,i,epoch+1);

deltaEnd=e.*dh(U_End_layers);

delta(:,hidden_layers)=dh(U_hidden(:,hidden_layers)).*(WEnd'*deltaEnd); 

for k=hidden_layers-1:-1:1
delta(:,k)=dh(U_hidden(:,k)).*(W(:,:,k+1)'*delta(:,k+1));   
end

delta1=dh(U1).*(W(:,:,1)'*delta(:,1));


dJt_dw1 = -delta1*u1';
for k=1:hidden_layers 
dJt_dw(:,:,k) = -delta(:,k)*u_hidden(:,k)';
end
dJt_dwEnd = -deltaEnd*u_hidden(:,k+1)';

%Accumulate the gradient elements
dJit_dw1=dJit_dw1+dJt_dw1;
for k=1:hidden_layers 
dJit_dw(:,:,k)=dJit_dw(:,:,k)+dJt_dw(:,:,k);
end
dJit_dwEnd=dJit_dwEnd+dJt_dwEnd;

%Renewal the weights
W1=W1-lamda.*dJt_dw1;
for k=1:hidden_layers 
W(:,:,k)=W(:,:,k)-lamda.*dJt_dw(:,:,k);
end
WEnd=WEnd-lamda.*dJt_dwEnd;

end

epoch=epoch+1;
end




end