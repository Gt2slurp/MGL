function [ opd] = calcul_tilt( opd,ray_fan,z,n )
%CALCUL_TILT Summary of this function goes here
%   Detailed explanation goes here

opd.total = opd.tilt + opd.s;

xsmax = max(max(ray_fan(1).s));
xsmin = min(min(ray_fan(1).s));
ysmax = max(max(ray_fan(2).s));
ysmin = min(min(ray_fan(2).s));

%x = 0.5*abs(xsmax-xsmin).*linspace(-1,1,n);
%y = 0.5*abs(ysmax-ysmin).*linspace(-1,1,n);
x = linspace(-1,1,n);
y = linspace(-1,1,n);
[x_mat,y_mat] = meshgrid(x,y);

%Coeficient de tilt en x et y
C_tilt_x = sum(sum(x_mat.*opd.total))./n^2;
C_tilt_y = sum(sum(y_mat.*opd.total))./n^2;

%Calcul des angles de déviation
% R_x = C_tilt_x./(0.5*(xsmax-xsmin));
% R_y = C_tilt_y./(0.5*(ysmax-ysmin));
opd(1).angle_dev = atan(C_tilt_x./(0.5*(xsmax-xsmin)));
opd(2).angle_dev = atan(C_tilt_y./(0.5*(ysmax-ysmin)));

%Calcul de la distance de déviation sur l'image
%delta_x = z.*tan(theta);
%delta_y = z.*tan(phi);

opd(1).delta = z.*C_tilt_x./(0.5*(xsmax-xsmin));
opd(2).delta = z.*C_tilt_y./(0.5*(ysmax-ysmin));

%Opd sans tilt
opd.st = opd.total - C_tilt_x.*x_mat - C_tilt_y.*y_mat;
opd.st = opd.st - mean(mean(opd.st));
end

