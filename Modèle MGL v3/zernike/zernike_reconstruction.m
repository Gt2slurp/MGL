function [ phi ] = zernike_reconstruction( a, n_pts )
%ZERNIKE_RECONSTRUCTION Summary of this function goes here
%   Reconstruct wavefront from zernike coeficient vector a

%Maximum zernike index used
M_max = numel(a);
if M_max > 105;
    error('maximum size of a is 105')
end
% n and m vector of zernike_coeffs
n = [0  1 1 2  2 2  3 3  3 3 4  4 4  4 4  5 5  5 5  5 5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8  8 8  8 8  8 8  8 8  9 9  9 9  9 9  9 9  9 9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12  12 12  12 12 13 13 13 13 13 13 13 13 13 13  13 13  13 13];
m = [0 -1 1 0 -2 2 -1 1 -3 3 0 -2 2 -4 4 -1 1 -3 3 -5 5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 -2 2 -4 4 -6 6 -8 8 -1 1 -3 3 -5 5 -7 7 -9 9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0 -2  2 -4  4 -6  6 -8  8 -10 10 -12 12 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11 -13 13];

%Square grid
[x,y] = meshgrid(linspace(-1,1,n_pts),linspace(-1,1,n_pts));
[theta,r] = cart2pol(x,y);
r = r.*(r<=1);
phi = zeros(n_pts.^2,1);

r = reshape(r,numel(r),1);
theta = reshape(theta,numel(theta),1);

%Generation of the different polynomials
for k = 1:M_max
    phi = phi + a(k).*zernfun(n(k),m(k),r,theta,'norm');
end

phi = reshape(phi,n_pts,n_pts);
end

