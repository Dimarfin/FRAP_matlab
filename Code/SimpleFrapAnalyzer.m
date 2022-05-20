function [D,dD,u_ex,u_ca,t]=SimpleFrapAnalyzer(DirPath,Dinit,PixelSize,X,fi1,fi2,n)
% DirPath='U:\Matlab\Simple FRAP analyzer\FRAPimages\Simulation\simulation';
% Dinit=0.5e-12;
% PixelSize=0.1852/2;
% n=50;
%X=[x1,x2] - coordinates of the centre of the spot. If X=0 x1,x2 will be found automatically.
[u_ex,t]=ReadFrapData(DirPath,X,fi1,fi2);
[D,dD,u_ca]=FitD(u_ex,Dinit,PixelSize,t,n);
x=PixelSize*[1:length(u_ex(1,:))];
h11=figure(11);hold on;
grid on
for i=1:length(u_ex(:,1))
	plot(x,u_ex(i,:));plot(x,u_ca(i,:),'r')
end
xlabel('Distance, m');
ylabel('Normalazed intensity');
title(num2str(DirPath));
text(x(1),-0.1,['t= ',num2str(t),' s']);
text(x(1),1.1,['D= ',num2str(D*1e12),' +-',num2str(dD*1e12),' um^2/s']);
