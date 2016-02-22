function [ x_croisement,y_croisement ] = courbure_champ_v2( r,s,sag,theta_n,f,n )
%COURBURE_CHAMP_V2 Summary of this function goes here
%   Detailed explanation goes here

%Symétrisation du système
s = [fliplr(-s) s];
sag = [fliplr(sag) sag];
theta_n = [fliplr(theta_n) theta_n];

r_rep = repmat(r,size(s,2),1);
s = repmat(s,size(r,2),1);
sag_rep = repmat(sag,size(r,2),1);

%Équation des droites déffinissant les rayons marginaux y = mx+p;
p1 = 1;
p2 = -1;
m1 = (r_rep-1)./f;
m2 = (r_rep+1)./f;

%Distance aux points (s,sag) de chaque rayon marginaux
d1 = abs(m1.*(f-sag_rep)' - s' + p1)./sqrt(1 + m1.^2);
d2 = abs(m2.*(f-sag_rep)' - s' + p2)./sqrt(1 + m2.^2);

%Les deux plus petites valeurs de d sont les points entres lesquelles la
%droite passe.
[~,index1] = sort(d1,1);
[~,index2] = sort(d2,1);

%Valeur de la normale aux points les plus proches
for k = 1:size(index1,2)
    theta_n_near1(:,k) = theta_n([index1(1,k) index1(2,k)]);
    theta_n_near2(:,k) = theta_n([index2(1,k) index2(2,k)]);
    s_near1(:,k) = s(k,[index1(1,k) index1(2,k)]);
    s_near2(:,k) = s(k,[index2(1,k) index2(2,k)]);
    sag_near1(:,k) = sag_rep(k,[index1(1,k) index1(2,k)]);
    sag_near2(:,k) = sag_rep(k,[index2(1,k) index2(2,k)]);
end

% %Calcul de l'angle moyen par interpolation au premier ordre
theta_n_moy1 = (d1(1,:).*theta_n_near1(1,:) + d2(1,:).*theta_n_near1(2,:))./(d1(1,:)+d2(1,:));
theta_n_moy2 = (d1(2,:).*theta_n_near2(1,:) + d2(2,:).*theta_n_near2(2,:))./(d1(2,:)+d2(2,:));

%Valeur de s et sag des points les plus proches


s_moy1 = (d1(1,:).*s_near1(1,:) + d2(1,:).*s_near1(2,:))./(d1(1,:)+d2(1,:));
s_moy2 = (d1(2,:).*s_near2(1,:) + d2(2,:).*s_near2(2,:))./(d1(2,:)+d2(2,:));
sag_moy1 = (d1(1,:).*sag_near1(1,:) + d2(1,:).*sag_near1(2,:))./(d1(1,:)+d2(1,:));
sag_moy2 = (d1(2,:).*sag_near2(1,:) + d2(2,:).*sag_near2(2,:))./(d1(2,:)+d2(2,:));

% %Points minimum de d
% s_near1 = s(:,[index1(1) index1(2)]);
% s_near2 = s(:,[index2(1) index2(2)]);
% sag_near1 = sag(:,[index1(1) index1(2)]);
% sag_near2 = sag(:,[index2(1) index2(2)]);
% 
% %Moyenne des points étant donné qu'ils sont très rapproché
% s_near = (s_near1 + s_near2)./2;
% sag_near = (sag_near1 + sag_near2)./2;

%Calcul de la loi de Snell
theta_1_1 = atan(r-1./f);
theta_2_1 = asin((1/n).*sin(theta_1_1-theta_n_moy1)) + theta_n_moy1;
theta_1_2 = atan(r+1./f);
theta_2_2 = asin((1/n).*sin(theta_1_2-theta_n_moy2)) + theta_n_moy2;

%Interception entre les rayons marginaux et le rayon chef
%Équation des rayons marginaux y = a1x+b1, y = a2x+b2

a1 = tan(theta_2_1);
a2 = tan(theta_2_2);
b1 = -a1.*(f-sag_moy1) + s_moy1;
b2 = -a2.*(f-sag_moy2) + s_moy2;

%Point de croisement des deux courbes
x_croisement = (b2-b1)./(a1-a2);
y_croisement = (a1.*b2 - a2.*b1)./(a1-a2);
end

