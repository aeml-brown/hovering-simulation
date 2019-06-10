function D_mtx = Bat_MinimalHover_4DoA_D(t, xm, param )

D_mtx=zeros(length(xm)/2-4,length(xm)/2-4);
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
D_mtx(1,1)=Mb + 2*mw;
D_mtx(1,2)=0;
D_mtx(1,3)=mw*wl*(cos(phi)*sin(qy) - cos(qy)*sin(phi)*sin(qz));
D_mtx(2,1)=0;
D_mtx(2,2)=Mb + 2*mw;
D_mtx(2,3)=mw*wl*(sin(phi)*sin(qy) + cos(phi)*cos(qy)*sin(qz));
D_mtx(3,1)=mw*wl*(cos(phi)*sin(qy) - cos(qy)*sin(phi)*sin(qz));
D_mtx(3,2)=mw*wl*(sin(phi)*sin(qy) + cos(phi)*cos(qy)*sin(qz));
D_mtx(3,3)=Ibx + (mw*wl^2*(sin(phi)*sin(qy) + cos(phi)*cos(qy)*sin(qz))^2)/2 + (mw*wl^2*(cos(phi)*sin(qy) - cos(qy)*sin(phi)*sin(qz))^2)/2 + (mw*wl^2*(cos(qx)*sin(qz) - cos(qz)*sin(qx)*sin(qy))^2)/6 + (mw*(sin(qx)*sin(qz) + cos(qx)*cos(qz)*sin(qy))^2*(b^2 + wl^2))/6 + (b^2*mw*cos(qy)^2*cos(qz)^2)/6;
end

