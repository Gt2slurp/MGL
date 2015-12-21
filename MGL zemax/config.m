%lambda = 500E-9;
%Distance focale du système 100mm
f = 100;
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.04*f;
%F number du faisceau
f_number = 15;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 2;
g2 = 1;
%Champ de vu maximal
hfov = f*tan(deg2rad(10));
%Rayon de la surface à grandir. Le rayon final sera r1*g.
r1 = f*tan(deg2rad(1));
%Rayon de la zone de redressement
r2 = f*tan(deg2rad(6));
%Type de profil de distorsion (gaussien ou quadratique)
type_dist = 'quadratique';
%Nombre de point calculé par axe
n = 400;





%n = 501;
%Vecteur de points à analyser sur l'image
%r = linspace(0,0.4,20);
%theta = linspace(0,4*pi,20);
% x = linspace(0,0.5,20);
% y = zeros(1,20);
%[x,y] = pol2cart(theta,r);
%Analyse centré sur le centre de la distortion
%x = x + cx;
%y = y + cy;