function [ dist,P] = calc_dist( G, r_max, n )
%CALC_DIST Summary of this function goes here
%   Calcul de la distortion cr��e par le grandissement.

r = linspace(0,r_max,n);

a = r.*(G(r)-1);

P = r + a;

%Deffinition de la distortion de zemax
dist = 100.*(P - r)./r;
end

