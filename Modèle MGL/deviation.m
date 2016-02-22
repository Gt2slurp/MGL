function [ theta,phy ] = deviation( x,y,z,delta_x,delta_y )
%DEVIATION Summary of this function goes here
%   Calcul de la déviation que le plan S doit appliquer au rayon pour que
%   sa position finale respecte la distortion imposée.

%Angle de chaque composante
theta = atan(delta_x./z + x) - atan(x);
phy = atan(delta_y./z + y) - atan(y);
end

