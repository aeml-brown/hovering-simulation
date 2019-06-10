function [cineq,ceq] = cons(pinput,x_0,TimeGrid)
TG = TimeGrid;

y = pinput(1:TG-1);
z = pinput(TG:2*TG-2);
phi = pinput(2*TG-1:3*(TG-1));
dy = pinput(3*TG-2:4*(TG-1));
dz = pinput(4*TG-3:5*(TG-1));
dphi = pinput(5*TG-4:6*(TG-1));

f = pinput(6*TG-5);
proShft = pinput(6*TG-4);
proPhs = pinput(6*TG-3);



State_space = [dy(1) dz(1) dphi(1) f proShft proPhs];


x_0(1:6) = State_space;
% phi(1) = x_0(7);


T = 1/f;

t = linspace(0,T,TimeGrid);

x0 = zeros(14,1);

ceq = [];
cineq = [];

if isnan(sum(State_space)) 
    ceq = [1];
    return;
end

% a1 = abs(phi(1)-x_0(7));
% cineq = [cineq;a1-0.1];
ceq = [ceq;phi(1)-x_0(7)];

% tic
for i = 1:TimeGrid-1

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t(i),t(i+1));


x0(4) = Wing_fn(1,1);
x0(5) = Wing_fn(1,2);
x0(6) = Wing_fn(1,3);
x0(7) = Wing_fn(1,4);

x0(11) = Wing_fn(1,5);
x0(12) = Wing_fn(1,6);
x0(13) = Wing_fn(1,7);
x0(14) = Wing_fn(1,8);


x0(1) = y(i);
x0(2) = z(i);
x0(3) = phi(i);
x0(8)  = dy(i);
x0(9)  = dz(i);
x0(10) = dphi(i);
% tic
[tt,xx] = MexBased_OdeSolver_mex(x0, ModelPropList, Data_R);
% toc
% disp(length(tt));
% % disp(toc);
% if length(tt)>300
%     disp(x0);
% end


if i<TimeGrid-1
    delta_y = xx(end,1)-y(i+1);
    delta_z = xx(end,2)-z(i+1);
    delta_phi = xx(end,3)-phi(i+1);
    
    delta_dy = xx(end,8)-dy(i+1);
    delta_dz = xx(end,9)-dz(i+1);
    delta_dphi = xx(end,10)-dphi(i+1);
    
    ceq = [ceq;delta_y;delta_z;delta_phi];
    ceq = [ceq;delta_dy;delta_dz;delta_dphi];
elseif i==TimeGrid-1
    delta_y = xx(end,1)-y(1);
    delta_z = xx(end,2)-z(1);
    delta_phi = xx(end,3)-phi(1);
    
    delta_dy = xx(end,8)-dy(1);
    delta_dz = xx(end,9)-dz(1);
    delta_dphi = xx(end,10)-dphi(1);
    
    ceq = [ceq;100*delta_y;100*delta_z;delta_phi];
    ceq = [ceq;delta_dy;delta_dz;delta_dphi];
end


end
% toc

% cineq = [cineq; x_end-5; x_end+5]; 



end