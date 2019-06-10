

clear all

% load 3-04-2016-v1.mat
% load 3-08-2016-v1-Modified_AllMasses.mat
load PowerData_Glossophaga_mw0-03-18-2016-v1

% global Mb Ibx;
% Mb = 3.41e-3;
% Ibx = 5e-7;
% 
ind = 908;

% m = 34;
% OutputData_Var = eval(['OutputData_m' num2str(m) '_filtered']);
OutputData_Var = OutputData_filtered;


V_frwd = OutputData_Var(ind,1);
Vz = OutputData_Var(ind,2);
dphi0 = OutputData_Var(ind,3);
f = OutputData_Var(ind,4);
proShft = OutputData_Var(ind,5);
proPhs = OutputData_Var(ind,6);

phi0 = OutputData_Var(ind,7)*180/pi;
flpAng = OutputData_Var(ind,8);
proAng = OutputData_Var(ind,9);


% phi0 = OutputData(ind,7)*180/pi;
% V_frwd = OutputData(ind,1);
% Vz = OutputData(ind,2);
% dphi0 = OutputData(ind,3);
% f = OutputData(ind,4);
% flpAng = OutputData(ind,8);
% proAng = OutputData(ind,9);
% proPhs = OutputData(ind,6);
% proShft = OutputData(ind,5);

% phi0 = 90;
% V_frwd = 0;
% Vz = 0;
% dphi0 = 0;
% f = 20;
% flpAng = 60;
% proAng = -50;
% proPhs = 0;
% proShft = 0;






%              V_frwd      Vz       dphi0       f      pro_shft      pro_phs   
State_space = [V_frwd     Vz      dphi0          f      proShft          proPhs];

%                  phi0          flp           pro     
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
tic
% [tt,xx] = MexBased_OdeSolver_mex(x0, ModelPropList, Data_R);
[tt,xx] = MexBased_OdeSolver(x0, ModelPropList, Data_R);
toc
dt = (1/f)/100;
t = (tt(1):dt:tt(end))';
x = interp1(tt,xx,t);

% 
% The body-axis components are calculated as follows:

phi = x(:,3);
th = x(:,1)*0;
psi = x(:,1)*0;
dphi = x(:,10);
dth = x(:,1)*0;
dpsi = x(:,1)*0;

wx = dphi-dpsi.*sin(th);
wy = dpsi.*cos(th).*sin(phi)+dth.*cos(phi);
wz = dpsi.*cos(th).*cos(phi)-dth.*sin(phi);

for i = 1:length(t)
    if i==1
        PitchAngle(i) = phi(1);
        RollAngle(i) = 0;
        YawAngle(i) = 0;
    else
        PitchAngle(i) = PitchAngle(i-1)+wx(i-1)*(t(i)-t(i-1));
        RollAngle(i) = RollAngle(i-1)+wy(i-1)*(t(i)-t(i-1));
        YawAngle(i) = YawAngle(i-1)+wz(i-1)*(t(i)-t(i-1));
    end
    BodyAngle(i,:) = [PitchAngle(i),RollAngle(i),YawAngle(i)];
    
end


% for i = 2:length(Data_R(1,:))
    DataNrm_R(:,2:5) = [x(:,4)  x(:,5)  x(:,6) x(:,7)];
    DataNrm_L(:,2:5) = [x(:,4)  -x(:,5) -x(:,6) x(:,7)];
% end
% 



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
    f_aero_int_total = [f_aero_int_total;F_int'];
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


h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
for i = 1:4
subplot(3,4,i)
plot(t,f_aero_int_total(:,i),'-b','linewidth',1); hold on; grid on
xlabel('Time [s]');
ylabel('Aerodyn force [N]');
end

for i = 1:4
subplot(3,4,i+4)
plot(t,f_int_total(:,i+3),'-b','linewidth',1); hold on; grid on
xlabel('Time [s]');
ylabel('Internal force [N]');
end

for i = 1:4
subplot(3,4,i+8)
plot(t,Power(:,i),'-b','linewidth',1); hold on; grid on
if i==2
    plot(t,(sum(Power(:,:)'))','--r','linewidth',1); hold on; grid on
end
xlabel('Time [s]');
ylabel('Power [N.m/s]');
end


% h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% for i = 1:length(t)
%     plot(1:10,CoP_R(10*i-9:10*i,2),'*r','linewidth',1); hold off; grid on
%     ylim([min(CoP_R(1:end,2)) max(CoP_R(1:end,2))])
%     pause;
% end



h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
Mb = param.Mb;
Mw = param.mw;
g =  param.g;
for i = 1:3
subplot(3,1,i)
plot(t,f_total(:,i),'-r','linewidth',1); hold on; grid on
if i==2
    plot(t,(Mb+2*Mw)*g*ones(size(t)),'-c');
end
    Imp = sum(f_total(:,i));
    text(t(end)/2,max(f_total(:,i)),['Imp=' num2str(Imp)]);
end


h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
for i=1:6
subplot(2,3,i)
if i<4
    plot(t,x(:,i));
else
    plot(t,x(:,i+4));
end
end

h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
subplot(1,3,1)
plot(x(:,1),x(:,8))
xlabel('y');
ylabel('Vy');
subplot(1,3,2)
plot(x(:,2),x(:,9))
xlabel('z');
ylabel('Vz');
subplot(1,3,3)
plot(x(:,3),x(:,10))
xlabel('\phi');
ylabel('dphi');

h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% ylabel_list = ['Flp' 'Pro' 'Swp' 'Len'];
for i=1:4
subplot(2,4,i)
if i<4
    plot(t,x(:,i+3)*180/pi);
else
    plot(t,x(:,i+3));
end
subplot(2,4,i+4)
if i<4
    plot(t,x(:,i+10)*180/pi);
else
    plot(t,x(:,i+10));
end

end


h_WngMot = figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on

plot(t*f,x(:,5)*180/pi,'-b','linewidth',2); hold on
plot(t*f,x(:,4)*180/pi,'--r','linewidth',2); hold on
legend('Flapping Angle','Pronation Angle')
xlabel('Time [Wingbeats]')
ylabel('Angle [\circ]')

save2pdf('WingMotion_ProShft.pdf',h_WngMot,1200)




h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
plot(x(:,1),x(:,2));
% ylabel((ylabel_list(i)));

% 
% figure;
% plot3(x(:,1),x(:,2),x(:,3));

% figure(1); hold on
% plot(t,x(:,1:3));drawnow
% legend ('x','y','z');


xA = zeros(length(x),12);
xA(:,2) = x(:,1);
xA(:,3) = x(:,2);
xA(:,4) = x(:,3);
xA(:,8) = x(:,8);
xA(:,9) = x(:,9);
xA(:,10) = x(:,10);

param.f = f;
% Animate_perspective(t,xA,DataNrm_R, DataNrm_L,BodyAngle,f_total,param,Video);

