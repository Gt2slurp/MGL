function [ opd ] = opd_tilt( x_psf,y_psf,z,f_number,n )
%OPD_TILT Summary of this function goes here
%   Calcul de l'opd généré par un certain tilt

%Rayon chef correspondant
[ ~, ~, theta_S, phy_S ] = geometrie( x_psf,y_psf,0,0,z );

opd_vect_x = z/(f_number*2)*tan(theta_S).*linspace(-1,1,n);
opd_vect_y = z/(f_number*2)*tan(phy_S).*linspace(-1,1,n);
[opd_x,opd_y] = meshgrid(opd_vect_x ,opd_vect_y);
opd = opd_x + opd_y;


end

