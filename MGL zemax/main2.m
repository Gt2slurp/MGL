% Création d'un grid sag adapté à l'exportation dans zemax.
clear
%Configuration des paramètres
run config.m

s_max = hfov.*(1-z/f);

%Création de la fonction de grandissement
G = fun_creation(type_dist,r1,r2,g1,g2);

%Calcul du profil de distortion recherché
distortion = calc_dist(G,hfov,100);

%Calcul du profil de front d'onde (1000 points)
[W_profile, s_profile] = Gprofile2wavefont( G, z, f, s_max,1000);

%Grille d'évaluation de S
[sx,sy] = meshgrid(linspace(-s_max,s_max,n),linspace(-s_max,s_max,n));
sr = sqrt(sx.^2+sy.^2);

W = interp1(s_profile,W_profile,sr);

%Exportation en sag dans zemax
n1 = 1; %air
n2 = 1.53; %~BK7
path = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_test.dat';
zemax_sag_dat( path, W , s_max, s_max, n1, n2);