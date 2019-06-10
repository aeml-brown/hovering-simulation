function ParameterWriting_MinimalModel_4DoA(FileNumber)

    RG = FileNumber;
    
    fprintf(RG,'g=param.g;\n');
    
    fprintf(RG,'Mb=param.Mb;\n');
    fprintf(RG,'mw=param.mw;\n');
    fprintf(RG,'b=param.b;\n');
    
    fprintf(RG,'Ibx=param.Ibx;\n');
    
%     fprintf(RG,'intPM = ''pchip'';\n\n');
%     fprintf(RG,'ddqx = interp1(param.t,param.ddqx,t,intPM);\n');
%     fprintf(RG,'ddqy = interp1(param.t,param.ddqy,t,intPM);\n');
%     fprintf(RG,'ddqz = interp1(param.t,param.ddqz,t,intPM);\n');
%     fprintf(RG,'ddwl = interp1(param.t,param.ddwl,t,intPM);\n');
    fprintf(RG,'ddqx = interp1(param.t,param.ddqx,t);\n');
    fprintf(RG,'ddqy = interp1(param.t,param.ddqy,t);\n');
    fprintf(RG,'ddqz = interp1(param.t,param.ddqz,t);\n');
    fprintf(RG,'ddwl = interp1(param.t,param.ddwl,t);\n');
    
    fprintf(RG,'y       = xm(1);\n');
    fprintf(RG,'z       = xm(2);\n');
    fprintf(RG,'phi     = xm(3);\n');
    fprintf(RG,'qx      = xm(4);\n');
    fprintf(RG,'qy      = xm(5);\n');
    fprintf(RG,'qz      = xm(6);\n');
    fprintf(RG,'wl      = xm(7);\n');
    
    fprintf(RG,'dy       = xm(8);\n');
    fprintf(RG,'dz       = xm(9);\n');
    fprintf(RG,'dphi     = xm(10);\n');
    fprintf(RG,'dqx      = xm(11);\n');
    fprintf(RG,'dqy      = xm(12);\n');
    fprintf(RG,'dqz      = xm(13);\n');
    fprintf(RG,'dwl      = xm(14);\n');
    
    
end