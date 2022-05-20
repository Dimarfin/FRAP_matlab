function [x1,x2]=FindSpotCentre(I,ShowResult)
%This function finds coordinates of a dark spot on bright background
I=double(I);	
%setting threshold inbetween min and mean value of intensity
Imin=min( Smooth1D(min(I)',round(0.03*length(I(1,:)))) )
Imean=mean( Smooth1D(mean(I)',round(0.03*length(I(1,:)))) )
threshold=Imin+(Imean-Imin)/2
%Making the image black and wtite
I1=gray2bw(I,threshold);
%
SI1=sum(I1);%
SI2=sum(I1');
nx1=round(0.03*length(SI1));
nx2=round(0.03*length(SI2));
sSI1=Smooth1D(SI1',nx1);   % figure(21);plot(diff(sSI1))
sSI2=Smooth1D(SI2',nx2);   % figure(31);plot(diff(sSI2))
%
% dsSI1=diff(sSI1);
% dsSI2=diff(sSI2);
% [minds1,iminds1]=min(dsSI1);
% [maxds1,imaxds1]=max(dsSI1);
% [minds2,iminds2]=min(dsSI2);
% [maxds2,imaxds2]=max(dsSI2);
% x1=round((iminds1+imaxds1)/2);
% x2=round((iminds2+imaxds2)/2);
[mins1,x1]=FindLocalMin1D(sSI1,nx1); %- old version
[mins2,x2]=FindLocalMin1D(sSI2,nx2); %- old version
if length(x1)>1
	[a,b]=min(mins1);
	x1=x1(b);
end
if length(x2)>1
	[a,b]=min(mins2);
	x2=x2(b);
end
if ShowResult
	figure(51);image(I1*128);hold on
	plot(x1,x2,'ko');hold off
end