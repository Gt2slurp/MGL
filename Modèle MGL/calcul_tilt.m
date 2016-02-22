function [ opd_st, delta_x, delta_y, theta, phi ] = calcul_tilt( opd,xsmax,ysmax,xsmin,ysmin,z,n )
%CALCUL_TILT Summary of this function goes here
%   Calcul du coefficient moyen de tilt par multiplication avec une matrice
%   de pente unitaire.

%x = 0.5*abs(xsmax-xsmin).*linspace(-1,1,n);
%y = 0.5*abs(ysmax-ysmin).*linspace(-1,1,n);
x = linspace(-1,1,n);
y = linspace(-1,1,n);
[x_mat,y_mat] = meshgrid(x,y);

%Coeficient de tilt en x et y
C_tilt_x = sum(sum(x_mat.*opd))./n^2;
C_tilt_y = sum(sum(y_mat.*opd))./n^2;

%Calcul des angles de déviation
% R_x = C_tilt_x./(0.5*(xsmax-xsmin));
% R_y = C_tilt_y./(0.5*(ysmax-ysmin));
theta = atan(C_tilt_x./(0.5*(xsmax-xsmin)));
phi = atan(C_tilt_y./(0.5*(ysmax-ysmin)));

%Calcul de la distance de déviation sur l'image
%delta_x = z.*tan(theta);
%delta_y = z.*tan(phi);

delta_x = z.*C_tilt_x./(0.5*(xsmax-xsmin));
delta_y = z.*C_tilt_y./(0.5*(ysmax-ysmin));

%Opd sans tilt
opd_st = opd - C_tilt_x.*x_mat - C_tilt_y.*y_mat;
opd_st = opd_st - mean(mean(opd_st));
end

