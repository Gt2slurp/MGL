%% Création du masque d'OPD

n = 10000;
x = linspace(-0.2,0.2,n);
u = zeros(1,n);
D = zeros(1,n);
D = [linspace(0,0,n/4) linspace(0, 1, n/8) linspace(1, 1, n/8) linspace(1, 1, n/8) linspace(1, 0, n/8) linspace(0,0,n/4)];
z = 0.2;

[ thetaD ] = D2opd( x, D, z );

xs = x - z*(x-u);

rdg = diff(D)*n;

figure(1);plot(xs,thetaD)
figure(2);plot(x,D)
figure(3);plot(xs,cumsum(tan(thetaD))/n);
%figure(4);plot(rdg);

%%

 xm  = deviation_rayon( x,u,z,thetaD );
 
 figure(5);plot(x,xm,x,x)