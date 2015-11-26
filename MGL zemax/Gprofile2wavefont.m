function [ W, s ] = Gprofile2wavefont( G, z, l, s_max,n)
%GPROFILE2WAVEFONT Summary of this function goes here
%   Detailed explanation goes here

%Prend le vecteur de grandissement G et calcule la phase au plan S et la
%distortion

s = linspace(0,s_max.*sqrt(2),n);

%G est une fonction

G_eval = G(s./(1-z./l));
a = 1./(z.*(1-z./l));

W = a.*cumtrapz(s.*(G_eval-1))./n;

%Normalisation à zéro sur le bord
W = W-W(end);
end

