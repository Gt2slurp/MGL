lambda = 500E-9;
%Nombre de rayon simulé par axe
n = 251;
%Point à analyser sur l'image
x = 0;
y = 0.1;
%Distance de la surface S. 1: pupille, 0: plan image
z = 0.05;
%F number du faisceau
f_number = 10;
%Centre du grandissement
cx = 0;
cy = 0;
%Grandissement
g1 = 1;
g2 = 1;
%Rayon de la surface à grandir. Le rayon final sera r1*g.
r1 = 0.1;
%Rayon de la zone de redressement
r2 = 0.3;

%Courbe de redressement du centre à 1
r_red = linspace(r1,r2,250);
figure(1);plot(r_red,(g1-g2).*((r_red-r2).^2./(r1-r2).^2) + g2);

%Calcul de la portion de S intercepté
umax = 1/f_number;
vmax = 1/f_number;
[ xsmax, ysmax, ~, ~] = geometrie( x,y,umax,vmax,z );
[ xsmin, ysmin, ~, ~] = geometrie( x,y,-umax,-vmax,z );
%[xs_inter,ys_inter] = meshgrid(linspace(xsmin,xsmax,np),linspace(ysmin,ysmax,np));

%Profil de distortion désiré
%P: Point d'arrivée du rayon avec grandissement
%mat: Rayon original
%delta: Différence
[ Px, Py , delta_x, delta_y, x_mat, y_mat] = gen_dist(n,cx,cy,r1,r2,g1,g2,xsmax,ysmax,xsmin,ysmin);
figure(2);scatter(reshape(Px,[numel(Px),1]),reshape(Py,[numel(Py),1]),'.');

%Intersection avec le plan S
[ xs, ys, theta_S, phy_S ] = geometrie( x_mat,y_mat,0,0,z );

%Calcul des angles de déviation par S
[ theta_D,phi_D ] = deviation( x,y,z,delta_x,delta_y );

%Masque d'OPD
[ opd_s ] = masque_opd( theta_D,phi_D,n,xsmax,ysmax);
figure(3);mesh(xs,ys,opd_s);

%Calcul de l'OPD due au tilt
[ opd_t ] = opd_tilt(x,y,z,f_number,n);
figure(4);mesh(xs,ys,opd_t);

%OPD total
opd_total = opd_s + opd_t;

%Retrait de la composante tilt de l'OPD total
[ opd_sans_tilt, deviation_x, deviation_y, theta_eff, phi_eff ] = calcul_tilt( opd_total,xsmax,ysmax,xsmin,ysmin,z,n );
figure(5);mesh(xs,ys,opd_sans_tilt);

%Position calculé
[ xs_rc, ys_rc, theta_rc,phi_rc ] = geometrie( x,y,0,0,z );
pos_calc_x = xs_rc + deviation_x;
pos_calc_y = ys_rc + deviation_y;
%pos_calc_x = deviation_x;
%pos_calc_y = deviation_y;

%Position théorique
% pos_th_x = xs_rc +(g1-g2+z)*x;
% pos_th_y = ys_rc +(g1-g2+z)*y;
% pos_th_x = (g1-g2+z)*x;
% pos_th_y = (g1-g2+z)*y;
pos_th_x = x+z*theta_D((n-1)/2+1,(n-1)/2+1);
pos_th_y = y+z*phi_D((n-1)/2+1,(n-1)/2+1);

%Erreur
pos_err_x = pos_th_x - pos_calc_x;
pos_err_y = pos_th_y - pos_calc_y;