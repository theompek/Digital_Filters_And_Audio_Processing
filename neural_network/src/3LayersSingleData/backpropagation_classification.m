% Binary classification of linearly separable 
% observations using one layer perceptron
% author: Nikos Sismanis
% date: 4 June 2013

clear all
close all


N = 600; % number of points per cluster
Nt = 300; % number of points used per cluster for training
offset = 8; % use the offset to create linearly separable clusters

% create linearly separable clusters
clusters = [0 1]; % cluster id
colors = {'*b', '+r', 'og'}; % cluster indicator

x = [randn(2,N) randn(2,N)+offset; ones(1, 2*N)]; % data set
y = [zeros(1,N) ones(1,N)]; % labels
M = size(x, 1);

% choose random Nt points for training
ii = randperm(2*N); % divide the initial dataset into training and validation sets randomly
T = x(:,ii(1:Nt)); % training set data 
d = y(ii(1:Nt)); % training set labels

% use the rest N-Nt points for validation
C = x(:,ii(Nt+1:end)); % validation set data
s = y(ii(Nt+1:end)); % validation set labels

% plot the clusters
figure(1)
suptitle({'Backpropagation with 3 layers'})
subplot(2,2,1);
for i=1:length(clusters)
    plot(C(1, s==clusters(i)), C(2, s==clusters(i)), colors{i});
    hold on
end
hold off

xlabel('x(1)')
ylabel('x(2)')
title('Ground truth')

%% Try perceptron with hard nonlinearity
%Jit: Accumulate square error
%Jt: Square error
%W1,2,3: Weigths for 3 layers

[W1, W2, W3,Jit,Jt]  = backpropagation_train(T, d); % train the neural network
[yc] = backpropagation_classify(C,W1,W2,W3); % classify using the backpropagation

% plot classification results using perceptron with hard nonlinearity
subplot(2,2,2);
for i=1:length(clusters)
    plot(C(1, (yc==clusters(i)) & s==clusters(i)), C(2, (yc==clusters(i)) & s==clusters(i)), colors{i});
    hold on
end
plot(C(1, yc~=s), C(2, yc~=s), colors{i+1}); % plot the misclassifications
hold off

xlabel('x(1)')
ylabel('x(2)')
title('Perceptron with backpropagation')

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