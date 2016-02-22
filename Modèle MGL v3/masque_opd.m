function [ opd ] = masque_opd( rayon_chef,n)
%OPD Summary of this function goes here
%   Reconstuction du front d'onde par gradient inverse.

%Dérivé partielle de l'OPD p.r. à x et y
dopdx = tan(rayon_chef(1).angle_dev);
dopdy = tan(rayon_chef(2).angle_dev);
xmax = max(max(rayon_chef(1).img));
ymax = max(max(rayon_chef(2).img));
xmin = min(min(rayon_chef(1).img));
ymin = min(min(rayon_chef(2).img));

%Gradient inverse
opd = (xmax-xmin).*(ymax-ymin)./(n).*intgrad2(dopdx,dopdy);
end

