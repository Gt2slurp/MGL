% Loop de calcul de plusieurs positions. G�n�re la courbure locale et
% calcule la d�terioration du front d'onde a chaque position. Ne 
% sauvergarde pas les front d'ondes.

clear

%Param�tre de configuration de la simulation
run config.m

%Calcul de la forme g�n�rale du grandissement
n_vis = 101;
[visualisation(1).img,visualisation(2).img] = meshgrid(linspace(-1,1,n_vis),linspace(-1,1,n_vis));
switch type_dist
    case 'quadratique'
        [visualisation(1).dist,visualisation(2).dist, visualisation(1).delta,visualisation(2).delta] = gen_dist( n_vis,cx,cy,r1,r2,g1,g2,visualisation(1).img,visualisation(2).img);
    case 'gaussien'
        [visualisation(1).dist,visualisation(2).dist, visualisation(1).delta,visualisation(2).delta] = gen_dist_gauss( n_vis,cx,cy,r1,r2,g1,g2,visualisation(1).img,visualisation(2).img);
end
Px = visualisation(1).dist;
Py = visualisation(2).dist;
figure(4);plot(echelle_systeme.*reshape(Px,[numel(Px),1]),echelle_systeme.*reshape(Py,[numel(Py),1]),'.');hold on;

%Calcul de la forme de l'OPD total de S
[ visualisation ] = deviation( visualisation,z );
switch type_dist
    case 'quadratique'
        [ opd_visualisation ] = masque_opd( visualisation,n_vis);
    case 'gaussien'
        [ opd_visualisation ] = masque_opd_gauss( visualisation,g1,g2,r1,r2,n);
end
figure(6);mesh(echelle_systeme.*linspace(-1,1,n_vis),echelle_systeme.*linspace(-1,1,n_vis),opd_visualisation);
xlabel('x');ylabel('y'),zlabel('OPD');
title('OPD � la surface S')

if max(max(abs(opd_visualisation))) > z
    warning('La variation maximale d''opd est plus grande que la distance � l''image')
end

%% Simulation

%Calcul de chaque position
for k = 1:numel(x)
    
    %�limination des structures de la boucle pr�c�dente
    clear ray_fan rayon_chef psf opd pupille
    
    %Structure faisceau de rayon
    u_temp = linspace(-1/(2*f_number),1/(2*f_number),n);
    [pupille(:,:,1),pupille(:,:,2)] = meshgrid(u_temp,u_temp);
    ray_fan(1) = struct('img', x(k), 'pupille', pupille(:,:,1));
    ray_fan(2) = struct('img', y(k), 'pupille', pupille(:,:,2));
    clear pupille u_temp
    
    %Calcul du plan S intercept�
    [ ray_fan ] = complete_geometrie( ray_fan,z );
    
    %Cr�ation de plusieurs rayons chefs � partir des points intercept�es de S
    rayon_chef(1) = struct('pupille', 0, 's',ray_fan(1).s);
    rayon_chef(2) = struct('pupille', 0, 's',ray_fan(2).s);
    [ rayon_chef ] = complete_geometrie( rayon_chef,z );
    
    %Profil de distortion
    %dist: Point d'arriv�e du rayon avec grandissement
    %delta: Diff�rence avec les points originaux
    switch type_dist
        case 'quadratique'
        [ rayon_chef(1).dist, rayon_chef(2).dist , rayon_chef(1).delta, rayon_chef(2).delta] = gen_dist( n,cx,cy,r1,r2,g1,g2,rayon_chef(1).img,rayon_chef(2).img);
        case 'gaussien'
        [ rayon_chef(1).dist, rayon_chef(2).dist , rayon_chef(1).delta, rayon_chef(2).delta] = gen_dist_gauss( n,cx,cy,r1,r2,g1,g2,rayon_chef(1).img,rayon_chef(2).img);

    end
    
    %Calcul de l'angle de d�viation
    [ rayon_chef ] = deviation( rayon_chef,z );
    
    %Calcul de l'OPD g�n�r� par la surface S
    switch type_dist
        case 'quadratique'
            [ opd.s ] = masque_opd( rayon_chef,n);
        case 'gaussien'
            %[ opd.s ] = masque_opd_gauss( rayon_chef,g1,g2,r1,r2);
            [ opd.s ] = masque_opd( rayon_chef,n);
    end
    
    %Calcul de l'OPD g�n�r� par l'angle du rayon chef du faisceau original
    opd.tilt = opd_tilt(ray_fan,f_number,z,n);
    
    %Calcul de l'opd total et du tilt effectif
    opd = opd_calc_v2(opd,ray_fan,z,n);
    
    ratio_erreur_theta = atan(ray_fan(1).img)./opd.theta;
    ratio_erreur_phi = atan(ray_fan(2).img)./opd.phi;
    
    %Calcul de la PSF
    pad_size = 2;
    pad_vect = pad_size.*[n n];
    n_tot = (2*pad_size+1)*n;
    
    %Pupille de rayon 1
    pupille.opd = circle_array(n);
    %Ajout des OPDs en phase � la pupille
    pupille.opd = pupille.opd.*exp(2*pi*1i*(opd.st)/lambda);
    %Pad ajoute de la r�solution, change l'�chelle au d�tecteur.
    %Cast en single pour sauver de la m�moire
    pupille.pad = padarray(cast(pupille.opd,'single'), pad_vect);
    
    %Propagation de la pupille
    psf.data = fft2(pupille.pad);
    psf.strehl_ratio = abs(psf.data(1,1)./sum(sum(abs(pupille.pad))));
    psf.data = fftshift(psf.data);
    
    %Normalisation de la psf
    psf.norm = psf.data./(sum(sum(abs(pupille.pad))));
    
    %R�cup�ration des donn�es
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
xlabel('Coordonn�e image x');ylabel('Coordonn�e image y')
legend('grille','Avant grandissement','Apr�s grandissement');hold off;
figure(5);plot(var_fig,save_struct.zernike(:,7),var_fig,save_struct.zernike(:,8),var_fig,save_struct.zernike(:,9),var_fig,save_struct.zernike(:,10),...
    var_fig,save_struct.zernike(:,11),var_fig,save_struct.zernike(:,12),var_fig,save_struct.zernike(:,13),var_fig,save_struct.zernike(:,14),var_fig,save_struct.zernike(:,15))
xlabel('Rayon');ylabel('Coeficient de Zernike')
figure(7);plot(var_fig,save_struct.foyer-echelle_systeme.*z)
xlabel('Rayon');ylabel('Distance de meilleur foyer')

%% Sauvegarde

%Path de sauvegarde
save_path = 'C:\Users\Alex C�t�\Documents\GitHub\MGL\Data\mgl_data_test.mat';



%Ajout des informations importantes dans la structure
save_struct.var_fig = var_fig;
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
save_struct.type_dist = type_dist;

%V�rification si la structure de sauvegarde existe
if exist(save_path,'file')
    load(save_path);
    data_struct(end+1) = save_struct;
    save(save_path,'data_struct');
else
    data_struct = save_struct;
    save(save_path,'data_struct');
end

%% Export .DAT

zemax_phase_dat( 'C:\Users\Alex C�t�\Documents\Zemax\Objects\Grid Files\test.dat', opd_visualisation./lambda , echelle_systeme,echelle_systeme);

