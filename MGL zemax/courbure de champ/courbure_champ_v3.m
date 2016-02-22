function [ x_croisement,y_croisement ] = courbure_champ_v3( r,s,sag,theta_n,f,n )
%COURBURE_CHAMP_V3 Summary of this function goes here
%   Calcul de courbure par croisement des rayons légèrement marginaux

%Pour chaque point sauf le premier et le dernier, on calcul l'angle d'un
%rayon marginal ayant touché les deux point adjacent.
x_croisement = zeros(size(s,2)-2,1);
y_croisement = x_croisement;
for k = 2:(size(s,2)-1)
    theta_moins = atan2(r(k) - s(k-1), sag(k-1));
    theta_plus = atan2(r(k) - s(k+1), sag(k+1));
    
    theta_moins_2 = asin((1/n).*sin(theta_moins - theta_n(k-1))) + theta_n(k-1);
    theta_plus_2 = asin((1/n).*sin(theta_plus - theta_n(k+1))) + theta_n(k+1);
    
    %Calcul des équations des rayons marginaux
    a_moins = tan(theta_moins_2);
    a_plus = tan(theta_plus_2);
    b_moins = -a_moins.*(f-sag(k-1)) + s(k-1);
    b_plus = -a_plus.*(f-sag(k+1)) + s(k+1);
    
    %Point de croisement des deux courbes
    x_croisement(k) = (b_plus-b_moins)./(a_moins-a_plus);
    y_croisement(k) = (a_moins.*b_plus - a_plus.*b_moins)./(a_moins-a_plus);
end






end

