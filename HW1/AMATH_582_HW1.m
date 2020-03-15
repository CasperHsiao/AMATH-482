clc; clear all; close all;

load('Testdata.mat')

%% Create the spatial and spectral domain.
L = 15;
N = 64;
x = linspace(-L, L, N+1);
x = x(1:N);
y = x;
z = x;
k = pi/L*[0:(N/2 - 1), (-N/2):-1];
ks = fftshift(k);

[X, Y, Z] = meshgrid(x, y, z);
[Kx, Ky, Kz] = meshgrid(ks, ks, ks);

%% Transform the data into spectral domain and averaging the signals.
c = size(Undata, 1);
Un = cell(1, c);
Unt = cell(1, c);
Untave = zeros(N, N, N);
for j = 1 : c
    Un{j} = reshape(Undata(j, :), N, N, N);
    Unt{j} = fftn(Un{j});
    Untave = Untave + Unt{j};
end
Untave = Untave/c;

%% Locate the center frequency in the averaged signal.
[M, I] = max(fftshift(abs(Untave)), [], 'all', 'linear');
[Ix, Iy, Iz] = ind2sub(size(Untave), I);
k0x = Kx(Ix, Iy, Iz);
k0y = Ky(Ix, Iy, Iz);
k0z = Kz(Ix, Iy, Iz);

figure(1)
isosurface(Kx, Ky, Kz, fftshift(abs(Untave))/M, 0.7);
xlabel('Kx');
ylabel('Ky');
zlabel('Kz');
axis([-7 7 -7 7 -7 7]);
view(0, 0);
grid on;

figure(2)
isosurface(Kx, Ky, Kz, fftshift(abs(Untave))/M, 0.7);
xlabel('Kx');
ylabel('Ky');
zlabel('Kz');
axis([-7 7 -7 7 -7 7]);
view(90, 0);
grid on;

%% Create the Gaussian filter.
tau = 0.2;
filter = exp(-tau*(ifftshift(Kx) - k0x).^2).*exp(-tau*(ifftshift(Ky) - ...
    k0y).^2).*exp(-tau*(ifftshift(Kz) - k0z).^2);

%% Filter the signals.
Untf = cell(1, c);
Unf = cell(1, c);
for j = 1 : c
    Untf{j} = filter.*Unt{j};
    Unf{j} = ifftn(Untf{j});
end

%% Locate the trajectory of the marble
XX = zeros(1, c);
YY = XX;
ZZ = XX;
for j = 1 : c
    [M , I] = max(abs(Unf{j}), [], 'all', 'linear');
    [Ix, Iy, Iz] = ind2sub(size(Unf{j}), I);
    XX(j) = X(Ix, Iy, Iz);
    YY(j) = Y(Ix, Iy, Iz);
    ZZ(j) = Z(Ix, Iy, Iz);
end

figure(3)
plot3(XX, YY, ZZ, '-o', 'MarkerSize', 10, 'MarkerFaceColor', '#D9FFFF');
axis([-15 15 -15 15 -15 15]);
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-45, 45);
grid on;


