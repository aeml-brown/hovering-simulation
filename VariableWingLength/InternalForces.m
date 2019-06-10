function F_intrnl = InternalForces(t, xm, param)


intPM = 'pchip';
ddqx = interp1(param.t,param.ddqx,t,intPM);
ddqy = interp1(param.t,param.ddqy,t,intPM);
ddqz = interp1(param.t,param.ddqz,t,intPM);
ddwl = interp1(param.t,param.ddwl,t,intPM);

D_mtx = Bat_MinimalHover_4DoA_D(t, xm, param );
Cdq_vect = Bat_MinimalHover_4DoA_C(t, xm, param );
G_vect = Bat_MinimalHover_4DoA_G(t, xm, param );
[Force, Moment] = AeroForce(t, xm, param);
f = [Force(2:3); Moment(1)];
B_vect = -(Cdq_vect + G_vect - f);

ddq1 = D_mtx\(B_vect);
ddq2 = [ddqx; ddqy; ddqz; ddwl];
ddq = [ddq1;ddq2];


Dt_mtx = Bat_MinimalHover_4DoA_Dt(t, xm, param );
Cdqt_vect = Bat_MinimalHover_4DoA_Ct(t, xm, param );
Gt_vect = Bat_MinimalHover_4DoA_Gt(t, xm, param );

f_aero_Intrnl = AeroForce_VrtlWrk_Intrnl(t, xm, param);

F_aerodyn = [f;f_aero_Intrnl];
F_intrnl = (Dt_mtx*ddq + Cdqt_vect + Gt_vect - F_aerodyn);
F_intrnl(4:7) = 0.5 * F_intrnl(4:7);

end


