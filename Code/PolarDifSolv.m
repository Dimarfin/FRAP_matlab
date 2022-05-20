function u=PolarDifSolv(u0,D,r0,t,n,ur0)
%This function solves the Dirichlet problem for the diffusion equation in polar coordinates
%u0 - initial condition (a vertor)
%D - diffusion coeffitient
%r0 - radius of the area under consideration
%t - time (size = 1x1)
%n - number of terms of the row of the solution // ~50 was OK
%ur0 - boundary condition - u(r0)=const
N=length(u0);
dr=r0/N;
r=dr:dr:r0;
u=zeros(1,N);
u0=u0-ur0;
for m=1:n
    mu0m=BesselJzero(m);
    f=u0.*r.*besselj(0,mu0m*r/r0);
    Cm=2*trapz(r,f)/(r0*besselj(1,mu0m))^2;
    u=u+Cm*besselj(0,mu0m*r/r0)*exp(-D*(mu0m/r0)^2*t);
end
u=ur0+u;