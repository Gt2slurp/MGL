function [ theta,phy ] = deviation( x,y,z,delta_x,delta_y )
%DEVIATION Summary of this function goes here
%   Detailed explanation goes here

%Angle de chaque composante
theta = atan(delta_x./z + x) - atan(x);
phy = atan(delta_y./z + y) - atan(y);
end

