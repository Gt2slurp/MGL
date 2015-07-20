% Calcul d'un profil de surface à partir d'une courbe de distortion visée.
% Analyse du profil distortion généré et de la psf de différentes partie de
% l'image.

%% Génération du masque de phase

lambda = 500E-9;
%Nombre de rayon simulé par axe
n = 151;
%Taille de l'image
xmax = 0.6;
ymax = 0.6;
xmin = -0.6;
ymin = -0.6;
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.05;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 1;
g2 = 1;
%Rayon de la surface à grandir. Le rayon final sera r1*g.
r1 = 0.1;
%Rayon de la zone de redressement
r2 = 0.4;

%Profil de distortion désiré
%P: Point d'arrivée du rayon avec grandissement
%mat: Rayon original
%delta: Différence
[ Px, Py , delta_x, delta_y, x_mat, y_mat] = gen_dist(n,cx,cy,r1,r2,g1,g2,xmax,ymax,xmin,ymin);
figure(1);scatter(reshape(Px,[numel(Px),1]),reshape(Py,[numel(Py),1]),'.');

%Plan x-y sur l'image et u-v dans la pupille. 
x = x_mat;
y = y_mat;
u = 0;
v = 0;

%Intersection avec le plan S
[ xs, ys, theta_S, phy_S ] = geometrie( x,y,u,v,z );

%Calcul des angles de déviation par S
[ theta_D,phy_D ] = deviation( x,y,z,delta_x,delta_y );

%Masque d'OPD
[ opd ] = masque_opd( theta_D,phy_D,n,xmax,ymax);
figure(2);mesh(xs,ys,opd);


%% Analyse de la distortion réelle



%% Analyse de la psf

%Point à analyser
% k = 120;
% l = 125;
% x_psf = x_mat(k,l);
% y_psf = y_mat(k,l);
% delta_x(k,l)
% delta_y(k,l)
x_psf = 0.005;
y_psf = 0.005;

f_number = 20;

%Nombre de point dans la pupille
np = 1001;
%Nombre de fois la taille de pupille autour de la TF
pad_size = 1;
pad_vect = pad_size.*[np np];
n_tot = (2*pad_size+1)*np;

%Calcul de la portion de S intercepté
umax = 1/f_number;
vmax = 1/f_number;
[ xsmax, ysmax, ~, ~] = geometrie( x_psf,y_psf,umax,vmax,z );
[ xsmin, ysmin, ~, ~] = geometrie( x_psf,y_psf,-umax,-vmax,z );
[xs_inter,ys_inter] = meshgrid(linspace(xsmin,xsmax,np),linspace(ysmin,ysmax,np));

%Calcul de l'OPD due au tilt
[ opd_t ] = opd_tilt(x_psf,y_psf,z,f_number,np);
%figure(6);mesh(linspace(xsmin,xsmax,np),linspace(ysmin,ysmax,np),opd_t);

%Pupille de rayon 1
pupille = circle_array(np);
%Échelle de la pupille dans S
x_pupille = linspace((2*pad_size+1).*xsmin,(2*pad_size+1).*xsmax,n_tot);
y_pupille = linspace((2*pad_size+1).*ysmin,(2*pad_size+1).*ysmax,n_tot);

%Interpolation de l'OPD due à S
opd_s = interp2(xs,ys,opd,xs_inter,ys_inter,'cubic');
figure(6);mesh(linspace(xsmin,xsmax,np),linspace(ysmin,ysmax,np),opd_s-mean(mean(opd_s)));
delta_opd_s = max(max(opd_s))-min(min(opd_s))

%Ajout des OPDs en phase à la pupille
pupille_opd = pupille.*exp(2*pi*1i*(opd_s+opd_t)/lambda);
%Pad ajoute de la résolution, change l'échelle au détecteur.
%Cast en single pour sauver de la mémoire
pupille_pad = padarray(cast(pupille_opd,'single'), pad_vect);
%figure(4);imagesc(x_pupille,y_pupille,angle(pupille_pad));colormap(gray);

%Propagation de la pupille
psf = fftshift(fft2(pupille_pad));

%Normalisation de la psf
psf = psf./(sum(sum(abs(pupille_pad))));

%Échelle de la PSF
x_echelle = ((lambda*f_number))*linspace(-np/2,np/2,n_tot);
y_echelle = ((lambda*f_number))*linspace(-np/2,np/2,n_tot);
figure(5);imagesc(x_echelle, y_echelle,abs(psf));

%Position théorique du centre de la psf
th_pos_x = (g-1+z)*x_psf
th_pos_y = (g-1+z)*y_psf
if th_pos_x > max(x_echelle)
    warning('La PSF est hors limite en x')
elseif th_pos_y > max(y_echelle)
    warning('La PSF est hors limite en y')
end