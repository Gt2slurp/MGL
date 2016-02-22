function [ xm ] = deviation_rayon( x,u,z,thetaD )
%DEVIATION_RAYON Summary of this function goes here
%   Detailed explanation goes here

xs = x - z*(x-u);

thetaM = atan(x-u) + thetaD;
xm = xs + z*tan(thetaM);

end

