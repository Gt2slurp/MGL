function [ sag,l,s,diff ] = G2sag_v2( f,z,n1,n2,G,s_max, n_pts )
%G2SAG_V2 Summary of this function goes here
%   Detailed explanation goes here

%Valeur intiale de sag
sag = z.*ones(1,n_pts);

%Vecteur s
s = linspace(0,s_max,n_pts);

%Valeur initiale de l
l = f + z.*(n2-n1)./n2;

%Tolérance de la boucle
tol = 1E-15;
old_sag = 0;
k = 1;
iter_max = 50;
diff = ones(1,iter_max);
figure(4);hold on;

while diff(k) > tol
    k = k + 1;
    
    %Calcul du r équivalent à chaque s
    r = s./(1-(sag./l));
    
    %Calcul des angles
    theta_1 = unwrap(atan2(s,(l-sag)));
    theta_2 = unwrap(atan2(r.*G(r)-s,sag));
    
    %Calcul de theta_n
    theta_n = solve_snell(theta_1,theta_2, n1, n2);
    
    %Calcul du sag (intégration de seulement la moitier pour la stabilité)
    sag = sag./2 + cumtrapz(s,tan(theta_n))./2;
    plot(sag)
    %Ajustement du sag pour garder l'image en moyenne au foyer paraxiale
%     delta_l  = l - (f + sag(end).*(n2-n1)./n2);
%     l = l - delta_l;
%     sag = sag + delta_l;
    
    %Condition d'existance physique de la pièce
    if min(sag) < 0
        sag = sag - min(sag);        
    end
    
    %Différence pour la condition de la boucle
    diff(k) = sum(abs(sag - old_sag))./n_pts;
    old_sag = sag;
    if k > iter_max
        break
    end
    
end
end

