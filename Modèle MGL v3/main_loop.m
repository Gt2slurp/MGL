% Loop de calcul de plusieurs positions
%Ne sauvergarde pas les front d'ondes
clear

%Paramètre de configuration de la simulation
run config.m

%Calcul de la forme générale du grandissement
n_vis = 151;
[visualisation(1).img,visualisation(2).img] = meshgrid(linspace(-1,1,n_vis),linspace(-1,1,n_vis));
[visualisation(1).dist,visualisation(2).dist, visualisation(1).delta,visualisation(2).delta] = gen_dist( n_vis,cx,cy,r1,r2,g1,g2,visualisation(1).img,visualisation(2).img);
Px = visualisation(1).dist;
Py = visualisation(2).dist;
figure(4);plot(echelle_systeme.*reshape(Px,[numel(Px),1]),echelle_systeme.*reshape(Py,[numel(Py),1]),'.');hold on;

%Calcul de la forme de l'OPD total de S
[ visualisation ] = deviation( visualisation,z );
[ opd_visualisation ] = masque_opd( visualisation,n_vis);
figure(6);mesh(echelle_systeme.*linspace(-1,1,n_vis),echelle_systeme.*linspace(-1,1,n_vis),opd_visualisation);
xlabel('x');ylabel('y'),zlabel('OPD');
title('OPD à la surface S')

if max(max(abs(opd_visualisation))) > z
    warning('La variation maximale d''opd est plus grande que la distance à l''image')
end

%% Simulation

%Calcul de chaque position
for k = 1:numel(x)
    
    %Élimination des structures de la boucle précédente
    clear ray_fan rayon_chef psf opd pupille
    
    %Structure faisceau de rayon
    u_temp = linspace(-1/(2*f_number),1/(2*f_number),n);
    [pupille(:,:,1),pupille(:,:,2)] = meshgrid(u_temp,u_temp);
    ray_fan(1) = struct('img', x(k), 'pupille', pupille(:,:,1));
    ray_fan(2) = struct('img', y(k), 'pupille', pupille(:,:,2));
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
    switch type_dist
        case 'quadratique'
        [ rayon_chef(1).dist, rayon_chef(2).dist , rayon_chef(1).delta, rayon_chef(2).delta] = gen_dist( n,cx,cy,r1,r2,g1,g2,rayon_chef(1).img,rayon_chef(2).img);
        case 'gaussien'
        [ rayon_chef(1).dist, rayon_chef(2).dist , rayon_chef(1).delta, rayon_chef(2).delta] = gen_dist_gauss( n,cx,cy,r1,r2,g1,g2,rayon_chef(1).img,rayon_chef(2).img);

    end
    %Illustration de la distortion

    
    %Calcul de l'angle de déviation
    [ rayon_chef ] = deviation( rayon_chef,z );
    
    %Calcul de l'OPD généré par la surface S
    [ opd.s ] = masque_opd( rayon_chef,n);
    
    %Calcul de l'OPD généré par l'angle du rayon chef du faisceau original
    opd.tilt = opd_tilt(ray_fan,f_number,z,n);
    
    %Calcul de l'opd total et du tilt effectif
    opd = opd_calc_v2(opd,ray_fan,z,n);
    % figure;subplot(2,2,1);mesh(opd.total);
    % title('OPD total à la surface S');
    % subplot(2,2,2);mesh(opd.st);
    % title('OPD sans tilt à la surface S');
    
    ratio_erreur_theta = atan(ray_fan(1).img)./opd.theta;
    ratio_erreur_phi = atan(ray_fan(2).img)./opd.phi;
    
%     opd.delta_x
%     opd.delta_y
    
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
%     pupille.x = linspace((2*pad_size+1).*min(min(ray_fan(1).s)),(2*pad_size+1).*max(max(ray_fan(1).s)),n_tot);
%     pupille.y = linspace((2*pad_size+1).*min(min(ray_fan(2).s)),(2*pad_size+1).*max(max(ray_fan(2).s)),n_tot);
    
    % subplot(2,2,3);imagesc(pupille.x,pupille.y,angle(pupille.pad));
    % title('Phase du faisceau à S sans tilt');
    
    %Propagation de la pupille
    psf.data = fft2(pupille.pad);
    psf.strehl_ratio = abs(psf.data(1,1)./sum(sum(abs(pupille.pad))));
    psf.data = fftshift(psf.data);
    %Normalisation de la psf
    psf.norm = psf.data./(sum(sum(abs(pupille.pad))));
    
    %Échelle de la PSF
%     psf.x = ((lambda*f_number))*linspace(-n/2,n/2,n_tot);
%     psf.y = ((lambda*f_number))*linspace(-n/2,n/2,n_tot);
    % subplot(2,2,4);imagesc(psf.x + opd.delta_x, psf.y + opd.delta_y,abs(psf.norm));
    % title('PSF sans tilt');
    
    %Récupération des données
    save_struct.err_rms(k) = echelle_systeme.*opd.err_rms;
    save_struct.strehl_ratio(k) = psf.strehl_ratio;
    save_struct.zernike(k,:) = opd.zernike;
    save_struct.x_reel(k) = rayon_chef(1).dist((n-1)/2+1,(n-1)/2+1);
    save_struct.y_reel(k) = rayon_chef(2).dist((n-1)/2+1,(n-1)/2+1);
    save_struct.foyer(k) = echelle_systeme.*opd.foyer;
    
end

%% Figures

var_fig = echelle_systeme.*sqrt((save_struct.x_reel-cx).^2+(save_struct.y_reel-cy).^2);
figure(1);plot(var_fig,save_struct.err_rms/lambda)
xlabel('Rayon');ylabel('RMS error [lambda]')
figure(2);plot(var_fig,save_struct.strehl_ratio);ylim([0 1])
xlabel('Rayon');ylabel('Strehl Ratio')
figure(3);plot(var_fig,save_struct.zernike(:,4),var_fig,save_struct.zernike(:,5),var_fig,save_struct.zernike(:,6))
%figure(3);plot(var_fig,zernike(:,4),var_fig,zernike(:,5)+ zernike(:,6))
xlabel('Rayon');ylabel('Coeficient de Zernike')
legend('Defocus','Astigmatisme x','Astigmatisme y')
%legend('Defocus','Astigmatisme x + y')
figure(4);plot(echelle_systeme.*x,echelle_systeme.*y,'-o',echelle_systeme.*save_struct.x_reel,echelle_systeme.*save_struct.y_reel,'-o');
xlabel('Coordonnée image x');ylabel('Coordonnée image y')
legend('grille','Avant grandissement','Après grandissement');hold off;
figure(5);plot(var_fig,save_struct.zernike(:,7),var_fig,save_struct.zernike(:,8),var_fig,save_struct.zernike(:,9),var_fig,save_struct.zernike(:,10),...
    var_fig,save_struct.zernike(:,11),var_fig,save_struct.zernike(:,12),var_fig,save_struct.zernike(:,13),var_fig,save_struct.zernike(:,14),var_fig,save_struct.zernike(:,15))
xlabel('Rayon');ylabel('Coeficient de Zernike')
figure(7);plot(var_fig,save_struct.foyer-echelle_systeme.*z)
xlabel('Rayon');ylabel('Distance de meilleur foyer')

%% Sauvegarde

%Path de sauvegarde
save_path = 'C:\Users\Alex Côté\Documents\GitHub\MGL\Data\mgl_data';

%Ajout des informations importantes dans la structure
save_struct.cx = cx;
save_struct.cy = cy;
save_struct.echelle_systeme = 0.2;
save_struct.z = z;
save_struct.f_number = f_number;
save_struct.g1 = g1;
save_struct.g2 = g2;
save_struct.r1 = r1;
save_struct.r2 = r2;
save_struct.x = x;
save_struct.y = y;

load(save_path);
data_struct(end+1) = save_struct;
save(save_path,'data_struct');