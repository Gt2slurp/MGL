function [ array ] = circle_array( n )
%CIRCLE_ARRAY Summary of this function goes here
%   Création d'une matrice contenant un cercle de hauteur unitaire en son
%   centre.


vect = linspace(-1,1,n);
[array_x,array_y] = ndgrid(vect);

array = (sqrt(array_x.^2+array_y.^2) <= 1);
array = cast(array,'double');
end
