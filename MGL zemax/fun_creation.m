function [ G ] = fun_creation( fun_type,r1,r2,g1,g2 )
%FUN_CREATION Summary of this function goes here
%   Création d'une fonction qui calcule la distortion en fonction de la
%   position sur l'image.

switch fun_type
    case 'gaussien'
        sigma = (r1+r2)/(2*2.35); 
        G = @(r) (g1-g2).*exp(-((r./sigma).^2)) + g2;
    case 'quadratique'
        gr = @(r) ((g1-g2).*((r-r2)./(r1-r2)).^2 + g2);
        G = @(r) heaviside(-r + r1).*g1 + heaviside(r - r1).*heaviside(-r+r2).*gr(r) + heaviside(r - r2).*g2;
    otherwise
        error('type de fonction invalide');
end

end

