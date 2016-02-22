function [ xs, ys, theta_S, phy_S ] = geometrie( x,y,u,v,z )
%UNTITLED Summary of this function goes here
%   Calcul du point d'intersection et de l'angle d'un rayon sur la surface 
%   S en fonction de sont point de départ dans la pupille et sont point
%   d'arrivée sur l'image.

%Intersection du plan de déviation S
xs = x - z.*(x-u);
ys = y - z.*(y-v);

%Angle du rayon avant la déviation à la surface S
theta_S = atan(x-u);
phy_S = atan(y-v);
end

