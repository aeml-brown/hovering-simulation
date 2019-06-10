

clear all

load 2-25-2016-v4.mat

OutputData_filtered = [];

for i = 1:length(OutputData(:,1))
    if OutputData(i,9)<1e-5 && OutputData(i,8)==0
        OutputData_filtered = [OutputData_filtered;OutputData(i,:)];
    end
end


PowerData = [];

for ind = 1:length(OutputData_filtered(:,1))



phi0 = OutputData_filtered(ind,1)*180/pi;
V_frwd = OutputData_filtered(ind,2);
Vz = OutputData_filtered(ind,3);
dphi0 = OutputData_filtered(ind,4);
f = OutputData_filtered(ind,5);
flpAng = OutputData_filtered(ind,6);
proAng = OutputData_filtered(ind,7);
proPhs = OutputData_filtered(ind,8);
proShft = 0;

%              V_frwd      Vz       dphi0       f      pro_shft      pro_phs   
State_space = [V_frwd      Vz      dphi0        f      proShft       proPhs];

%                  phi0            flp           pro     
Control_param = [phi0*pi/180      flpAng        proAng];


x_0 = [State_space Control_param];


f = x_0(4);
t1 = 0;
tf = 1/f*1;

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf);
Video.Name = 'HummingbirdHovering-zeroshiftZeroPhs';
Video.Swtch = 0;

% Hovering;

x0 = zeros(14,1);

x0(4) = Wing_fn(1,1);
x0(5) = Wing_fn(1,2);
x0(6) = Wing_fn(1,3);
x0(7) = Wing_fn(1,4);

x0(11) = Wing_fn(1,5);
x0(12) = Wing_fn(1,6);
x0(13) = Wing_fn(1,7);
x0(14) = Wing_fn(1,8);


x0(3)  = x_0(7);
x0(8)  = x_0(1);
x0(9)  = x_0(2);
x0(10) = x_0(3);

[tt,xx] = MexBased_OdeSolver_mex(x0, ModelPropList, Data_R);
% [tt,xx] = MexBased_OdeSolver(x0, ModelPropList, Data_R);

dt = (1/f)/100;
t = (tt(1):dt:tt(end))';
x = interp1(tt,xx,t);



f_total=[];
f_R = [];
f_L = [];
CoP_R = [];
param = ModelProp(ModelPropList, Data_R);
for i = 1:length(t)
    
    t0 = t(i);
    xm = x(i,:);
    [Force, Moment, CoPR] = AeroForce_eval(t0, xm, param );
    f_total = [f_total;[Force(2) Force(3) Moment(1)]];
    CoP_R = [CoP_R; CoPR];
end


f_aero_int_total=[];
param = ModelProp(ModelPropList, Data_R);
for i = 1:length(t)
    
    t0 = t(i);
    xm = x(i,:);
    [F_int] = AeroForce_VrtlWrk_Intrnl(t0, xm, param);
    f_aero_int_total = [f_aero_int_total;0.5*F_int'];
end


f_int_total=[];
param = ModelProp(ModelPropList, Data_R);
for i = 1:length(t)
    
    t0 = t(i);
    xm = x(i,:);
    [F_int] = InternalForces(t0, xm, param);
    f_int_total = [f_int_total;F_int'];
end


% for power calculation
V = x(:,11:14);
Power = [];
for i = 1:length(t)
    Power1 = x(i,11:14).*f_int_total(i,4:7);
    Power = [Power;Power1];
end

MechWrk_vec = sum(Power(:,:)')*dt;
MechWrk_vec((MechWrk_vec(:)<0)) = 0;
MechWrk = sum(MechWrk_vec);

Fmax1 = max(f_int_total(:,4).^2);
Fmax2 = max(f_int_total(:,5).^2);

Fmax = sqrt(max(Fmax1,Fmax2))*1000;

disp([phi0 f flpAng proAng Fmax max((sum(Power(:,:)'))) MechWrk]);

PowerData = [PowerData;[x_0 Fmax max((sum(Power(:,:)'))) MechWrk]];

end

save Power_2-25-2016-v4
% h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
% for i = 1:4
% subplot(3,4,i)
% plot(t,f_aero_int_total(:,i),'-b','linewidth',1); hold on; grid on
% xlabel('Time [s]');
% ylabel('Aerodyn force [N]');
% end
% 
% for i = 1:4
% subplot(3,4,i+4)
% plot(t,f_int_total(:,i+3),'-b','linewidth',1); hold on; grid on
% xlabel('Time [s]');
% ylabel('Internal force [N]');
% end
% 
% for i = 1:4
% subplot(3,4,i+8)
% plot(t,Power(:,i),'-b','linewidth',1); hold on; grid on
% if i==2
%     plot(t,(sum(Power(:,:)'))','--r','linewidth',1); hold on; grid on
% end
% xlabel('Time [s]');
% ylabel('Power [N.m/s]');
% end



