

clear all

% options = optimset('display','iter','diffmaxchange',1.1*1e-9, ...
%     'diffminchange',1e-9,'AlwaysHonorConstraints','bounds','Algorithm','active-set',...
%     'MaxFunEvals',50000,'MaxIter',50000);

% options = optimset('display','iter','MaxFunEvals',50000,'MaxIter',50000,'diffmaxchange',1.1*1e-6, ...
%     'diffminchange',1e-6,'TolCon',1e-4,'Algorithm','sqp');

% options = optimset('display','iter','diffmaxchange',1.1*1e-6, ...
%     'diffminchange',1e-6,'TolCon',1e-5,'AlwaysHonorConstraints','bounds','Algorithm','interior-point');

options = optimset('display','iter','diffmaxchange',1.1*1e-6, ...
    'diffminchange',1e-6,'TolCon',1e-4,'TolFun',1e-2,'MaxFunEvals',2000,'Algorithm','interior-point');
% 

warning ('off');


% works for e=0.2
% phi0 = 90;
% proAng = -40.;
% 
% V_frwd = 0.20;
% Vz = -0.02;
% dphi0 = -1;
% f = 10;
% flpAng = (60);  
% proPhs = 15;
% proShft = 2;

%   0.085049 -0.270495 -1.244117 14.870572 16.827322 34.633740 0.401426 50.000000 -35.000000 0.200000   timeGrid=5

Filename = 'Data4.txt';

fileID = fopen(Filename);
xt_0 = textscan(fileID,'%f %f %f %f %f %f %f %f %f %f');
fclose(fileID);
x_0 = [];
for i = 1:10
    x_0(i) = xt_0{:,i}(end);
end


%              V_frwd     Vz      dphi0       f      pro_shft      pro_phs   
% State_space = [V_frwd     Vz      dphi0       f      proShft       proPhs];

%                  phi0            flp           pro       WngSpnRatio
% Control_param = [phi0*pi/180      flpAng        proAng         0.175];
% Control_param = [phi0*pi/180      flpAng        proAng         0.008];
% Control_param = [phi0*pi/180      flpAng        proAng         0.];

x_0(7) = 23*pi/180;
x_0(end) = 0.2;

% x_0 = [State_space Control_param];

f = x_0(4);
proShft = x_0(5);
proPhs = x_0(6);

t1 = 0;
tf = 1/f;

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

T = tt(end);
TimeGrid = 6;

t = linspace(tt(1),tt(end),TimeGrid);

x_states = interp1(tt,xx(:,1:3),t(1:TimeGrid-1));
dx_states = interp1(tt,xx(:,8:10),t(1:TimeGrid-1));

f = 1/T;
pinput = [x_states(:);dx_states(:); f; proShft; proPhs];

A = ones(TimeGrid-1,1);
LB = [-1*A; -1*A; -1.1*pi/2*A; -10*A; -10*A; -100*A; 5; -70; -70];
UB = [1*A;  1*A;  1.75*pi/2*A;  10*A;  10*A;  100*A; 100; 70; 70];
tic
[presult,optfval,exitflag,output] = fmincon(@objFunc,pinput,[],[],[],[],LB,UB,@cons,options,x_0,TimeGrid);
toc

[cineq,ceq] = cons(presult,x_0,TimeGrid);

TG = TimeGrid;
y = presult(1:TG-1);
z = presult(TG:2*TG-2);
phi = presult(2*TG-1:3*(TG-1));
dy = presult(3*TG-2:4*(TG-1));
dz = presult(4*TG-3:5*(TG-1));
dphi = presult(5*TG-4:6*(TG-1));

f = presult(6*TG-5);
proShft = presult(6*TG-4);
proPhs = presult(6*TG-3);




State_space = [dy(1) dz(1) dphi(1) f proShft proPhs];
Control_param = [phi(1) x_0(8:10)];

% OutputData_Metallura_tyrianthina = [OutputData_Metallura_tyrianthina;[State_space Control_param output.constrviolation exitflag]];

% disp([phi(1)*180/pi f flpAng proAng proShft output.constrviolation]);


disp([Control_param(1)*180/pi State_space]);
x_0 = [State_space Control_param];


fid = fopen(Filename, 'a+');
fprintf(fid, '%f %f %f %f %f %f %f %f %f %f \n', x_0);
fclose(fid);


% end
% 
% save hummingbird_Metallura_tyrianthina_3-09-2016-v1
% 
% end


%%

% Control_param(1) = phi(1);

x_0 = [State_space Control_param];


f = x_0(4);
t1 = 0;
tf = 1/f*1;

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf);
Video.Name = 'VideoBatHover_1';
Video.Swtch =0;

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

% [tt,xx] = MexBased_OdeSolver_mex(x0, ModelPropList, Data_R);
[tt,xx] = MexBased_OdeSolver(x0, ModelPropList, Data_R);

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


h_WngMot = figure('position',[-1200 100 1100 650],'color','white'); hold on;
plot(t*f,-x(:,5)*180/pi,'-b','linewidth',2); hold on
plot(t*f,-x(:,4)*180/pi,'--r','linewidth',2); hold on
legend('Flapping Angle','Pronation Angle')
xlabel('Time [Wingbeats]')
ylabel('Angle [\circ]')

% save2pdf('WingMotion_ProShft.pdf',h_WngMot,1200)


h=figure('position',[-1200 100 1100 650],'color','white'); hold on;
subplot(1,2,1)
plot(t*f,-x(:,5)*180/pi,'-b','linewidth',2); hold on
plot(t*f,x(:,4)*180/pi,'--r','linewidth',2); hold on
legend('Flapping Angle','Pronation Angle')
xlabel('Time [Wingbeats]')
ylabel('Angle [\circ]')
subplot(1,2,2)
plot(t*f,x(:,7)/0.117,'linewidth',2);
xlabel('Time [Wingbeats]')
ylabel('Wing-span ratio')



h=figure('position',[-1200 100 1100 650],'color','white'); hold on
Mb = param.Mb;
Mw = param.mw;
g =  param.g;
BW = (Mb+2*Mw)*g;
plot(t*f,f_total(:,1)/BW,'--b','linewidth',2); hold on
plot(t*f,f_total(:,2)/BW,'-r','linewidth',2); hold on
xlabel('Time [Wingbeats]')
ylabel('Force (\times BW)')
legend ('Drag','Lift')
% save2pdf('LiftDrag_Mw0_e20.pdf',h,1200)





h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
plot(x(:,1)/0.117,x(:,2)/0.117,'linewidth',2);
xlabel('x [\times s]')
ylabel('z [\times s]')
axis equal
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
Animate_perspective(t,xA,DataNrm_R, DataNrm_L,BodyAngle,f_total,param,Video);
% Animate_only(t,xA,DataNrm_R, DataNrm_L,BodyAngle,f_total,param,Video);
