function u=LinDifSolv(u0,D,L,t,n,uL0,uL1)
%This function solves the Dirichlet problem for the diffusion equation for one dimentional linear case
%u0 - initial condition (a vertor)
%D - diffusion coeffitient
%L0 - Length of the area under consideration
%t - time (size = 1x1)
%n - number of terms of the row of the solution // ~50 was OK
%ur0 - boundary condition - u(r0)=const
N=length(u0);
dx=L/N;
x=dx:dx:L;
u=zeros(1,N);
fi=u0-uL0-(x/L)*(uL1-uL0);
for m=1:n
    f=fi.*sin(pi*m*x/L);
    Cm=(2/L)*trapz(x,f);
    u=u+Cm*sin(pi*m*x/L)*exp(-D*(pi*m/L)^2*t);
end
u=u+uL0+(x/L)*(uL1-uL0);