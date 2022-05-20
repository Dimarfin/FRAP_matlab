function SmoothedA=Smooth1D(A,n)
%Smoothing columns in matrix A
%n - number of points both sids of every point to average
SmoothedA=A;
for i=1:length(A(1,:))
    for j=1:length(A(:,1))
    	if j<n+1
    		SmoothedA(j,i)=mean(A(1:j+n,i));
    	elseif j>length(A(:,1))-n
    		SmoothedA(j,i)=mean(A(j-n:length(A(:,1)),i));
    	else
    	        	SmoothedA(j,i)=mean(A(j-n:j+n,i));
    	end
    end
end