clc; clear all; close all;

%% Load and process data
load('fashion_mnist');

X_valid = im2double(X_train(1:5000, :, :));
X_train = im2double(X_train(5001:end, :, :));
X_test = im2double(X_test);

X_valid = reshape(X_valid, [5000 28 28 1]);
X_train = reshape(X_train, [55000 28 28 1]);
X_test = reshape(X_test, [10000 28 28 1]);

X_valid = permute(X_valid, [2 3 4 1]);
X_train = permute(X_train, [2 3 4 1]);
X_test = permute(X_test, [2 3 4 1]);

y_valid = categorical(y_train(:, 1:5000))';
y_train = categorical(y_train(:, 5001:end))';
y_test = categorical(y_test)';

%% Fully-connected neural network
layers = [imageInputLayer([28, 28, 1])
    fullyConnectedLayer(500)
    reluLayer
    fullyConnectedLayer(250)
    reluLayer
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam',...
    'MaxEpochs', 5,...
    'InitialLearnRate', 7e-4,...
    'L2Regularization', 7e-4,...
    'ValidationData', {X_valid, y_valid},...
    'Verbose', false,...
    'Plots', 'training-progress');

net = trainNetwork(X_train, y_train, layers, options);

%% Plot confusion matrix of train and validation data
figure(1)
y_pred = classify(net, X_train);
plotconfusion(y_train, y_pred);
title('Confusion Matrix of Train Data');

figure(2)
y_pred = classify(net, X_valid);
plotconfusion(y_valid, y_pred);
title('Confusion Matrix of Validation Data');

%% Plot confusion matrix of test data
figure(3)
y_pred = classify(net, X_test);
plotconfusion(y_test, y_pred);
title('Confusion Matrix of Test Data');

%% Convolutional neural network
layers1 = [imageInputLayer([28, 28, 1])
    convolution2dLayer([5 5], 6, 'Padding', 'same')
    tanhLayer
    convolution2dLayer([5 5], 6, 'Padding', 'same')
    tanhLayer
    averagePooling2dLayer([2 2], 'Padding', 'same', 'Stride', [2 2])
    convolution2dLayer([5 5], 6, 'Padding', 'same')
    tanhLayer
    fullyConnectedLayer(250)
    leakyReluLayer
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

% layers1 = [imageInputLayer([28, 28, 1])
%     convolution2dLayer([28 28], 3, 'Padding', 'same')
%      ([14 14], 3, 'Padding', 'same', 'Stride', [2 2])
%     tanhLayer
%     fullyConnectedLayer(20)
%     reluLayer
%     fullyConnectedLayer(10)
%     softmaxLayer
%     classificationLayer];

%     convolution2dLayer([5 5], 6, 'Padding', 'same')
%     tanhLayer
%     averagePooling2dLayer([2 2], 'Padding', 'same', 'Stride', [2 2])
%     convolution2dLayer([5 5], 6, 'Padding', 'same')
%     tanhLayer

options1 = trainingOptions('adam',...
    'MaxEpochs', 5,...
    'InitialLearnRate', 1e-3,...
    'L2Regularization', 1e-4,...
    'ValidationData', {X_valid, y_valid},...
    'Verbose', false,...
    'Plots', 'training-progress');

net1 = trainNetwork(X_train, y_train, layers1, options1);

%% Plot confusion matrix of train and validation data
figure(4)
y_pred1 = classify(net1, X_train);
plotconfusion(y_train, y_pred1);
title('Confusion Matrix of Train Data');

figure(5)
y_pred1 = classify(net1, X_valid);
plotconfusion(y_valid, y_pred1);
title('Confusion Matrix of Validation Data');

%% Plot confusion matrix of test data
figure(6)
y_pred1 = classify(net1, X_test);
plotconfusion(y_test, y_pred1);
title('Confusion Matrix of Test Data');