% Binary classification of linearly separable 
% observations using one layer perceptron
% author: Nikos Sismanis
% date: 4 June 2013

clear all
close all

%Data from matlab function
[x,y] = iris_dataset;

% create linearly separable clusters
clusters = [1 0 0;0 1 0;0 0 1]; % cluster id
colors = {'*y', '+r', '+b','og'}; % cluster indicator

M = size(x, 2);
N = M/2; % number of points per cluster
Nt = M/2; % number of points used per cluster for training
% choose random Nt points for training
ii = randperm(2*N); % divide the initial dataset into training and validation sets randomly
T = x(:,ii(1:Nt)); % training set data 
d = y(:,ii(1:Nt)); % training set labels

% use the rest N-Nt points for validation
C = x(:,ii(Nt+1:end)); % validation set data
s = y(:,ii(Nt+1:end)); % validation set labels

%Logical vector with flags for plot points
flag=false(1,Nt);

% plot the clusters
%8a xrhsimopoihsoume tis prwtes 3 times-diastaseis apo ta dianusmata 4 diastasewn
%gia na para3oume ena optiko apotelesma sxetika me thn kathgoriopoihsh twn
%dedomenwn me ton algori8mo backpropagation 
figure(1)
suptitle({'Use 3 of 4 dimensions only','to plot the figure'})
subplot(2,2,1);
for i=1:length(clusters)
    
    for k=1:1:Nt
     flag(k)=isequal(s(:,k),clusters(:,i));
    end
    
     plot3(C(1,flag), C(2, flag),C(3, flag), colors{i});
    hold on
end
hold off

xlabel('x(1)')
ylabel('x(2)')
zlabel('x(3)')
title('Ground truth')

%% Try perceptron with hard nonlinearity
%Jit: Accumulate square error
%Jt: Square error
%W1,2,3: Weigths for 3 layers

[W1, W2, W3,Jit,Jt]  = backpropagation_train(T, d); % train the perceptron
[yc] = backpropagation_classify(C,W1,W2,W3); % classify using the backpropagation

% plot classification results using perceptron with backpropagation
subplot(2,2,2);
%Sxediash twn shmeiwn pou kathgoriopoih8hkan swsta
for i=1:size(clusters,2)
    
    for k=1:1:Nt
     flag(k)=isequal(s(:,k),yc(:,k),clusters(:,i));
    end
    
    plot3(C(1,flag), C(2, flag),C(3, flag), colors{i});
    hold on
end

%Ari8mos mh kathgoriopoihmenwn shmeiwn
NumOfNotClassif=0;

for k=1:1:Nt
  flag(k)=~isequal(s(:,k),yc(:,k));
  
  if flag(k)
    NumOfNotClassif=NumOfNotClassif+1;
  end
end
%Sxediash twn shmeiwn pou den kathgoriopoi8hka
hold on
plot3(C(1,flag), C(2, flag),C(3, flag), colors{i+1});
hold off


xlabel('x(1)');
ylabel('x(2)');
zlabel('x(3)');
title({'Perceptron with backpropagation',['Success = ',num2str((Nt-NumOfNotClassif)*100/Nt),'%  (',...
    num2str(NumOfNotClassif),' errors of ',num2str(Nt),' samples)']});

subplot(2,2,3);
plot(Jit(1,:));
ylabel('Jit=Jit+Jt')
xlabel('Nset*epoch')
title('Accumulation of Square Error for every epoch')

subplot(2,2,4);
plot(Jt(1,:));
ylabel('Jt=e(n)^2')
xlabel('Nset*epoch')
title('Square Error for every epoch')
