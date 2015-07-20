function [ opd ] = masque_opd( theta,phy,n,xmax,ymax )
%OPD Summary of this function goes here
%   Detailed explanation goes here

%Dérivé partielle de l'OPD p.r. à x et y
dopdx = tan(theta);
dopdy = tan(phy);

%Gradient inverse
opd = 4.*xmax.*ymax./(n).*intgrad2(dopdx,dopdy);
end

