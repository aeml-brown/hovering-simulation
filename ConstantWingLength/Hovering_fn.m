function [Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf)

f            = x_0(4);

obj.Flp_shft = 0;
obj.Pro_shft = x_0(5)*pi/180;
obj.Swp_shft = 0;

obj.Flp_phs = 0;
obj.Pro_phs = x_0(6)*pi/180;
obj.Swp_phs = 0;


FlapAmplid   = x_0(8)*pi/180;
ProAmplid    = x_0(9)*pi/180;
SweepAmplid  = 0;


% obj.WngSpn       = 0.125;
% obj.WngSpn       = 0.0447;  % Hummingbird
% obj.WngSpn       = 0.117; % Glossophaga
% obj.WngSpn       = 0.047;  % Hummingbird : Selasphorus rufus (Tobalske JEB 2007)
obj.WngSpn       = 0.0525;  % Hummingbird : Calypte anna
% obj.WngSpn       = 0.0576;  % Hummingbird : Amazilia saucerottei
% obj.WngSpn       = 0.0577;  % Hummingbird : Amazilia tzacatl
% obj.WngSpn       = 0.0429;  % Hummingbird : Chaetocercus mulsant
% obj.WngSpn       = 0.0791;  % Hummingbird : Colibri_coruscans
% obj.WngSpn       = 0.0745;  % Hummingbird : Florisuga mellivora
% obj.WngSpn       = 0.0691;  % Hummingbird : Lafresnaya lafresnayi
% obj.WngSpn       = 0.0555;  % Hummingbird : Metallura tyrianthina
% obj.WngSpn       = 0.141;  % Hummingbird : giant hummingbird




% b = 0.0129; % hummingbird : Calypte anna
b = obj.WngSpn/4.0;

% param.b = 0.0117;
% param.b = 0.012; % Hummingbird : Selasphorus rufus (Tobalske JEB 2007)
% param.b = 0.05;
% param.b = 0.0415;
% param.b = 0.0108; % hummingbird : Chaetocercus mulsant
% param.b = 0.0129; % hummingbird : Calypte anna
% param.b = 0.0152; % hummingbird : Amazilia_tzacatl
% param.b = 0.0146; % hummingbird : Amazilia_saucerottei
% param.b = 0.022; % hummingbird : Colibri_coruscans
% param.b = 0.017; % Hummingbird : Florisuga mellivora
% param.b = 0.0164; % Hummingbird : Lafresnaya lafresnayi
% param.b = 0.0172; % Hummingbird : Metallura tyrianthina
% param.b = 0.0745 / 3; % to provide AR = 5 for Mellivora
% param.b = 0.0525 / 5.0; % to provide AR = 5 for Anna



% Mb = 3.41e-3;  % hummingbird : 
% Mb = 3.4e-3;  % Hummingbird : Selasphorus rufus (Tobalske JEB 2007)

% Mb = 5.1e-3;  % hummingbird : Amazilia saucerottei
Mb = 4.68e-3;  % hummingbird : Calypte anna
% Mb = 5.21e-3;  % hummingbird : Amazilia tzacatl
% Mb = 3.85e-3;  % hummingbird : Chaetocercus mulsant
% Mb = 7.35e-3;  % hummingbird : Colibri_coruscans
% Mb = 7.25e-3;  % hummingbird : Florisuga mellivora
% Mb = 6.04e-3;  % hummingbird : Lafresnaya lafresnayi
% Mb = 3.43e-3;  % hummingbird : Metallura tyrianthina
% Mb = 10.5e-3; % for Glossophaga
% Ibx = (1/5)*Mb*(0.0415^2+0.015^2);  % for Glossophaga
% Mb = 3.41e-3; % for hummingbird
% Mb = 4.5e-3; % for hummingbird
% Mb = 20e-3; % for giant hummingbird

% Ibx = (1/20) * (Mb) * (0.15^2+0.02^2)*5;
% Ibx = 5e-7;  % for hummingbird
% Ibx = (5e-7) * (Mb/3.41e-3) ^ (5/3);
% Ibx = (5e-7) * (Mb/3.41e-3) ^ (5/3) * 10;
Ibx = (10) * (1.2 * 0.0129 * 0.0525^4); % Ratio * (Rho*c*s^4)
% Ibx = (2) * (1.2 * b * obj.WngSpn^4); % Ratio * (Rho*c*s^4)
% Ibx = Ibx/1;

obj.Omega = 2 * pi * f; % w = 2*pi*f , f=15hz
dt = (tf-t1)/100;
Cstar = 1.2/1.2;

k_i = 1;

g = 9.81*1;
% Mb = 12e-3 + 2 * 3.5e-3;
% Mb = 12e-3;
% Mw = 3.5e-3*0;
Mw = 0.1*Mb*0.0;
Mb = Mb - 2*Mw;
% Ibx = 6e-6*1e10;
% Ibx = 5e-7;


Kp_WingSpan = 0;
Kd_WingSpan = 0;
Kp_WingPitch = 0;
Kd_WingPitch = 0;
Kp_WingSweep = 0;
Kd_WingSweep = 0;


obj.FlpAmp = FlapAmplid;
obj.ProAmp = ProAmplid;
obj.SwpAmp = SweepAmplid;


time = (t1:dt:tf)';
if time(end)<tf
    time(end+1) = tf;
end

Wing_fn = WngFns(time', obj)';


Data_R(:,1) = time;
Data_R(:,2) = Wing_fn(:,9);
Data_R(:,3) = Wing_fn(:,10);
Data_R(:,4) = Wing_fn(:,11);
Data_R(:,5) = Wing_fn(:,12);
Data_R(:,6:13) = Wing_fn(:,1:8);

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
ModelPropList(6,1) = b;
ModelPropList(7,1) = k_i;

ModelPropList(8,1) = Kd_WingPitch;
ModelPropList(9,1) = Kp_WingSweep;
ModelPropList(10,1) = Kd_WingSweep;

end

