function [ opd ] = D2opd( x, D, z )
%RDG2OPD Calcule l'OPD necessaire pour un RDG donné
%   x : Vecteur de position image
%   D: distortion
%   z : distance de la surface S


thetaD = atan(x.*D./z+x)-atan(x);

opd = thetaD;

end

