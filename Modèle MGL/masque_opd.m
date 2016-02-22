function [ opd ] = masque_opd( theta,phy,n,xmax,ymax )
%OPD Summary of this function goes here
%   Calcul du masque d'OPD en sachant que la tangente de l'angle de la
%   surface sont les dérivée partielle de la phase.

%Dérivé partielle de l'OPD p.r. à x et y
dopdx = tan(theta);
dopdy = tan(phy);

%Gradient inverse
opd = 4.*xmax.*ymax./(n).*intgrad2(dopdx,dopdy);
end

