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
n_profile = 2000;
% z_vect = z.*ones(1,n_profile);
% n1 = 1; %air
% n2 = 1.53; %~BK7
% delta = 1;
% W_old = 0;
% while delta > 1E-15
% [W_profile, s_profile] = Gprofile2wavefont( G, z_vect, f, s_max,n_profile);
% z_vect = z + W_profile./(n2-n1);
% if min(min(z_vect)) <= 0
%     error('surface impossible')
% end
% delta = sum(abs(W_old - W_profile))./n_profile;
% W_old = W_profile;
% end
n1 = 1; %air
n2 = 1.53; %~BK7
[ sag_profile ,l, s_profile,z ] = G2sag( f,z,n1,n2,G,s_max, n_profile );

%Grille d'évaluation de S
[sx,sy] = meshgrid(linspace(-s_max,s_max,n),linspace(-s_max,s_max,n));
sr = sqrt(sx.^2+sy.^2);

% W = interp1(s_profile,W_profile,sr);
% figure(2);mesh(sx,sy,W)

sag = interp1(s_profile,sag_profile,sr);
figure(2);mesh(sx,sy,sag)

disp('Dimensions finales')
disp('air =');
disp(f-z);
disp('verre');
disp(l - f + z)

%%
%Exportation en sag dans zemax
n1 = 1; %air
n2 = 1.53; %~BK7
if (min(min(W./(n2-n1))) + z) < 0
    error('La surface est impossible');
end
path = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_reel.dat';
% zemax_sag_dat( path, W , 2*s_max, 2*s_max, n1, n2);

%% Exportation sag direct
path = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_reel.dat';
zemax_sag_dat_2( path, -sag , 2*s_max, 2*s_max);