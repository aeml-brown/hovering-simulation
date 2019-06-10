function Cdq_mtx = Bat_MinimalHover_4DoA_C(t, xm, param )

Cdq_mtx=zeros(length(xm)/2-4,1);
g=param.g;
Mb=param.Mb;
mw=param.mw;
b=param.b;
Ibx=param.Ibx;
ddqx = interp1(param.t,param.ddqx,t);
ddqy = interp1(param.t,param.ddqy,t);
ddqz = interp1(param.t,param.ddqz,t);
ddwl = interp1(param.t,param.ddwl,t);
y       = xm(1);
z       = xm(2);
phi     = xm(3);
qx      = xm(4);
qy      = xm(5);
qz      = xm(6);
wl      = xm(7);
dy       = xm(8);
dz       = xm(9);
dphi     = xm(10);
dqx      = xm(11);
dqy      = xm(12);
dqz      = xm(13);
dwl      = xm(14);
Cdq_mtx(1,1)=-mw*(dphi^2*wl*sin(phi)*sin(qy) + dqy^2*wl*sin(phi)*sin(qy) - 2*dphi*dwl*cos(phi)*sin(qy) - 2*dqy*dwl*cos(qy)*sin(phi) + dphi^2*wl*cos(phi)*cos(qy)*sin(qz) + dqy^2*wl*cos(phi)*cos(qy)*sin(qz) + dqz^2*wl*cos(phi)*cos(qy)*sin(qz) - 2*dphi*dqy*wl*cos(phi)*cos(qy) - 2*dqz*dwl*cos(phi)*cos(qy)*cos(qz) + 2*dphi*dwl*cos(qy)*sin(phi)*sin(qz) + 2*dqy*dwl*cos(phi)*sin(qy)*sin(qz) + 2*dphi*dqz*wl*cos(qy)*cos(qz)*sin(phi) + 2*dqy*dqz*wl*cos(phi)*cos(qz)*sin(qy) - 2*dphi*dqy*wl*sin(phi)*sin(qy)*sin(qz));
Cdq_mtx(2,1)=mw*(dphi^2*wl*cos(phi)*sin(qy) + dqy^2*wl*cos(phi)*sin(qy) - 2*dqy*dwl*cos(phi)*cos(qy) + 2*dphi*dwl*sin(phi)*sin(qy) - dphi^2*wl*cos(qy)*sin(phi)*sin(qz) - dqy^2*wl*cos(qy)*sin(phi)*sin(qz) - dqz^2*wl*cos(qy)*sin(phi)*sin(qz) + 2*dphi*dqy*wl*cos(qy)*sin(phi) + 2*dphi*dwl*cos(phi)*cos(qy)*sin(qz) + 2*dqz*dwl*cos(qy)*cos(qz)*sin(phi) - 2*dqy*dwl*sin(phi)*sin(qy)*sin(qz) + 2*dphi*dqz*wl*cos(phi)*cos(qy)*cos(qz) - 2*dphi*dqy*wl*cos(phi)*sin(qy)*sin(qz) - 2*dqy*dqz*wl*cos(qz)*sin(phi)*sin(qy));
Cdq_mtx(3,1)=(4*dphi*dwl*mw*wl)/3 - (4*dqy*dqz*mw*wl^2*cos(qz))/3 + (b^2*dphi*dqx*mw*sin(2*qx))/6 + (b^2*dphi*dqz*mw*sin(2*qz))/6 - (4*dqy*dwl*mw*wl*sin(qz))/3 - (2*dqz^2*mw*wl^2*cos(qy)*sin(qy)*sin(qz))/3 - (b^2*dqx*dqz*mw*cos(qy)*sin(qz))/3 - (b^2*dqy*dqz*mw*cos(qy)^2*cos(qz))/3 + (4*dqy*dqz*mw*wl^2*cos(qy)^2*cos(qz))/3 - (4*dphi*dwl*mw*wl*cos(qy)^2*cos(qz)^2)/3 + (b^2*dqz^2*mw*cos(qy)*sin(qy)*sin(qz))/6 - (b^2*dqz^2*mw*cos(qx)^2*cos(qy)*sin(qy)*sin(qz))/6 - (2*b^2*dphi*dqx*mw*cos(qx)*cos(qz)^2*sin(qx))/3 - (b^2*dphi*dqy*mw*cos(qy)*cos(qz)^2*sin(qy))/3 - (2*b^2*dphi*dqz*mw*cos(qx)^2*cos(qz)*sin(qz))/3 - (b^2*dqx*dqy*mw*cos(qx)^2*cos(qz)*sin(qy))/3 + (b^2*dqx*dqz*mw*cos(qx)^2*cos(qy)*sin(qz))/3 - (b^2*dphi*dqz*mw*cos(qy)^2*cos(qz)*sin(qz))/3 + (4*dphi*dqy*mw*wl^2*cos(qy)*cos(qz)^2*sin(qy))/3 + (4*dphi*dqz*mw*wl^2*cos(qy)^2*cos(qz)*sin(qz))/3 + (b^2*dqy*dqz*mw*cos(qx)^2*cos(qy)^2*cos(qz))/3 + (4*dqz*dwl*mw*wl*cos(qy)*cos(qz)*sin(qy))/3 - (b^2*dqy^2*mw*cos(qx)*cos(qy)*cos(qz)*sin(qx))/6 + (b^2*dqz^2*mw*cos(qx)*cos(qy)*cos(qz)*sin(qx))/6 - (b^2*dphi*dqz*mw*cos(qx)*sin(qx)*sin(qy))/3 - (b^2*dqx*dqy*mw*cos(qx)*sin(qx)*sin(qz))/3 - (b^2*dphi*dqx*mw*cos(qz)*sin(qy)*sin(qz))/3 + (2*b^2*dphi*dqz*mw*cos(qx)*cos(qz)^2*sin(qx)*sin(qy))/3 + (2*b^2*dphi*dqx*mw*cos(qx)^2*cos(qz)*sin(qy)*sin(qz))/3 + (b^2*dphi*dqx*mw*cos(qx)*cos(qy)^2*cos(qz)^2*sin(qx))/3 + (b^2*dphi*dqy*mw*cos(qx)^2*cos(qy)*cos(qz)^2*sin(qy))/3 + (b^2*dphi*dqz*mw*cos(qx)^2*cos(qy)^2*cos(qz)*sin(qz))/3 + (b^2*dphi*dqy*mw*cos(qx)*cos(qy)*cos(qz)*sin(qx)*sin(qz))/3 - (b^2*dqx*dqz*mw*cos(qx)*cos(qy)*cos(qz)*sin(qx)*sin(qy))/3;
end

