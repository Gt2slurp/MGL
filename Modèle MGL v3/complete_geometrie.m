function [ ray_struct ] = complete_geometrie( ray_struct,z )
%COMPLETE_GEOMETRIE Summary of this function goes here
%   Detailed explanation goes here

%Si le champ img de la structure n'existe pas
if ~isfield(ray_struct,'img')
    ray_struct(1).img = (ray_struct(1).s - z.*ray_struct(1).pupille)./(1 - z);
    ray_struct(2).img = (ray_struct(2).s - z.*ray_struct(2).pupille)./(1 - z);
%Si le champ s de la structure n'existe pas
elseif ~isfield(ray_struct,'s')
    ray_struct(1).s = ray_struct(1).img - z.*(ray_struct(1).img-ray_struct(1).pupille);
    ray_struct(2).s = ray_struct(2).img - z.*(ray_struct(2).img-ray_struct(2).pupille);
end

end

