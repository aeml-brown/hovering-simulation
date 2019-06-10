
clear all


options = optimset('display','iter','diffmaxchange',1.1*1e-6, ...
    'diffminchange',1e-6,'TolCon',1e-4,'TolFun',1e-2,'MaxFunEvals',10000,'Algorithm','interior-point');
% 

warning ('off');


phi0 = 80;      % Body orinetation wrt horrizon  (degree)
proAng = -50;   % pronation angle amplitude   (degree)

V_frwd = 0;     % initial guess for forward speed (m/s)
Vz = 0;         % initial guess for vertical velocity (m/s)
dphi0 = 0;      % initial guess for body rotational velocity (rad/s)
f = 50;         % initial guess for Wingbeat frequency  (Hz)
flpAng = 75;    % Flapping angle amplitude (degree)
proPhs = 0;     % initial guess for pronation angle phase difference (degree)
proShft = 0;    % initial guess for pronation angle shift  (degree)

    

%              V_frwd      Vz       dphi0       f      pro_shft      pro_phs   
State_space = [V_frwd     Vz      dphi0          f      proShft          proPhs];


%                  phi0          flp           pro     
Control_param = [phi0*pi/180      flpAng        proAng];


x_0 = [State_space Control_param];


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
TimeGrid = 5;

t = linspace(tt(1),tt(end),TimeGrid);

x_states = interp1(tt,xx(:,1:3),t(1:TimeGrid-1));
dx_states = interp1(tt,xx(:,8:10),t(1:TimeGrid-1));

f = 1/T;
pinput = [x_states(:);dx_states(:); f; proShft; proPhs];

A = ones(TimeGrid-1,1);
LB = [-1*A; -1*A; -1.1*pi/2*A; -10*A; -10*A; -100*A; 5; -45; -45];
UB = [1*A;  1*A;  1.75*pi/2*A;  10*A;  10*A;  100*A; 120; 45; 45];
tic
[presult,optfval,exitflag,output] = fmincon(@objFunc,pinput,[],[],[],[],LB,UB,@cons,options,x_0,TimeGrid);
toc

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



%%


x_0 = [State_space Control_param];


f = x_0(4);
t1 = 0;
tf = 1/f*1;

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf);
Video.Name = 'video_humm_hover';
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

dt = (1/f)/100;
t = (tt(1):dt:tt(end))';
x = interp1(tt,xx,t);

% % 
% % The body-axis components are calculated as follows:
% 
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
% 
% 
for i = 2:length(Data_R(1,:))
    DataNrm_R(:,2:5) = [x(:,4)  x(:,5)  x(:,6) x(:,7)];
    DataNrm_L(:,2:5) = [x(:,4)  -x(:,5) -x(:,6) x(:,7)];
end
% 


% 
f_total=[];
f_R = [];
f_L = [];
CoP_R = [];
V_in = [];
param = ModelProp(ModelPropList, Data_R);

for i = 1:length(t)
    
    t0 = t(i);
    xm = x(i,:);
    [Force, Moment, V_in1] = AeroForce_InducedVelocity_eval(t0, xm, param );
    f_total = [f_total;[Force(2) Force(3) Moment(1)]];
    V_in = [V_in; V_in1];
end




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




% h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% Mb = param.Mb;
% Mw = param.mw;
% g =  param.g;
% for i = 1:3
% subplot(3,1,i)
% plot(t,f_total(:,i),'-r','linewidth',1); hold on; grid on
% if i==2
%     plot(t,(Mb+2*Mw)*g*ones(size(t)),'-c');
% end
%     Imp = sum(f_total(:,i));
%     text(t(end)/2,max(f_total(:,i)),['Imp=' num2str(Imp)]);
% end
% 
% 
% h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% for i=1:6
% subplot(2,3,i)
% if i<4
%     plot(t,x(:,i));
% else
%     plot(t,x(:,i+4));
% end
% end
% 
h=figure('position',[200 100 1100 650],'color','white'); hold on; grid on
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

h=figure('position',[200 100 1100 650],'color','white'); hold on; grid on
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

% 
% h_WngMot = figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% 
% plot(t*f,x(:,5)*180/pi,'-b','linewidth',2); hold on
% plot(t*f,x(:,4)*180/pi,'--r','linewidth',2); hold on
% legend('Flapping Angle','Pronation Angle')
% xlabel('Time [Wingbeats]')
% ylabel('Angle [\circ]')
% 
% 
% 
% h=figure('position',[-1200 100 1100 650],'color','white'); hold on; grid on
% plot(x(:,1),x(:,2));
% % ylabel((ylabel_list(i)));
% 
% % 
% % figure;
% % plot3(x(:,1),x(:,2),x(:,3));

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

