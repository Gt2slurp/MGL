%Distance de l'image
z = 0.3;
f_number = 1;
lambda = 500E-9;
%Nombre de point dans la pupille
np = 501;
%Nombre de fois la taille de pupille autour de la TF
pad_size = 2;
pad_vect = pad_size.*[np np];
n_tot = (2*pad_size+1)*np;

%Pupille de rayon 1
pupille = circle_array(np);
%Échelle de la pupille
x_pupille = linspace(-(2*pad_size+1),(2*pad_size+1),n_tot);
%[grid_x_pupille,grid_y_pupille] = ndgrid(x_pupille,x_pupille);

%Ajout d'une phase linéaire à la pupille (tilt en degrées)
opd_vect_x = z*f_number/2*tan(degtorad(15)).*linspace(-1,1,np);
opd_vect_y = z*f_number/2*tan(degtorad(0)).*linspace(-1,1,np);
[opd_x,opd_y] = ndgrid(opd_vect_x ,opd_vect_y);
opd = opd_x + opd_y;

%Pad ajoute de la résolution, change l'échelle au détecteur.
pupille_pad = padarray(pupille.*exp(2*pi*1i*opd/lambda), pad_vect);

%Propagation de la pupille
psf = fftshift(fft2(pupille_pad));

%Normalisation de la psf par rapport à n
psf = psf./(sum(sum(abs(pupille_pad))));

%%
%Échelle de la PSF
x_psf = ((lambda*f_number))*linspace(-np/2,np/2,(2*pad_size+1)*np);
%x_psf = linspace(n/2,n/2,(2*pad_size+1)*n);

ligne_centrale = (2*pad_size+1)*np/2+0.5;

figure(1);imshow(abs(psf),[]);
figure(2);imshow(abs(pupille_pad),[])
figure(3);plot(x_psf,abs(psf(:,ligne_centrale)));
figure(5);plot(x_psf,unwrap(angle(psf(:,ligne_centrale))));
figure(4);plot(x_pupille,pupille_pad(:,ligne_centrale));