function [D,dD]=FitD01(u_ex,tolerance,Dinit,r0,t,n,ur0)
%This function disigned for FRAP data analisys
%It fits solutions of the difusion equations in polar coordinates to experimental
%intensity profiles (u_ex) by fitting diffusion coefficient (D)
%u_ex - experimental intensity profiles (should be at least two)
%tolerance - //0.07 could be OK
%Dinit - initial gues of diffusion coef. // Dnbd-pe ~ 2e-12 m^2/s
%r0 - radius of the area under consideration // 205e-6 m 
%t - array of time points at whith pictures were made (t(1)=0)
%n - number of terms of the row of the solution // ~50 was OK
%ur0 - boundary condition at the point r0 // ur0=1 for normalized intensity
% D=FitD(u_ex,5e-004,5e-12,205e-6,[0 34*60 65*60],50,1);
D=Dinit;
u0=u_ex(1,:);
n=11;
mindu=2*tolerance;
k=0.1;
while mindu>tolerance
	for i=1:n
		Drange(i)=D+k*D*(5-(i-1));
	end
	du=zeros(1,length(Drange));
	for j=1:length(Drange)
		for i=1:length(t)
        			u=PolarDifSolv(u0,Drange(j),r0,t(i),n,ur0);
	        		du(j)=du(j)+sum((u-u_ex(i,:)).^2)/length(u);
		end
		du(j)=du(j)./length(t);
	end
	[mindu,minj]=min(du)
	D=Drange(minj)
	if (minj~=1)&&(minj~=length(Drange))
		k=k/1.5;
	else
		k=k;
	end
end
dD=k*D;