function [ dist ] = calc_dist( G, r_max, n )
%CALC_DIST Summary of this function goes here
%   Detailed explanation goes here

r = linspace(0,r_max,n);

dist = r.*(G(r)-1);

end

