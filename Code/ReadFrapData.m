function [u_ex,t]=ReadFrapData(DirPath,X,fi1,fi2)
%This function reads fluorescent recovery images placed in DirPath and extract intensity profiles u_ex as well as time when the image was  
%made if it is specefied in filenames like this: *timehh-mm-ss*.*

u_ex=[];
d=dir(DirPath);
i=0;
t=1;
ref_on=0;
for j=1:length(d)
    s=d(j).name;
    if isempty(strfind(s,'reference'))~=1
        s_ref=s; 
        ref_on=1;
    end
end
if ref_on==1
    Iref=double(imread([DirPath,'/',s_ref]));
else
    Iref=0;
end
for j=1:length(d)
    	    s=d(j).name;
    	    if isempty(strfind(s,'time'))~=1%we ignore everything exept files containing 'time' in their names 
               i=i+1;
                %finding and extracting time
                k = strfind(s, 'time');
                if ~isempty(k)
                    hh(i)=str2num(s(k+4:k+5));
                    mm(i)=str2num(s(k+7:k+8));
                    ss(i)=str2num(s(k+10:k+11));
                else
                 t=0;
                end
               %
                disp(['reading ',s]);
                I1=double(imread([DirPath,'/',s]));
                I1=I1-Iref; 
               if i==1%finding centre only for the first image
    %                 BaseLine=min(min(I1));
    %                 I2=I1+abs(BaseLine);
                    if X==0
                        disp(['finding centre in  ',s]);
                        [x1,x2]=FindSpotCentre(I1,1)
                    else
                        x1=X(1);
                        x2=X(2);
                    end
               end
    %           I1=I1+abs(BaseLine);
              disp(['calculating radial mean of ',s]);                       
               Ir=RadialMean(I1,x1,x2,fi1,fi2,32);
               mIr=mean(Ir,2);
               %plot(mIr);pause(1)
               u_ex=[u_ex,mIr];    
 	     end
end
u_ex=u_ex';
u_ex1=u_ex;
len=length(u_ex(1,:));
for i=1:length(u_ex(:,1))
    u_ex1(i,:)=(u_ex(i,:)-mean(u_ex(i,round(0.9*len):len))+(mean(u_ex(1,round(0.9*len):len))-mean(u_ex(1,1:5))))...
                /abs(mean(u_ex(1,round(0.9*len):len))-mean(u_ex(1,1:5)));
end
u_ex=u_ex1;
%size(u_ex)
if t~=0
	t=FrapTimeSteps(hh,mm,ss);
end