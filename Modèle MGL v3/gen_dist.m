function [ Px, Py , delta_x, delta_y] = gen_dist( n,cx,cy,r1,r2,g1,g2,x_mat,y_mat )
%GEN_DIST Summary of this function goes here
%   Création de la déviation induite par la distortion dans le cas
%   quadratique

%   cx, cy, représente le centre de la zone de grandissement. r1 le rayon
%   de la zone de grandissement. r2 le rayon de la zone de transition.

%Grille de calcul de la distortion
% x = linspace(xmin,xmax,n);
% y = linspace(ymin,ymax,n);
% [x_mat,y_mat] = meshgrid(x,y);

%Calcul du grandissement de la zone de redressement
%gr = (r2-g1.*r1)./(r2-r1);
% if gr < 0
%     warning('Le grandissement de la zone de redressement est négatif');
% end

%Px et Py sont la position en x et y de chaque point après que le
%grandissement soit appliqué
Px = zeros(n);
Py = Px;
for ii = 1:n
    for jj = 1:n
        %Distance au point c
        dc = sqrt((x_mat(ii,jj)-cx).^2+(y_mat(ii,jj)-cy).^2);
        dcx = x_mat(ii,jj)-cx;
        dcy = y_mat(ii,jj)-cy;
        %Zone de grandissement
        if dc  <= r1
            Px(ii,jj) = cx + g1.*dcx;
            Py(ii,jj) = cy + g1.*dcy;
        %Zone de redressement
        elseif dc <= r2
            %gr = g1.*((r2-dc)./(r2-r1)) + (1 - ((r2-dc)./(r2-r1)));
            gr = (g1-g2).*((dc-r2)./(r1-r2)).^2 + g2;
            %Px(ii,jj) = cx + gr.*dcx + (g1-gr).*(r1./dc).*dcx;
            %Py(ii,jj) = cy + gr.*dcy + (g1-gr).*(r1./dc).*dcy;
            Px(ii,jj) = cx + gr.*dcx;
            Py(ii,jj) = cy + gr.*dcy;
        %Zone non affectée
        else
            Px(ii,jj) = cx + g2.*dcx;
            Py(ii,jj) = cy + g2.*dcy;
        end
    end
end

%Déplament de chaque point induit par le grandissement
delta_x = Px - x_mat;
delta_y = Py - y_mat;
        
end

