function [ Px, Py , delta_x, delta_y ] = gen_dist_gauss( n,cx,cy,r1,r2,g1,g2,x_mat,y_mat )
%GEN_DIST_GAUSS Summary of this function goes here
%   Detailed explanation goes here

Px = zeros(n);
Py = Px;

%Sigma calculé pour que la largeur à mi hauteur soient égale à la moyenne
%de r1 et r2
sigma = (r1+r2)/(2*2.35); 

for ii = 1:n
    for jj = 1:n
        %Distance au point c
        dc = sqrt((x_mat(ii,jj)-cx).^2+(y_mat(ii,jj)-cy).^2);
        dcx = x_mat(ii,jj)-cx;
        dcy = y_mat(ii,jj)-cy;
        
        gr = (g1 - g2).*exp(-(dc/sigma).^2) + g2;
        
        Px(ii,jj) = cx + gr.*dcx;
        Py(ii,jj) = cy + gr.*dcy;
    end
end


%Déplament de chaque point induit par le grandissement
delta_x = Px - x_mat;
delta_y = Py - y_mat;
end

