function [D,dD,u_ca]=FitD(u_ex,Dinit,scale,t,n)
%This function disigned for FRAP data analisys
%It fits solutions of the difusion equations in polar coordinates to experimental
%intensity profiles (u_ex) by searching for sutable diffusion coefficient (D)
%u_ex - experimental intensity profiles. It is extracted from images by ReadFrapData
%Dinit - initial gues of diffusion coef. // Dnbd-pe in popc ~ 2e-12 m^2/s
%scale - meters/(one pixel)
%t - array of time points at whith pictures were made (t(1)=0)
%n - number of terms of the row of the solution // ~50 was OK
%dD - error of D
%u_ca - calculated intensity profiles
%[D,dD]=FitD(u_ex,5e-12,0.4e-6,t,50);
D=Dinit;
u0=u_ex(1,:);
r0=length(u0)*scale;%r0 - radius of the area under consideration
ur0=mean(u_ex(1,length(u_ex)-20:length(u_ex)));%ur0 - boundary condition at the point r0 
Dnum=11;
mindu1=1;
k=0.1;
disp('Fitting D');
while 1
	for i=1:Dnum
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
	[mindu2,minj]=min(du)
	D=Drange(minj)
	if (minj~=1)&&(minj~=length(Drange))
		k=k/1.5;
	else
		k=k;
	end
	if abs(mindu1-mindu2)<0.005*mindu2
		disp('The acuracity of 1% has been archived. Process stoped.')
		break;
	end
	mindu1=mindu2;
end
dD=k*D;
u_ca=[];
t(1)=0.01*t(2);
for i=1:length(t)
	u_ca=[u_ca;PolarDifSolv(u0,D,r0,t(i),n,ur0)];
end