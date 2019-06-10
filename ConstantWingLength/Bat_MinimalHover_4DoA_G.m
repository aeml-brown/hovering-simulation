function G_mtx = Bat_MinimalHover_4DoA_G(t, xm, param )

G_mtx=zeros(length(xm)/2-4,1);
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
G_mtx(1,1)=ddwl*mw*(sin(phi)*sin(qy) + cos(phi)*cos(qy)*sin(qz)) + ddqy*mw*wl*(cos(qy)*sin(phi) - cos(phi)*sin(qy)*sin(qz)) + ddqz*mw*wl*cos(phi)*cos(qy)*cos(qz);
G_mtx(2,1)=g*(Mb + 2*mw) - ddwl*(mw*cos(phi)*sin(qy) - mw*cos(qy)*sin(phi)*sin(qz)) - ddqy*mw*wl*(cos(phi)*cos(qy) + sin(phi)*sin(qy)*sin(qz)) + ddqz*mw*wl*cos(qy)*cos(qz)*sin(phi);
G_mtx(3,1)=g*mw*wl*(sin(phi)*sin(qy) + cos(phi)*cos(qy)*sin(qz)) - (ddqy*mw*(b^2*sin(qz) + 4*wl^2*sin(qz) - b^2*cos(qx)^2*sin(qz) + b^2*cos(qx)*cos(qz)*sin(qx)*sin(qy)))/6 + (ddqz*mw*cos(qy)*(4*wl^2*cos(qz)*sin(qy) - b^2*cos(qz)*sin(qy) + b^2*cos(qx)^2*cos(qz)*sin(qy) + b^2*cos(qx)*sin(qx)*sin(qz)))/6 + (b^2*ddqx*mw*cos(qy)*cos(qz))/6;
end

