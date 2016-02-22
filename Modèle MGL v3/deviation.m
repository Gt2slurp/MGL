function [ R ] = deviation( R, z )
%DEVIATION Summary of this function goes here
%   Calcul de l'angle apr�s avoir intercept� la surface s pour que le rayon
%   respecte la d�viation impos� par la distortion.

%Angle de chaque composante
R(1).angle_dev = atan(R(1).delta./z + R(1).img) - atan(R(1).img);
R(2).angle_dev = atan(R(2).delta./z + R(2).img) - atan(R(2).img);
end

