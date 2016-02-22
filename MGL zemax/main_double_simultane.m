% Création d'un grid sag adapté à l'exportation dans zemax.
%Premier essai à deux surfaces. Résultat inconcluant dans la forme
%actuelle.
clear
%Configuration des paramètres
run config.m

s_max = hfov.*(1-z/f);

%Création de la fonction de grandissement
G = fun_creation(type_dist,r1,r2,g1,g2);

%Calcul du profil de distortion recherché
[distortion,P] = calc_dist(G,hfov,1000);

figure(1);plot( linspace(0,hfov,1000),P,linspace(0,hfov,1000),gradient(P));
figure(4);plot(distortion, linspace(0,hfov,1000));

%Calcul du profil de front d'onde (1000 points)
n_profile = 1000;

n1 = 1; %air
n2 = 1.53; %~BK7
f2 = 10;
[ sag_profile1, sag_profile2, l, s_profile1,s_profile2, diff ] = G2double_sag( f,f2,z,n1,n2,G,s_max,hfov, n_profile );

%Grille d'évaluation de S
[sx,sy] = meshgrid(linspace(-s_max,s_max,n),linspace(-s_max,s_max,n));
sr = sqrt(sx.^2+sy.^2);
sag1 = interp1(s_profile1,sag_profile1,sr);

[sx,sy] = meshgrid(linspace(-max(s_profile2),max(s_profile2),n),linspace(-max(s_profile2),max(s_profile2),n));
sr = sqrt(sx.^2+sy.^2);
sag2 = interp1(s_profile2,sag_profile2,sr);

figure(2);mesh(sx,sy,sag1);
figure(3);mesh(sx,sy,sag2);


%% Exportation sag direct
path1 = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_surf_1_couple.dat';
path2 = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_surf_2_couple.dat';
zemax_sag_dat_2( path1, -sag1 , 2*max(s_profile1), 2*max(s_profile1));
zemax_sag_dat_2( path2, sag2 , 2*max(s_profile2), 2*max(s_profile2));