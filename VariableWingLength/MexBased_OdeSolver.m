function [t,x] = MexBased_OdeSolver(x0, ModelPropList, Data)


% param = ModelProp;

% xm_0 = zeros(12,1);

% options = odeset('Abstol',[1;1;1;1e6;1e6;1e6;1e6;1;1;1;1e6;1e6;1e6;1e6]*1e-6);
options = odeset('Abstol',1e-6);
% options = odeset('reltol',1e-6,'Abstol',1e-6);
options = odeset('reltol',1e-6,'Abstol',1e-6);


% tspan = linspace(0, T_final,length(0:0.001:T_final));
% tspan = 0:0.001:T_final;
% tspan = (param.t)';

% tspan = [param.t(1) param.t(end)];

T_init = Data(1,1);
T_final = Data(end,1);

tspan = [T_init T_final];
% tspan = T_init:0.001:T_final;


[t,x] = ode45(@BatFunc_MinimalHover_4DoA,tspan,x0,options, ModelPropList, Data);
end