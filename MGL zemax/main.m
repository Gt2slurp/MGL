% Création d'un grid sag adapté à l'exportation dans zemax.
clear
%Configuration des paramètres
run config.m

%Création des points sur l'image
[s(1).img,s(2).img] = meshgrid(linspace(-hfov,hfov,n),linspace(-hfov,hfov,n));

%Création de la carte de distortion
switch type_dist
    case 'quadratique'
        [s(1).dist,s(2).dist, s(1).delta,s(2).delta] = gen_dist( n,cx,cy,r1,r2,g1,g2,s(1).img,s(2).img);
    case 'gaussien'
        [s(1).dist,s(2).dist, s(1).delta,s(2).delta] = gen_dist_gauss( n,cx,cy,r1,r2,g1,g2,s(1).img,s(2).img);
end

s(1).pupille = 0;
s(2).pupille = 0;
s = complete_geometrie(s,z,f);
hfov_s = max(max(s(1).s));

%Calcul de la forme de l'OPD total de s
[ s ] = deviation( s,z );
% switch type_dist
%     case 'quadratique'
%         [ opd ] = masque_opd( s,n);
%     case 'gaussien'
%         [ opd ] = masque_opd_gauss( s,g1,g2,r1,r2);
% end

[ opd ] = masque_opd( s,n);

figure(1);mesh(linspace(-hfov,hfov,n),linspace(-hfov,hfov,n),opd);
xlabel('x');ylabel('y'),zlabel('OPD');
title('OPD à la surface S')

n1 = 1; %air
n2 = 1.53; %~BK7
path = 'C:\Users\Alex Côté\Documents\Zemax\Objects\Grid Files\sag_test.dat';
zemax_sag_dat( path, opd , hfov_s, hfov_s, n1, n2);

rad2deg(atan(hfov_s/f));