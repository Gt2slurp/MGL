function [ fun ] = fun_constr( M )
%FUN_CONSTR Summary of this function goes here
%   Detailed explanation goes here

%Matrice des coefficients des polynômes de fun
c = zeros(M);
c(1,1) = 1;
c(2,1) = 13./sqrt(19);
c(2,2) = -16./sqrt(19);

P = zeros(M);
P(1,1) = 2;
P(2,1) = 6;
P(2,2) = -8;

for k = 3:M
    temp = P(k-1,:);
    temp = circshift(temp,[0,1]);
    temp(1) = 0;
    P(k,:) = 2*P(k-1,:) - 4.*temp - P(k-2,:);
    
    c(k,:) = c(k-1,:) + c(k-2,:) + P(k,:);
    
end


fun = c;
%Fonction unitaire de base d'ordre 0
% fun = @(x) c(1,1);

%Fonction de poid
% W = @(x) sqrt(x(1-x));
% 
% for j = 1:(M+1)    
%     %Construire fun{j}
%     for k = 1:j
%     fun{j}  = @(x) fun{j}(x) + c(j,k)*x.^k;
%     end
% end

end

