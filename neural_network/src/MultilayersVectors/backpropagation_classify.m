function [y] = backpropagation_classify(u,W1,W,WEnd)

b=1;
h = @(x) (1 ./ (1+exp(-b*x))); % activation function

yy=[];
numOf_layers=size(W,3);
n2=size(W,1);
u_hidden=zeros(n2,numOf_layers+1);
U_hidden=zeros(n2,numOf_layers);
Nset=size(u,2); %number of samples

for i=1:1:Nset
u1=u(:,i);
U1 = W1*u1;
u_hidden(:,1) = h(U1);

for k=1:numOf_layers
U_hidden(:,k)=W(:,:,k)*u_hidden(:,k);
u_hidden(:,k+1) = h(U_hidden(:,k));
end

U_End_layers=WEnd*u_hidden(:,numOf_layers+1);
t = h(U_End_layers);
yy = [yy round(t)];
end
y=yy;

end


