function [ px,pz,w ] = vect2nurbs( z, px , distance, n )
%VECT2NURBS Convertie une courbe en NURBS
%   G�n�re les coordonn�es d'une courbe NURBS � n points � partir d'un
%   vecteur z(x).

% px(i): coordonn� du point de contr�le i en x
% pz(i): coordonn� du point de contr�le i en z
% w(i): poid du point de contr�le i

%Vecteur x
%Nombre de point de contr�le
i = numel(px);
%Position du dernier point de contr�le
x_max = px(i);
%Vecteur uniformement espac� en x
x = linspace(0,x_max,numel(z));

%D�termination heuristique des points de contr�le

%Le premier et dernier point en z directement sur la courbe
pz(1) = z(1);
pz(i) = z(numel(z));

%Position interm�diaire entre les points de contr�le
c = linspace(0.5*x_max/i,(i-0.5)*x_max/i,i-1);
%�valuation de la courbe z au point c
%cz = interp1(x,z,c,'linear');

pz_temp = interp1(x,z,px,'linear');

%D�termination en chaine des points de contr�le restant 
for k = 2:(i-1)
    pz(k) = pz_temp(k) +(-1).^k.*distance;
end

%Distribution initiale des poids uniforme
w = ones(i,1);

%G�n�ration de la base en fonction de la position des points
[N] = base_generation(i,x,px,n);

%�valuation
[c_x,c_z] = nurbs_eval(N,px,pz,w,i,x);

end

function [N] = base_generation(i,pts,px,n)
    %�valuation de la fonction de base N
    N = zeros(i,numel(pts));
    %Ordre z�ro
    %largeur = numel(pts)./n;
    for l = 1:(i-1)
        a = pts > px(l);
        b = pts < px(l+1);
        N(l,:) = cast(a & b,'double');
    end
    %Ordres sup�rieurs jusqu'a n
    for l = 1:n
        N_moins_un = N;
        N = zeros(i-l-1,numel(pts));
        %Chaque point de contr�le
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
    %�value la courbe d�ffinie par px,pz,w sur n points
    c_x = zeros(1,numel(pts));
    c_z = c_x;
    
    for k = 1:i
        c_x = c_x + (N(k,:).*w(k).*px(k))./sum(N(k,:).*w(k));
        c_z = c_z + (N(k,:).*w(k).*pz(k))./sum(N(k,:).*w(k));
    end
    
end