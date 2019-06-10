function [Force, Moment, CoP_R] = AeroForce_eval(t, xm, param)


% param = ModelProp;


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

intPM = 'pchip';

ddqy = interp1(param.t,param.ddqy,t,intPM);

ddqz = interp1(param.t,param.ddqz,t,intPM);

ddqx = interp1(param.t,param.ddqx,t,intPM);

ddwl = interp1(param.t,param.ddwl,t,intPM);


    
% velocity of the wing centroid:
dw_body = Rx(phi)*Ry(0)*[0;0;0] + Rx(phi)*[0;0;0] + [dphi;0;0];
dwrL = (Rx(qx)*Ry(qy)*Rz(qz))*dw_body + (Rx(qx)*Ry(qy))*[0;0;dqz] + Rx(qx)*[0;dqy;0] + [dqx;0;0];
% dwlL = (Rx(qxL)*Ry(q1L)*Rz(qzL))*dw_body + (Rx(qxL)*Ry(q1L))*[0;0;dqzL] + Rx(qxL)*[0;dq1L;0] + [dqxL;0;0];

% dw_body = Rx(0)*Ry(0)*[0;0;0] + Rx(0)*[0;0;0] + [0;0;0];
% dwrL = (Rx(qx)*Ry(qy)*Rz(qz))*dw_body + (Rx(qx)*Ry(qy))*[0;0;dqz] + Rx(qx)*[0;dqy;0] + [dqx;0;0];
% dwlL = (Rx(qxL)*Ry(q1L)*Rz(qzL))*dw_body + (Rx(qxL)*Ry(q1L))*[0;0;dqzL] + Rx(qxL)*[0;dq1L;0] + [dqxL;0;0];
% This velocity is in wing coordinates
% fprintf(RG,'vR = cross(dwr,[r1/2;0;0]);\n\n');
% fprintf(RG,'vL = cross(dwl,[l1/2;0;0]);\n\n');
% velocity vector of the CoM should be transformed 
% V should be calculated from the control point
Fe_R = [0;0;0];
Fe_L = [0;0;0];
Me_R = [0;0;0];
Me_L = [0;0;0];
CoP_R = [];
CoP_L = [];
Nstrip = 10;
dr = wl / Nstrip;
% dl = l1 / Nstrip;
for i = 1:Nstrip
    r = (i-1) * dr + dr / 2;
% Here vR is with respect to the beginning of the wing and wing coordinates
% vR1 is the velocity of the center of the strip in the local wing coordinates 
    RG2rw = Rx(qx)*Ry(qy)*Rz(qz)*Rx(phi)*Ry(0)*Rz(0);  % R_Global_2_right Wing
%     RG2lw = Rx(qxL)*Ry(q1L)*Rz(qzL)*Rx(phi)*Ry(th)*Rz(psi);  % R_Global_2_left Wing
    dwrG = transpose(RG2rw)*(dwrL);          % transfers the local angular velocity to global
%     dwlG = transpose(RG2lw)*(dwlL);         % transfers the local angular velocity to global
    vR = [0;dy;dz] + cross(dwrG,transpose(RG2rw)*[r;0;0]);  % vR in global coordinates
    vRL = (RG2rw)*vR;        % vR in right wing coordinates = vRL
    vRL = [0;vRL(2);vRL(3)];   % using only y and z components of local vRL
    vRG = transpose(RG2rw)*vRL;        % vRG is the vRL in global coordinates
%     if transpose(vRL)*vRL < 1e-5
%     alpha=0;
%     else
%     alpha = acos((abs(vRL(2)))/sqrt(dot(vRL,vRL)));
%     alpha = atan2(VRL(3),vRL(2));
%     end
    alpha = atan2(vRL(3),vRL(2));
    Cd = Cd_fn(alpha);
    Cl = Cl_fn(alpha);
    dF_D = -(1/2)*param.Rof*Cd*param.b*dr*sqrt(dot(vRG,vRG))*vRG;
    
%     LiftForce = (1/2)*param.Rof*Cl*param.b*dr*(dot(vRG,vRG));
%     dF_L = LiftForce*transpose(RG2rw)*[0;sign(vRL(2))*sin(alpha);-sign(vRL(3))*cos(alpha)];

    LiftForce = (1/2)*param.Rof*Cl*param.b*dr*sqrt(dot(vRG,vRG));
    dF_L = -transpose(RG2rw)*cross([LiftForce;0;0],vRL);
    
    dFe = dF_D + dF_L;
    Fe_R = Fe_R + dFe;  % All the forces are in global frame
    if abs(vRL(2))<0.01*abs(vRL(3))
        coeff1 = 0;
    else
        coeff1 = 1;
    end
    coeff1 = tanh(10*abs(alpha-pi/2)*180/pi);
    Me_R = Me_R + cross(transpose(RG2rw)*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);
    CoP_R = [CoP_R;[r sign(vRL(2))*param.b*1/4*coeff1 0]];
    
    Fe_L = [-Fe_R(1);Fe_R(2);Fe_R(3)];
    Me_L = [Me_R(1);-Me_R(2);-Me_R(3)];
end

Force_R = Fe_R;
Force_L = Fe_L;

Force = Force_R + Force_L;

Moment_R = Me_R;
Moment_L = Me_L;
Moment = Moment_R + Moment_L;

% The foces and moments are in the global coordinates. To be able to use them in the Lagrangian
% the moments should be transfered properly
% This formula finds the forces correspond to Euler angles, based on the formula in "Advanced Dynamics" Book
% p. 179 Eqs.3.254 
% In the folder it is shown that it is equivalent to the case when the forces are calculated through 
% calculating the partial derivative of the force location
psi = 0;
th = 0;
Moment = (transpose(Moment)*[0;0;1]*[0;0;1]+transpose(Moment)*(Rz(-psi)*[0;1;0])*[0;1;0]+transpose(Moment)*(Rz(-psi)*Ry(-th)*[1;0;0])*[1;0;0]);
end


function Cd = Cd_fn(alpha)
%     Cd = (1.135 - 1.05 * cos(2 * alpha));
    Cd = (1.88 - 1.70 * cos(2.0 * alpha));
%     Cd = (1.88 - 1.70 * cos(2.0 * alpha));
end

function Cl = Cl_fn(alpha)
%     Cl = (1.64 * sin(2 * alpha));
    Cl = (1.87 * sin(2.0 * alpha));
%     Cl = (0.245 + 1.63 * sin(2.0 * alpha));
    
end

function Rx = Rx(phi)
    Rx = [1,0,0;0,cos(phi),sin(phi);0,-sin(phi),cos(phi)];
end

function Ry = Ry(th)
    Ry = [cos(th),0,-sin(th);0,1,0;sin(th),0,cos(th)];
end

function Rz = Rz(psi)
    Rz = [cos(psi),sin(psi),0;-sin(psi),cos(psi),0;0,0,1];
end

