function [ opd] = opd_calc( opd,ray_fan,z,n )
%CALCUL_TILT Summary of this function goes here
%   Calcul de l'opd résiduel après le retrait du tilt

%   UTILISER LA VERSION 2. CALCUL DU TILT IMPRÉCI.

opd.total = opd.tilt + opd.s;

xsmax = max(max(ray_fan(1).s));
xsmin = min(min(ray_fan(1).s));
ysmax = max(max(ray_fan(2).s));
ysmin = min(min(ray_fan(2).s));

x = linspace(-1,1,n);
y = linspace(-1,1,n);
[x_mat,y_mat] = meshgrid(x,y);

%Coeficient de tilt en x et y
%Je vais mourir hanté par ce facteur 3..
C_tilt_x = 3*sum(sum(x_mat.*opd.total))./(n^2);
C_tilt_y = 3*sum(sum(y_mat.*opd.total))./(n^2);

%Calcul des angles de déviation
opd.theta = atan(C_tilt_x./(0.5*(xsmax-xsmin)));
opd.phi = atan(C_tilt_y./(0.5*(ysmax-ysmin)));

%Calcul de la distance de déviation sur l'image
opd.delta_x = z.*C_tilt_x./(0.5*(xsmax-xsmin));
opd.delta_y = z.*C_tilt_y./(0.5*(ysmax-ysmin));

%Opd sans tilt
opd.st = opd.total - C_tilt_x.*x_mat - C_tilt_y.*y_mat;
opd.st = opd.st - mean(mean(opd.st));
end

