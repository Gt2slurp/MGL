function [ sag,l,s,z,diff ] = G2sag( f,z,n1,n2,G,s_max, n_pts )
%G2SAG Summary of this function goes here
%   Detailed explanation goes here

% isimpossible = 1;
% while isimpossible == 1
    
    %Longeur du foyer paraxial
    l = f + z.*(n2-n1)./n2;
    %Vecteurs des plans s et z
    s = linspace(0,s_max.*sqrt(2),n_pts);
    r = s./(1 - z./l);
    
    %Valeur initiale du sag
    sag = zeros(1,n_pts);
    
    %Tolérance de la boucle
    tol = 1E-15;
    diff = 1;
    %f_eval = (r.*G(r)-s);
    old_sag = 0;
    k = 1;
    
    while diff(k) > tol
        k = k +1;
        l = f + z.*(n2-n1)./n2;
        r = s./(1 - z./l);
        f_eval = (r.*G(r)-s);
        %1. Calcul de theta 1 et 2
        theta_1 = atan2(s,(l-z+sag));
        theta_2 = atan2(f_eval,(z-sag));
        
        %2. Calcul de theta_N
        theta_N = solve_snell(theta_1, theta_2, n1, n2);
        
        %3. Calcul du sag
        sag = cumtrapz(s,tan(theta_N));
        %sag = sag - sag(end);
  
        
        diff(k) = sum(abs(sag - old_sag))./n_pts;
        old_sag = sag;
        if k > 100
            break
        end
    end
    
% if -min(min(sag-sag(end))) > z
%     z = z + 0.5;
% else
%     isimpossible = 0;
% end
    
% end

%figure;plot(dist_check(sag,theta_1, theta_N,s,r,n1,n2,z));

end

%Fonction qui résoue la fonction transcendante à chaque point
% function theta_N = solve_snell(theta_1, theta_2, n1, n2)
% 
% theta_N = zeros(1,numel(theta_1));
% 
% for k = 1:numel(theta_1)
%     loi_snell = @(theta_N) n1.*sin(theta_1(k)-theta_N) - n2.*sin(theta_2(k)-theta_N);
%     theta_N(k) = fzero(loi_snell,0.5);s
% end
% 
% end

function dist = dist_check(sag,theta_1, theta_N,s,r,n1,n2,z)

theta_2 = asin((n1./n2).*sin(theta_1-theta_N)) + theta_N;

G = ((z + sag).*tan(theta_2)+s)./r;

dist = 100.*(G-1);
dist = dist - dist(end);
end