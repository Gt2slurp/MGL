function [ C ] = courbure_champ( s,sag, f1,n )
%COURBURE_CHAMP Summary of this function goes here
%   Detailed explanation goes here

%Calcul du rayon de courbure local de la surface
dsag = gradient(sag,s);
d2sag = gradient(dsag,s);
R = 1./(d2sag./((1+dsag.^2).^(3/2)));
f2 = 1./((n-1)./R);

%Puissance du système composé
d = f1 - sag;
f = 1./(1./f1 + 1./f2 - d./(f1.*f2));

%Variation de distance du au verre.
l = f + ((f-f1+sag).*(n-1)./n);

%Courbure de champ
C = l - f1;

end

