

clear all

% load .\Data\General\3-08-2016-v1-Modified_AllMasses.mat
% load 3-18-2016-Bat-Glasso-Mw20-v2.mat

% load hummingbird_Mellivora_Pro50_3-24-2016-v1
% load hummingbird_Mellivora_Pro65_4-22-2016-v1
% load hummingbird_Mellivora_ARincreased5_5-17-2016-v1
% load hummingbird_Mellivora_AR35_5-17-2016-v1
% load hummingbird_Anna_AR5_5-17-2016-v1
% load hummingbird_Mellivora_AR3_highIbx_5-17-2016-v1
% load hummingbird_OutputData_Amazilia_saucerottei_5-18-2016-v1
load hummingbird_OutputData_Anna_IbxRatio2_5-25-2016-v1


% OutputData = OutputData_Mellivora_AR3;
% OutputData = OutputData_Anna_AR5;
% OutputData = 


% PowerData_m34 = [];
% PowerData_m45 = [];
% PowerData_m55 = [];
PowerData = [];

% for j = [34 45 55];

% j = 55;
% OutputData_filtered = OutputData_extended(OutputData_extended(:,11)<5e-4,2:12);
% OutputData_filtered = OutputData_extended(OutputData_extended(:,10)<5e-4,1:11);
% OutputData_filtered = OutputData_Mellivora_ModifiedIbx(OutputData_Mellivora_ModifiedIbx(:,10)<5e-4,1:11);
OutputData_filtered = OutputData(OutputData(:,10)<5e-4,1:11);

% OutputData_Var = [];
% OutputData_Var = eval(['OutputData_m' num2str(j) '_filtered']);
OutputData_Var = OutputData_filtered;



for ind = 1:length(OutputData_Var(:,1))



V_frwd = OutputData_Var(ind,1);
Vz = OutputData_Var(ind,2);
dphi0 = OutputData_Var(ind,3);
f = OutputData_Var(ind,4);
proShft = OutputData_Var(ind,5);
proPhs = OutputData_Var(ind,6);

phi0 = OutputData_Var(ind,7)*180/pi;
flpAng = OutputData_Var(ind,8);
proAng = OutputData_Var(ind,9);

%              V_frwd      Vz       dphi0       f      pro_shft      pro_phs   
State_space = [V_frwd      Vz      dphi0        f      proShft       proPhs];

%                  phi0            flp           pro     
Control_param = [phi0*pi/180      flpAng        proAng];


x_0 = [State_space Control_param];


f = x_0(4);
t1 = 0;
tf = 1/f*1;

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf);

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

% MechWrk_vec = sum(Power(:,:)')*dt;
% MechWrk_vec((MechWrk_vec(:)<0)) = 0;
% MechWrk = sum(MechWrk_vec);

MechWrk_All = Power(:,:)*dt;
MechWrk_Postv = MechWrk_All;
MechWrk_Postv((MechWrk_Postv(:,:)<0)) = 0;
MechWrk = sum(sum(MechWrk_Postv));

Tmax1 = max(f_int_total(:,4).^2);
Tmax2 = max(f_int_total(:,5).^2);

Tmax = sqrt(max(Tmax1,Tmax2))/(param.Mb*param.g);

err1 = max(abs(xx(end,[1:3 8:9])-xx(1,[1:3 8:9])));
err2 = max(abs(xx(end,10)-xx(1,10)));
err = max(100*err1,err2);

disp([phi0 f flpAng proAng Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk err]);

% if j==34
%     PowerData_m34 = [PowerData_m34;[x_0 Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk]];
% elseif j==45
%     PowerData_m45 = [PowerData_m45;[x_0 Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk]];
% elseif j==55
%     PowerData_m55 = [PowerData_m55;[x_0 Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk]];
% end

PowerData = [PowerData;[x_0 Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk]];

end

% save PowerData_Hummingbird_Mellivora_Pro50_03-24-2016-v1
% save PowerData_hummingbird_Mellivora_Pro65_4-22-2016-v1
% save PowerData_hummingbird_Mellivora_AR35_5-17-2016-v1
% save PowerData_hummingbird_Anna_AR5_5-17-2016-v1
% save PowerData_hummingbird_Mellivora_AR3_highIbx_5-17-2016-v1
save PowerData_hummingbird_OutputData_Anna_IbxRatio2_5-25-2016-v1


% save PowerData_Glossophaga_mw20-03-18-2016-v1
% save PowerData_03-16-2016-Modified_AllMasses

% end
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



