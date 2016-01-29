function [ sag1, sag2,l,s1,s2,diff ] = G2double_sag( f,f2,z,n1,n2,G,s_max,hfov, n_pts  )
%G2DOUBLE_SAG Summary of this function goes here
%   Detailed explanation goes here

%Valeurs intiale de sag
sag1 = z.*ones(1,n_pts);
sag2 = z.*ones(1,n_pts);

%Vecteur s
s1 = linspace(0,s_max,n_pts);
s2 =  1.1.*s1;

%Valeur initiale de l
l = f + z.*(n2-n1)./n2;

%Vecteur r pour que le système conserve le bon f/# en sortie
r = linspace(0,rad2deg(atan(hfov/f)),n_pts);

%Theta 3 reste constant
theta_3 = atan2(r.*G(r),f2);

%Préalocation et valeurs par défaut
tol = 1E-15;
old_sag1 = 0;
old_sag2 = 0;
k = 1;
iter_max = 25;
diff = ones(1,iter_max);


while diff(k) > tol
    k = k + 1; 
    
    %Calcul des angles
    theta_1 = atan2(s1,l-sag1);
    theta_2 = atan2(s2-s1,sag2+sag1);
    
    %Calcul de s2
    s2 = (sag2+sag1).*tan(theta_2) + s1;
    
    %Calcul des normales aux interfaces
    theta_n1 = solve_snell(theta_1,theta_2, n1, n2);
    theta_n2 = solve_snell(theta_2,theta_3, n2, n1);
    
    %Calcul du sag (intégration de seulement la moitié pour la stabilité)
    sag1 = sag1./3 + cumtrapz(s1,tan(theta_n1))./(2/3);
    sag2 = sag2./3 + cumtrapz(s2,tan(theta_n2))./(2/3);
    
%     courbure = gradient(gradient(sag1));
%     sag2 = sag2./2 + n_pts.*cumtrapz(s2,cumtrapz(s2,courbure));
    
    %Condition d'existance physique de la pièce
%     if min(sag2+sag1) < 0
%         sag1 = sag1 + min(sag2+sag1)./2;
%         sag2 = sag2 + min(sag2+sag1)./2;
%     end
    if min(sag1) < 0
        sag1 = sag1 - min(sag1);        
    end
    if min(sag2) < 0
        sag2 = sag2 - min(sag2);        
    end
    
% 
%     sag1 = sag1 - mean(sag1+sag2);
%     sag2 = sag2 + mean(sag1+sag2);
%     
    
    %Différence pour la condition de la boucle
    diff(k) = (sum(abs(sag1 - old_sag1)) + sum(abs(sag2 - old_sag2)))./(2*n_pts);
    old_sag1 = sag1;
    old_sag2 = sag2;
    if k > iter_max
        break
    end
    
end

end

