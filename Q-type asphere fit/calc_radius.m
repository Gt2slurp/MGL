function [ r ] = calc_radius( x,y )
%CALC_RADIUS Summary of this function goes here
%   Detailed explanation goes here

flag = 0;
if y == 0
    r = inf;
    return
elseif y < 0
    y = -y;
    flag = 1;
end
%Angle restant d'un triangle
theta = pi - tan(y/x) - tan(y/x);

%distance entre les points
d = sqrt(x.^2 + y.^2);

r = d./(2.*sin(theta./2));

if flag
    r = -r;
end

end

