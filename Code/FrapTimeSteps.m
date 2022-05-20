function t=FrapTimeSteps(hh,mm,ss)
n=length(hh);
t=zeros(1,n);
for i=2:n
	t(i)=(hh(i)-hh(1))*3600+(mm(i)-mm(1))*60+(ss(i)-ss(1));
end