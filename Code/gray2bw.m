function I1=gray2bw(I,threshold)
%Converts an image I to a black and white image I1 according to the specified threshold
I=double(I);
I1=I-threshold;
I1=sign(sign(I1)+1);
