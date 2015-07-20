function [ opd ] = opd_calc_v2( opd,ray_fan,z,n )
%OPD_CALC_V2 Summary of this function goes here
%   Detailed explanation goes here

opd.total = opd.tilt + opd.s;

%Décomposition en polynôme de Zernike
a = zernike_coeffs(opd.total, 15);
opd.zernike = a;

%Coefficent de tilt x et y
C_tilt_x = a(2);
C_tilt_y = a(3);

%Coefficient sans tilt
a_st = a;
a_st(1) = 0; %Élimination du piston
a_st(2) = 0;
a_st(3) = 0;

%Distance de meilleur foyer
opd.foyer = z + (a(4)/sqrt(3))/2;


%Reconstruction du front d'onde sans tilt
opd.st = zernike_reconstruction(a_st,n);

%Calcul de l'erreur RMS sans le tilt et le piston
opd.err_rms = sqrt(sum(sum(opd.st.^2))./n^2);

xsmax = max(max(ray_fan(1).s));
xsmin = min(min(ray_fan(1).s));
ysmax = max(max(ray_fan(2).s));
ysmin = min(min(ray_fan(2).s));

%Calcul des angles de déviation
opd.theta = atan(C_tilt_x./(0.5*(xsmax-xsmin)));
opd.phi = atan(C_tilt_y./(0.5*(ysmax-ysmin)));

%Calcul de la distance de déviation sur l'image
opd.delta_x = z.*C_tilt_x./(0.5*(xsmax-xsmin));
opd.delta_y = z.*C_tilt_y./(0.5*(ysmax-ysmin));


end

