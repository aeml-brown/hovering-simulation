
function ObjFunc = optim_HF_MS(x_0,x_1)
% 

% x_0(1) = x_0(1)*1;
% x_0(2) = x_0(2)*100;
% x_0(3) = x_0(3)*100;


phi0         = x_0(1);
v_forward    = x_0(2);
vz           = x_0(3);
dphi0        = x_0(4);
f            = x_0(5);
FlapAmplid   = x_0(6);
ProAmplid    = x_0(7);
SweepAmplid  = x_1(8);

obj.Flp_shft = 0;
obj.Pro_shft = x_1(9)*pi/180;
obj.Swp_shft = x_1(10)*pi/180;

% obj.WngSpn       = 0.125;
obj.WngSpn       = 0.0447;  % Hummingbird



obj.Omega = 2 * pi * f; % w = 2*pi*f , f=15hz
tf = 1 * 2 * pi / obj.Omega;
dt = (1/f)/100;
Cstar = 1;



g = 9.81*1;
% Mb = 12e-3 + 2 * 3.5e-3;
Mb = 3.41e-3;  % hummingbird
% Mb = 12e-3;
Mw = 3.5e-3*0;
Ibx = 6e-6*1e10;
Ibx = 5e-7;


Kp_WingSpan = 0;
Kd_WingSpan = 0;
Kp_WingPitch = 0;
Kd_WingPitch = 0;
Kp_WingSweep = 0;
Kd_WingSweep = 0;


obj.FlpAmp = FlapAmplid * pi / 180;
obj.ProAmp = ProAmplid * pi / 180;
obj.SwpAmp = SweepAmplid * pi / 180;


time = (0:dt:tf)';
if time(end)<tf
    time(end+1) = tf;
end

Wing_fn = WngFns(time', obj)';


Data_R(:,1) = time;
Data_R(:,2) = Wing_fn(:,9);
Data_R(:,3) = Wing_fn(:,10);
Data_R(:,4) = Wing_fn(:,11);
Data_R(:,5) = Wing_fn(:,12);

Data_L(:,1) = time;
Data_L(:,2) = Wing_fn(:,9);
Data_L(:,3) = -Wing_fn(:,10);
Data_L(:,4) = -Wing_fn(:,11);
Data_L(:,5) = Wing_fn(:,12);

ModelPropList(1,1) = Cstar;
ModelPropList(2,1) = g;
ModelPropList(3,1) = Mb;
ModelPropList(4,1) = Mw;
ModelPropList(5,1) = Ibx;
% ModelPropList(5,1) = Kp_WingSpan;
ModelPropList(6,1) = Kd_WingSpan;
ModelPropList(7,1) = Kp_WingPitch;
ModelPropList(8,1) = Kd_WingPitch;
ModelPropList(9,1) = Kp_WingSweep;
ModelPropList(10,1) = Kd_WingSweep;
    

x0 = zeros(14,1);

x0(4) = Wing_fn(1,1);
x0(5) = Wing_fn(1,2);
x0(6) = Wing_fn(1,3);
x0(7) = Wing_fn(1,4);

x0(11) = Wing_fn(1,5);
x0(12) = Wing_fn(1,6);
x0(13) = Wing_fn(1,7);
x0(14) = Wing_fn(1,8);


x0(3) = phi0;
x0(8) = v_forward;
x0(9) = vz;
x0(10) = dphi0;



[tt,xx] = MexBased_OdeSolver_mex(x0, ModelPropList, Data_R);
% t = tt(1):0.001:tt(end);
% x = interp1(tt,xx,t);


% ObjFunc = (Mb*g)*sqrt((xx(end,1))^2+(xx(end,2))^2+(xx(end,3)-phi0)^2+1e-10) +  0.5*Mb*(sqrt(xx(end,9)^2-vz^2+1e-10))+...
%             0.5*Mb*(sqrt(xx(end,8)^2-v_forward^2+1e-10))+ 0.5*Ibx*sqrt((xx(end,10)^2-dphi0^2+1e-10));
        
ObjFunc = 1000*((Mb*g)*(sqrt((xx(end,1))^2+1e-10)+sqrt((xx(end,2))^2+1e-10))+Ibx*g*(sqrt((xx(end,3)-phi0)^2+1e-10)) +  0.5*Mb*(sqrt((xx(end,9)^2-vz^2)^2+1e-10))+...
            0.5*Mb*(sqrt((xx(end,8)^2-v_forward^2)^2+1e-10))+ 0.5*Ibx*sqrt(((xx(end,10)^2-dphi0^2)^2+1e-10)));
        
        if f>55
            ObjFunc = 10*1000*((Mb*g)*(sqrt((xx(end,1))^2+1e-10)+sqrt((xx(end,2))^2+1e-10))+Ibx*g*(sqrt((xx(end,3)-phi0)^2+1e-10)) +  0.5*Mb*(sqrt((xx(end,9)^2-vz^2)^2+1e-10))+...
                        0.5*Mb*(sqrt((xx(end,8)^2-v_forward^2)^2+1e-10))+ 0.5*Ibx*sqrt(((xx(end,10)^2-dphi0^2)^2+1e-10)));
        end

% disp([f,FlapAmplid,ProAmplid,SweepAmplid,phi0,dphi0,vz,SweepAmplid_phase,Sweep_shift,Pro_phase,Pro_shift]);
disp(x_0);
disp(ObjFunc);


end
