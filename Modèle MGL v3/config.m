lambda = 500E-9;
%�chelle du syst�me, correspond � la distance entre la pupille et l'image. 
%En m�tres. Les r�sultats sont convertis, l'ensemble des calcul sont fait
%avec une �chelle de 1.
echelle_systeme = 0.2; %20cm 
%Nombre de rayon simul� par axe (toujours impair)
n = 501;
%Vecteur de points � analyser sur l'image
r = linspace(0,0.4,20);
theta = linspace(0,4*pi,20);
% x = linspace(0,0.5,20);
% y = zeros(1,20);
[x,y] = pol2cart(theta,r);
% x = 0;
% y = 0;
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.1;
%F number du faisceau
f_number = 15;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 1.3;
g2 = 1;
%Rayon de la surface � grandir. Le rayon final sera r1*g.
r1 = 0.1;
%Rayon de la zone de redressement
r2 = 0.3;
