function [ sag,l,s,diff,sag2,s2 ] = G2sag_v3( f,z,n1,n2,G,s_max, n_pts )
%G2SAG_V2 Summary of this function goes here

%   Boucle it�rative de calcul de sag utilis� par main_double_correction

%Valeur intiale de sag
sag = z.*ones(1,n_pts);

%Vecteur s
s = linspace(0,s_max,n_pts);

%Valeur initiale de l
l = f + z.*(n2-n1)./n2;

%Tol�rance de la boucle
tol = 1E-15;
old_sag = 0;
k = 1;
iter_max = 50;
diff = ones(1,iter_max);
figure(4);hold on;

while diff(k) > tol
    k = k + 1;
    
    %Calcul du r �quivalent � chaque s
    r = s./(1-(sag./l));
    
    %Calcul des angles
    theta_1 = unwrap(atan2(s,(l-sag)));
    theta_2 = unwrap(atan2(r.*G(r)-s,sag));
    
    %Calcul de theta_n
    theta_n = solve_snell(theta_1,theta_2, n1, n2);
    
    %Calcul du sag (int�gration de seulement la moitier pour la stabilit�)
    sag = sag./2 + (cumtrapz(s,tan(theta_n)))./2;
    plot(sag)
    %Ajustement du sag pour garder l'image en moyenne au foyer paraxiale
%     delta_l  = l - (f + sag(end).*(n2-n1)./n2);
%     l = l - delta_l;
%     sag = sag + delta_l;
    
    %Condition d'existance physique de la pi�ce
    if min(sag) < 0
        sag = sag - min(sag);        
    end
    
    %Diff�rence pour la condition de la boucle
    diff(k) = sum(abs(sag - old_sag))./n_pts;
    old_sag = sag;
    if k > iter_max
        break
    end
    
end

%Cr�ation de la deuxi�me surface

%Distance parcourue � l'int�rieur de la lentille
opd = sqrt((r.*G(r)-s).^2 + sag.^2);

%Point composant la deuxi�me surface
sag2 = opd.*cos(theta_2);
s2 = r.*G(r) + opd.*sin(theta_2);

%R��chantillonnage de s2 pour le rendre constant
sag2 = interp1(s2,sag2,linspace(0,max(s2),numel(s2)));

end

