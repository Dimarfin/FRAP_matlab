function Ir=RadialMean(I,x1,x2,fi1,fi2,n)
%I - image to be analyzed
%x1,x2 - coordinates of the centre of the spot
%fi1,fi1 - angles in degrees to start and finish averaging
%n - number of profiles to average
sz=size(I);
a1=length(I(x2,x1:sz(2)));
a2=x1;
a3=length(I(x2:sz(1),x1));
a4=x2;
R=min([a1,a2,a3,a4])-10;
%n=8;
%dfi=2*pi/n;
dfi=(fi2-fi1)*pi/(180*n);
Ir=zeros(R,n);
b=zeros(R,1);
for i=1:n
	fi=fi1*pi/180+dfi*(i-1);
	%disp(fi*180/pi);
	for j=1:R
		xj=x1+round(j*cos(fi));
		yj=x2+round(j*sin(fi));
		b(j)=I(yj,xj);
	end
Ir(:,i)=b;
end	