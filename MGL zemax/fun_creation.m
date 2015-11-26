function [ G ] = fun_creation( fun_type,r1,r2,g1,g2 )
%FUN_CREATION Summary of this function goes here
%   Detailed explanation goes here

switch fun_type
    case 'gaussien'
        sigma = (r1+r2)/(2*2.35); 
        G = @(r) (g1-g2).*exp(-((r./sigma).^2)) + g2;
    otherwise
        error('type de fonction invalide');
end

end

