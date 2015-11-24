function [ px,pz,w ] = vect2nurbs( z, px , distance, n )
%VECT2NURBS Convertie une courbe en NURBS
%   Génére les coordonnées d'une courbe NURBS à n points à partir d'un
%   vecteur z(x).

% px(i): coordonné du point de contrôle i en x
% pz(i): coordonné du point de contrôle i en z
% w(i): poid du point de contrôle i

%Vecteur x
%Nombre de point de contrôle
i = numel(px);
%Position du dernier point de contrôle
x_max = px(i);
%Vecteur uniformement espacé en x
x = linspace(0,x_max,numel(z));

%Détermination heuristique des points de contrôle

%Le premier et dernier point en z directement sur la courbe
pz(1) = z(1);
pz(i) = z(numel(z));

%Position intermédiaire entre les points de contrôle
c = linspace(0.5*x_max/i,(i-0.5)*x_max/i,i-1);
%Évaluation de la courbe z au point c
%cz = interp1(x,z,c,'linear');

pz_temp = interp1(x,z,px,'linear');

%Détermination en chaine des points de contrôle restant 
for k = 2:(i-1)
    pz(k) = pz_temp(k) +(-1).^k.*distance;
end

%Distribution initiale des poids uniforme
w = ones(i,1);

%Génération de la base en fonction de la position des points
[N] = base_generation(i,x,px,n);

%Évaluation
[c_x,c_z] = nurbs_eval(N,px,pz,w,i,x);

end

function [N] = base_generation(i,pts,px,n)
    %Évaluation de la fonction de base N
    N = zeros(i,numel(pts));
    %Ordre zéro
    %largeur = numel(pts)./n;
    for l = 1:(i-1)
        a = pts > px(l);
        b = pts < px(l+1);
        N(l,:) = cast(a & b,'double');
    end
    %Ordres supérieurs jusqu'a n
    for l = 1:n
        N_moins_un = N;
        N = zeros(i-l-1,numel(pts));
        %Chaque point de contrôle
        for k = 1:(i-l-1)
            N(k,:) = basis_f(pts,px,k,l).*N_moins_un(k,:) + basis_g(pts,px,k+1,l).*N_moins_un(k+1,:);
        end
    end
end

function [out] = basis_f(pts,px,i,n)
    out = (pts - px(i))./(px(i+n) - px(i));
end

function [out] = basis_g(pts,px,i,n)
    out = (px(i+n) - pts)./(px(i+n) - px(i));
end

function [c_x,c_z] = nurbs_eval(N,px,pz,w,i,pts)
    %Évalue la courbe déffinie par px,pz,w sur n points
    c_x = zeros(1,numel(pts));
    c_z = c_x;
    
    for k = 1:i
        c_x = c_x + (N(k,:).*w(k).*px(k))./sum(N(k,:).*w(k));
        c_z = c_z + (N(k,:).*w(k).*pz(k))./sum(N(k,:).*w(k));
    end
    
end