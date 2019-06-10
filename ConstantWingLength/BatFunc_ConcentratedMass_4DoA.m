function ydot = BatFunc_ConcentratedMass_4DoA(t, xm, ModelPropList, Data)

param = ModelProp(ModelPropList, Data);
ydot=zeros(size(xm));
n_DoF = length(xm)/2;
D_mtx = Bat_CoM_4DoA_D(t, xm, param );
C_mtx = Bat_CoM_4DoA_C(t, xm, param );
G_vect = Bat_CoM_4DoA_G(t, xm, param );
dq = xm(n_DoF+1:2*n_DoF);
[Force, Moment] = AeroForce(t, xm, param);
f = [Force; Moment];
B_vect = -(C_mtx * dq + G_vect - f(2:3));
ydot(1:n_DoF)=xm(n_DoF+1:2*n_DoF);
ydot(n_DoF+1:2*n_DoF)= D_mtx\(B_vect);

end


