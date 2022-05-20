function D=FitD(u_ex,tolerance,Dinit,r0,t,n,ur0)
%This function disigned for FRAP data analisys
%It fits solutions of the difusion equations in polar coordinates to experimental
%intensity profiles (u_ex) by fitting diffusion coefficient (D)
%u_ex - experimental intensity profiles (should be at least two)
%tolerance - //5e-004
%Dinit - initial gues of diffusion coef. // Dnbd-pe ~ 2e-12 m^2/s
%r0 - radius of the area under consideration // 205e-6 m 
%t - array of time points at whith pictures were made (t(1)=0)
%n - number of terms of the row of the solution // ~50 was OK
%ur0 - boundary condition at the point r0 // ur0=1 for normalized intensity
% D=FitD(u_ex,5e-004,5e-12,205e-6,[0 34*60 65*60],50,1);
D=Dinit;
D1=0;
u0=u_ex(1,:);

du0=0;
    for i=2:length(t)
        u=PolarDifSolv(u0,D,r0,t(i),n,ur0);
        du0=du0+sum((u-u_ex(i,:)).^2)/length(u);
    end
du0=du0/length(t);

if du0>tolerance
    D=(D-D1)*0.9;
    a=1;
    while a==1
        du=0;
        disp(D)
        for i=1:length(t)
            u=PolarDifSolv(u0,D,r0,t(i),n,ur0);
            du=du+sum((u-u_ex(i,:)).^2)/length(u);
        end
        du=du/length(t);
        if du<tolerance
            a=0;
            break;
        else
            if du>du0
                D1=D;
                D=D*1.05;
            else
                D=(D+D1)*0.9;
                du0=du;
            end
        end
    end
end