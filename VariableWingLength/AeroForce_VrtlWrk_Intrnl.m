function [F_int] = AeroForce_VrtlWrk_Intrnl(t, xm, param)
% This function calculates the aerodynamic forces for the main body via virtual work method

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

dRx = [0 0 0;0 0 1;0 -1 0];
dRy = [0 0 -1;0 0 0;1 0 0];
dRz = [0 1 0;-1 0 0;0 0 0];

% velocity of the wing centroid:
dw_body = Rx(phi)*Ry(0)*[0;0;0] + Rx(phi)*[0;0;0] + [dphi;0;0];
dwrL = (Rx(qx)*Ry(qy)*Rz(qz))*dw_body + (Rx(qx)*Ry(qy))*[0;0;dqz] + Rx(qx)*[0;dqy;0] + [dqx;0;0];
% dwlL = (Rx(qxL)*Ry(q1L)*Rz(qzL))*dw_body + (Rx(qxL)*Ry(q1L))*[0;0;dqzL] + Rx(qxL)*[0;dq1L;0] + [dqxL;0;0];

F_int = [0;0;0;0];
Nstrip = 10;
dr = wl / Nstrip;
for i = 1:Nstrip
    r = (i-1) * dr + dr / 2;
% Here vR is with respect to the beginning of the wing and wing coordinates
% vR1 is the velocity of the center of the strip in the local wing coordinates 
    RG2rw = Rx(qx)*Ry(qy)*Rz(qz)*Rx(phi)*Ry(0)*Rz(0);  % R_Global_2_right Wing
%     RG2lw = Rx(qx)*Ry(-qy)*Rz(-qz)*Rx(phi)*Ry(0)*Rz(0);  % R_Global_2_left Wing
    dwrG = transpose(RG2rw)*(dwrL);          % transfers the local angular velocity to global
%     dwlG = transpose(RG2lw)*(dwlL);         % transfers the local angular velocity to global
    vR = [0;dy;dz] + cross(dwrG,transpose(RG2rw)*[r;0;0]);  % vR in global coordinates
    vRL = (RG2rw)*vR;        % vR in right wing coordinates = vRL
    vRL = [0;vRL(2);vRL(3)];   % using only y and z components of local vRL
    vRG = transpose(RG2rw)*vRL;        % vRG is the vRL in global coordinates
    alpha = atan2(vRL(3),vRL(2));
    Cd = Cd_fn(alpha);
    Cl = Cl_fn(alpha);
    dF_D = -(1/2)*param.Rof*Cd*param.b*dr*sqrt(dot(vRG,vRG))*vRG;
    
    LiftForce = (1/2)*param.Rof*Cl*param.b*dr*sqrt(dot(vRG,vRG));
    dF_L = -transpose(RG2rw)*cross([LiftForce;0;0],vRL);
    
    dFe = dF_D + dF_L;
%     if abs(vRL(2))<0.01*abs(vRL(3))
%         coeff1 = 0;
%     else
%         coeff1 = 1;
%     end
    coeff1 = tanh(100*abs(alpha-pi/2)*180/pi);
    
%     F_int(1) = 0;
%     F_int(2) = F_int(2) + dot(Rx(-phi)*(Rz(-qz)*(-dRy)*Ry(-qy)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);    
%     F_int(3) = F_int(3) + dot(Rx(-phi)*((-dRz)*Rz(-qz)*Ry(-qy)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);        
%     F_int(4) = F_int(4) + dot(Rx(-phi)*(Rz(-qz)*Ry(-qy)*(-dRx)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);    
    F_int(1) = F_int(1) + dot(Rx(-phi)*(Rz(-qz)*Ry(-qy)*(-dRx)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);    
    F_int(2) = F_int(2) + dot(Rx(-phi)*(Rz(-qz)*(-dRy)*Ry(-qy)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);    
    F_int(3) = F_int(3) + dot(Rx(-phi)*((-dRz)*Rz(-qz)*Ry(-qy)*Rx(-qx))*[r;sign(vRL(2))*param.b*1/4*coeff1;0],dFe);        
    F_int(4) = 0;
    
end
F_int = 2 * F_int;
end

% New coefficients from "Performance of a quasi-steady model for hovering hummingbirds" by Song - 2015
function Cd = Cd_fn(alpha)
%     Cd = (1.135 - 1.05 * cos(2 * alpha));
    Cd = (1.88 - 1.70 * cos(2.0 * alpha));
%     Cd = (1.88 - 1.70 * cos(2.27 * alpha - 10.66*pi/180));
end

function Cl = Cl_fn(alpha)
%     Cl = (1.64 * sin(2 * alpha));
    Cl = (1.87 * sin(2.0 * alpha));
%     Cl = (0.245 + 1.63 * sin(2.34 * alpha - 6.3*pi/180));
    
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

