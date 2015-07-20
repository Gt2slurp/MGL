function [ R ] = deviation( R, z )
%DEVIATION Summary of this function goes here
%   Detailed explanation goes here

%Angle de chaque composante
R(1).angle_dev = atan(R(1).delta./z + R(1).img) - atan(R(1).img);
R(2).angle_dev = atan(R(2).delta./z + R(2).img) - atan(R(2).img);
end

