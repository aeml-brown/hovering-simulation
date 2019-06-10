function ydot = BatFunc_MinimalHover_4DoA(t, xm, ModelPropList, Data)

param = ModelProp(ModelPropList, Data);


ydot=zeros(size(xm));
n_DoA = 4;
n_DoF = length(xm)/2 - n_DoA;
intPM = 'pchip';


for i = 4:7
    xm(i) = interp1(param.t,Data(:,i+2),t,intPM);
    xm(i+7) = interp1(param.t,Data(:,i+6),t,intPM); 
end


ddqx = interp1(param.t,param.ddqx,t,intPM);
ddqy = interp1(param.t,param.ddqy,t,intPM);
ddqz = interp1(param.t,param.ddqz,t,intPM);
ddwl = interp1(param.t,param.ddwl,t,intPM);
WAF = [ddqx;ddqy;ddqz;ddwl];
D_mtx = Bat_MinimalHover_4DoA_D(t, xm, param );
Cdq_vect = Bat_MinimalHover_4DoA_C(t, xm, param );
G_vect = Bat_MinimalHover_4DoA_G(t, xm, param );
[Force, Moment] = AeroForce(t, xm, param);
f = [Force(2:3); Moment(1)];
B_vect = -(Cdq_vect + G_vect - f);


ydot(1:n_DoF+n_DoA)=xm((n_DoF+n_DoA)+1:2*(n_DoF+n_DoA));

ydot(n_DoF+n_DoA+1:2*n_DoF+n_DoA)= D_mtx\(B_vect);

ydot(2*n_DoF+n_DoA+1:2*(n_DoF+n_DoA))= WAF;


end


