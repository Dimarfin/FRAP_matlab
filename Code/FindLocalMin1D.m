function [mins,index]=FindLocalMin1D(a,n)
%This function finds local minima of a vector "a"
%n - number of points before and after the curent point to compere with the current point when searching a minimun
%the noisear a the bigger should be n 
mins=[];
index=[];
	for i=n+1:length(a)-n
		s=0;
		r=0;
		for j=i-n:i+n
			if a(j)>=a(i)
				s=s+1;
			end
			if a(j)==a(i)
				r=r+1;
			end
	%from old version: %if (a(i)>a(i-2))&(a(i)>a(i-1))&(a(i)>=a(i+1))&(a(i)>a(i+2))
			if (s==2*n+1)&(r<2*n+1)
				mins=[mins,a(i)];
				index=[index,i];
			end
		end
	end	