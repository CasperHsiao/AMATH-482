clc; clear all; close all

%% Load test 2 data
load('cam1_4.mat')
% implay(vidFrames1_4)
load('cam2_4.mat')
% implay(vidFrames2_4)
load('cam3_4.mat')
% implay(vidFrames3_4)


%% Obtain the x and y variable data points
numFrames14 = size(vidFrames1_4, 4);
numFrames24 = size(vidFrames2_4, 4);
numFrames34 = size(vidFrames3_4, 4);

x14 = zeros(numFrames14, 1);
y14 = x14;
bottom = 410;
top = 190;
left = 240;
right = 420;
for i = 1 : numFrames14
    X14 = double(rgb2gray(vidFrames1_4(:, :, :, i)));
    X14(:, 1:left) = 0;
    X14(:, right:end) = 0;
    X14(1:top, :) = 0;
    X14(bottom:end, :) = 0;
    [M, I] = max(max(X14));
    [row, col] = find(X14 >= 0.9*M);
    x14(i) = mean(col);
    y14(i) = mean(row);
end
x14 = x14 - mean(x14);
y14 = y14 - mean(y14);
[M, I] = max(y14(1:50));
x14 = x14(I:end);
y14 = y14(I:end);


figure(1)
set(gca, 'FontSize', 15)
sgtitle('Test 4');
subplot(1, 3, 1)
plot(x14);
hold on;
plot(y14);
legend('X1', 'Y1');
title('Camera 1');
xlabel('Frames');
ylabel('Pixel position');

x24 = zeros(numFrames24, 1);
y24 = x24;
bottom = 390;
top = 150;
left = 250;
right = 410;
for i = 1 : numFrames24
    X24 = double(rgb2gray(vidFrames2_4(:, :, :, i)));
    X24(:, 1:left) = 0;
    X24(:, right:end) = 0;
    X24(1:top, :) = 0;
    X24(bottom:end, :) = 0;
    [M, I] = max(max(X24));
    [row, col] = find(X24 >= 0.95*M);
    x24(i) = mean(col);
    y24(i) = mean(row);
end
x24 = x24 - mean(x24);
y24 = y24 - mean(y24);
[M, I] = max(y24(1:50));
x24 = x24(I:end);
y24 = y24(I:end);

subplot(1, 3, 2)
plot(x24);
hold on;
plot(y24);
legend('X2', 'Y2');
title('Camera 2');
xlabel('Frames');
ylabel('Pixel position');

x34 = zeros(numFrames34, 1);
y34 = x34;
bottom = 320;
top = 180;
left = 250;
right = 480;
for i = 1 : numFrames34
    X34 = double(rgb2gray(vidFrames3_4(:, :, :, i)));
    X34(:, 1:left) = 0;
    X34(:, right:end) = 0;
    X34(1:top, :) = 0;
    X34(bottom:end, :) = 0;
    [M, I] = max(max(X34));
    [row, col] = find(X34 >= 0.9*M);
    y34(i) = mean(col);
    x34(i) = mean(row);
end
x34 = x34 - mean(x34);
y34 = y34 - mean(y34);
[M, I] = max(y34(1:50));
x34 = x34(I:end);
y34 = y34(I:end);

subplot(1, 3, 3)
plot(x34);
hold on;
plot(y34);
legend('X3', 'Y3');
title('Camera 3');
xlabel('Frames');
ylabel('Pixel position');
saveas(gcf, 'Position_Test4.jpg')

%% Reshape data
n = min([length(y14), length(y24), length(y34)]);
X = [x14(1:n)'; y14(1:n)'; x24(1:n)'; y24(1:n)'; x34(1:n)'; y34(1:n)'];
[U, S, V] = svd(X, 'econ');
lambda = diag(S).^2;
Y = U'*X;

figure(2)
set(gca, 'FontSize', 10)
lambdaSum = sum(lambda);
plot(lambda./lambdaSum, 'r*');
title('Normalized Diagonal Variance For Test 4');
xlabel('Principal Component');
ylabel('Energy Percentage');
saveas(gcf, 'Variance_Test4.jpg')

figure(3)
set(gca, 'FontSize', 10)
plot(Y(1, :));
hold on;
plot(Y(2, :));
plot(Y(3, :));
plot(Y(4, :));
plot(Y(5, :));
plot(Y(6, :));
legend('Component 1', 'Component 2', 'Component 3', 'Component 4', 'Component 5', 'Component 6');
title('Pricipal Component Projection For Test 4');
xlabel('Frames');
ylabel('Pixel Position');
saveas(gcf, 'Projection_Test4.jpg')