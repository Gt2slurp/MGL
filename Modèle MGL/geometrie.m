function [ xs, ys, theta_S, phy_S ] = geometrie( x,y,u,v,z )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Intersection du plan de d�viation S
xs = x - z.*(x-u);
ys = y - z.*(y-v);

%Angle du rayon avant la d�viation � la surface S
theta_S = atan(x-u);
phy_S = atan(y-v);
end

