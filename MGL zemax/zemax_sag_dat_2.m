function [  ] = zemax_sag_dat_2( path, sag , taille_max_x, taille_max_y)
%ZEMAX_SAG_DAT Summary of this function goes here
%   Exportation d'un sag dans zemax. Les données sont en mm.

%Paramètre de la première ligne du fichier DAT
%indicate the units of the data: 0 for mm, 1 for cm, 2 for in, and 3 for meters
unitflag = num2str(0,'%u');
xdec = num2str(0,'%f');
ydec = num2str(0,'%f');

nx = num2str(size(sag,1),'%u');
ny = num2str(size(sag,2),'%u');
delx = num2str(taille_max_x./size(sag,1),'%f');
dely = num2str(taille_max_y./size(sag,2),'%f');

str_vect = [nx,' ',ny,' ',delx,' ',dely,' ',unitflag,' ',xdec,' ',ydec,'\n'];



%Écriture de la première ligne
%fprintf(FileID,str_vect);

%Paramètre pour chaque point
[dopddy,dopddx] = gradient(sag,taille_max_x./size(sag,1),taille_max_y./size(sag,2));
%Dérivé croisée

%dopddx = -dopddx; %Parce que sinon c'est pas du bon sens...
dopddy = -dopddy;
dopddxdy = gradient(dopddy,taille_max_x./size(sag,1));
%dopddxdy = -dopddxdy;

opd_ligne = reshape(sag,1,numel(sag));
dopddx_ligne = reshape(dopddx,1,numel(dopddx));
dopddy_ligne = reshape(dopddy,1,numel(dopddy));
dopddxdy_ligne = reshape(dopddxdy,1,numel(dopddxdy));

for k = 1:numel(opd_ligne)
    a = num2str(opd_ligne(k),'%e');
    b = num2str(dopddx_ligne(k),'%e');
    c = num2str(dopddy_ligne(k),'%e');
    d = num2str(dopddxdy_ligne(k),'%e');
    
    str_vect = [str_vect,a,' ',b,' ',c,' ',d,' ','0','\n'];
    
end
%Ouverture du ficher
FileID = fopen(path,'w');
%Écriture
fprintf(FileID,str_vect);
%Fermeture du fichier
fclose(FileID);



end

