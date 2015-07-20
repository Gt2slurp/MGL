%%
clear
lambda = 500E-9;
%Nombre de rayon simulé par axe (toujours impair)
n = 501;
%Point à analyser sur l'image
x = 0;
y = 0;
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.05;
%F number du faisceau
f_number = 10;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 2;
g2 = 1;
%Rayon de la surface à grandir. Le rayon final sera r1*g.
r1 = 0.1;
%Rayon de la zone de redressement
r2 = 0.4;

%Structure faisceau de rayon
u_temp = linspace(-1/(2*f_number),1/(2*f_number),n);
[pupille(:,:,1),pupille(:,:,2)] = meshgrid(u_temp,u_temp);
ray_fan(1) = struct('img', x, 'pupille', pupille(:,:,1));
ray_fan(2) = struct('img', y, 'pupille', pupille(:,:,2));
clear pupille u_temp

%Calcul du plan S intercepté
[ ray_fan ] = complete_geometrie( ray_fan,z );

%Création de plusieurs rayons chefs à partir des points interceptées de S
rayon_chef(1) = struct('pupille', 0, 's',ray_fan(1).s);
rayon_chef(2) = struct('pupille', 0, 's',ray_fan(2).s);
[ rayon_chef ] = complete_geometrie( rayon_chef,z );

%Profil de distortion
%dist: Point d'arrivée du rayon avec grandissement
%delta: Différence avec les points originaux
[ rayon_chef(1).dist, rayon_chef(2).dist , rayon_chef(1).delta, rayon_chef(2).delta] = gen_dist( n,cx,cy,r1,r2,g1,g2,rayon_chef(1).img,rayon_chef(2).img);
%Illustration de la distortion
[x_mat,y_mat] = meshgrid(linspace(-1,1,n),linspace(-1,1,n));
[Px, Py, ~, ~] = gen_dist( n,cx,cy,r1,r2,g1,g2,x_mat,y_mat);
figure(1);scatter(reshape(Px,[numel(Px),1]),reshape(Py,[numel(Py),1]),'.');

%Calcul de l'angle de déviation
[ rayon_chef ] = deviation( rayon_chef,z );
 
%Calcul de l'OPD généré par la surface S
[ opd.s ] = masque_opd( rayon_chef,n);

%Calcul de l'OPD généré par l'angle du rayon chef du faisceau original
opd.tilt = opd_tilt(ray_fan,f_number,z,n);

%Calcul de l'opd total et du tilt effectif
opd = opd_calc_v2(opd,ray_fan,z,n);
figure;subplot(2,2,1);mesh(opd.total);
title('OPD total à la surface S');
subplot(2,2,2);mesh(opd.st);
title('OPD sans tilt à la surface S');

ratio_erreur_theta = atan(ray_fan(1).img)./opd.theta;
ratio_erreur_phi = atan(ray_fan(2).img)./opd.phi;

opd.delta_x
opd.delta_y

%Calcul de la PSF
pad_size = 2;
pad_vect = pad_size.*[n n];
n_tot = (2*pad_size+1)*n;

%Pupille de rayon 1
pupille.opd = circle_array(n);
%Ajout des OPDs en phase à la pupille
pupille.opd = pupille.opd.*exp(2*pi*1i*(opd.st)/lambda);
%Pad ajoute de la résolution, change l'échelle au détecteur.
%Cast en single pour sauver de la mémoire
pupille.pad = padarray(cast(pupille.opd,'single'), pad_vect);

%Échelle de la pupille
pupille.x = linspace((2*pad_size+1).*min(min(ray_fan(1).s)),(2*pad_size+1).*max(max(ray_fan(1).s)),n_tot);
pupille.y = linspace((2*pad_size+1).*min(min(ray_fan(2).s)),(2*pad_size+1).*max(max(ray_fan(2).s)),n_tot);

subplot(2,2,3);imagesc(pupille.x,pupille.y,angle(pupille.pad));
title('Phase du faisceau à S sans tilt');

%Propagation de la pupille
psf.data = fft2(pupille.pad);
psf.strehl_ratio = abs(psf.data(1,1)./sum(sum(abs(pupille.pad))));
psf.data = fftshift(psf.data);
%Normalisation de la psf
psf.norm = psf.data./(sum(sum(abs(pupille.pad))));

%Échelle de la PSF
psf.x = ((lambda*f_number))*linspace(-n/2,n/2,n_tot);
psf.y = ((lambda*f_number))*linspace(-n/2,n/2,n_tot);
subplot(2,2,4);imagesc(psf.x + opd.delta_x, psf.y + opd.delta_y,abs(psf.norm));
title('PSF sans tilt');