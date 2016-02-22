function [ radius, coefficients ] = q_type_fit( sag, r, M )
%Q_TYPE_FIT Summary of this function goes here
%   Fit d'un profil de surface en utilisant asph�re Qbfs

%r de 0 � r_max

%Sag = 0 � r = 0
sag = sag - sag(1);


%Determiner le rayon
radius = calc_radius(r(end),sag(end));

%Enlever la partie radiale
sag_fit = sag - (radius.*r.^2)./(1+sqrt(1-(radius.^2).*(r.^2)));

%r normalis� de 0 � 1
r_norm = r./r(end);

%Construction des Qbfs
fun = fun_constr(M);

%Fit
xdata = r_norm;
ydata = sag_fit;
%Valeurs initiales des coefficients nulles
x0 = zeros(M,1);
coefficients = lsqcurvefit(fun,x0,xdata,ydata);

end

