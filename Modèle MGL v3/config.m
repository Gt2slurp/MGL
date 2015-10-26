lambda = 500E-9;
%Échelle du système, correspond à la distance entre la pupille et l'image. 
%En mètres. Les résultats sont convertis, l'ensemble des calcul sont fait
%avec une échelle de 1.
echelle_systeme = 0.2; %20cm 
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.1;
%F number du faisceau
f_number = 15;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 2;
g2 = 1;
%Rayon de la surface à grandir. Le rayon final sera r1*g.
r1 = 0.2;
%Rayon de la zone de redressement
r2 = 0.3;
%Type de profil de distorsion (gaussien ou quadratique)
type_dist = 'gaussien';
%Nombre de rayon simulé par axe (toujours impair)
n = 501;
%Vecteur de points à analyser sur l'image
r = linspace(0,0.4,20);
theta = linspace(0,4*pi,20);
% x = linspace(0,0.5,20);
% y = zeros(1,20);
[x,y] = pol2cart(theta,r);
%Analyse centré sur le centre de la distortion
x = x + cx;
y = y + cy;