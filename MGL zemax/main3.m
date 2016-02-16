% Création d'un grid sag adapté à l'exportation dans zemax.
clear
%Configuration des paramètres
run config.m

s_max = hfov.*(1-z/f);

%Création de la fonction de grandissement
G = fun_creation(type_dist,r1,r2,g1,g2);

%Calcul du profil de distortion recherché
[distortion,P] = calc_dist(G,hfov,1000);

figure(1);plot( linspace(0,hfov,1000),P,linspace(0,hfov,1000),gradient(P));
figure(3);plot(distortion, linspace(0,hfov,1000));

%Calcul du profil de front d'onde (1000 points)
n_profile = 1000;

n1 = 1; %air
n2 = 1.5185; %~BK7
%[ sag_profile ,l, s_profile,z,diff ] = G2sag( f,z,n1,n2,G,s_max, n_profile );
[ sag_profile, l, s_profile, diff,x_croisement,y_croisement ] = G2sag_v2( f,z,n1,n2,G,s_max, n_profile );

%Grille d'évaluation de S
[sx,sy] = meshgrid(linspace(-s_max,s_max,n),linspace(-s_max,s_max,n));
sr = sqrt(sx.^2+sy.^2);

sag = interp1(s_profile,sag_profile,sr);
figure(2);mesh(sx,sy,sag)

% disp('Dimensions finales')
% disp('air =');
% disp(f-z);
% disp('verre');
% disp(l - f + z)


%% Exportation sag direct
path = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_gaussien_1_6.dat';
zemax_sag_dat_2( path, -sag , 2*s_max, 2*s_max);

%% Générer les graphiques
%Distortion
figure(3); plot(distortion, linspace(0,10,1000),zemax(:,6)-min(zemax(:,6)),zemax(:,1));
xlabel('Distortion')
ylabel('FoV [degree]')
legend('Demandé','Calculé par Zemax')

%Sag
figure;plot(s_profile,sag_profile)
xlabel('Rayon')
ylabel('Sag')