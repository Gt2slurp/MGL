function [ opd ] = masque_opd_gauss( rayon_chef,g1,g2,r1,r2,n)
%MASQUE_OPD_GAUSS Summary of this function goes here
%   Detailed explanation goes here
sigma = (r1+r2)/(2*2.35);
r = sqrt(rayon_chef(1).img.^2 + rayon_chef(2).img.^2);
opd = -(g1-g2).*(sigma.^2)./2.*exp(-(r./sigma).^2);
% 
% xmax = max(max(rayon_chef(1).img));
% ymax = max(max(rayon_chef(2).img));
% xmin = min(min(rayon_chef(1).img));
% ymin = min(min(rayon_chef(2).img));
% 
% opd = (xmax-xmin).*(ymax-ymin)./(n).*opd;
end

