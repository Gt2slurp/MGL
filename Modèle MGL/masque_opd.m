function [ opd ] = masque_opd( theta,phy,n,xmax,ymax )
%OPD Summary of this function goes here
%   Detailed explanation goes here

%D�riv� partielle de l'OPD p.r. � x et y
dopdx = tan(theta);
dopdy = tan(phy);

%Gradient inverse
opd = 4.*xmax.*ymax./(n).*intgrad2(dopdx,dopdy);
end

