function [ opd ] = opd_tilt( R,f_number,z,n )
%OPD_TILT Summary of this function goes here
%   Variation d'opd induite par l'angle d'un rayon

%Angle du rayon Chef
angle(1) = atan(R(1).img);
angle(2) = atan(R(2).img);

opd_vect_x = z/(f_number*2)*angle(1).*linspace(-1,1,n);
opd_vect_y = z/(f_number*2)*angle(2).*linspace(-1,1,n);
[opd_x,opd_y] = meshgrid(opd_vect_x ,opd_vect_y);
opd = opd_x + opd_y;
end

