function theta_N = solve_snell(theta_1, theta_2, n1, n2)

% Calcul de l'angle de la normale à la surface 1 en fonction de l'angle
% d'entrèe et de sortie.

theta_N = zeros(1,numel(theta_1));

%Calcul de theta_N par convergence d'une fonction transcendante.
for k = 1:numel(theta_1)
    loi_snell = @(theta_N) n1.*sin(theta_1(k)-theta_N) - n2.*sin(theta_2(k)-theta_N);
    theta_N(k) = fzero(loi_snell,0);
end

%Élimination des discontinuités
grad = gradient(theta_N);
tol = pi/4;
flagg = 1;
for k = 1:numel(theta_N)
    if grad(k) > tol
        theta_N(k+1:end) = theta_N(k+1:end) - pi*flagg;
        flagg = 0;
    elseif grad(k) < -tol 
        theta_N(k+1:end) = theta_N(k+1:end) + pi*flagg;
        flagg = 0;
    else
        flagg = 1;
    end
end
end
