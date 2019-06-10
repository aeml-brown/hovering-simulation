

VideoName = 'HummingbirdHovering';

phi0         = x_0(1);
v_forward    = x_0(2);
vz           = x_0(3);
dphi0        = x_0(4);
f            = x_0(5);
FlapAmplid   = x_0(6);
ProAmplid    = x_0(7);
SweepAmplid  = x_0(8);

obj.Flp_shft = 0;
obj.Pro_shft = x_0(9)*pi/180;
obj.Swp_shft = x_0(10)*pi/180;


obj.Flp_phs = 0;
obj.Pro_phs = x_0(11)*pi/180;
obj.Swp_phs = 0;



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
Mw = 0.75e-3*0;
Mb = Mb - 2*Mw;
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

