x_0 = [State_space Control_param];


f = x_0(4);
t1 = 0;
tf = 1/f*1;

[Data_R,Data_L,ModelPropList,Wing_fn] = Hovering_fn(x_0,t1,tf);

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


err1 = max(abs(xx(end,[1:3 8:9])-xx(1,[1:3 8:9])));
err2 = max(abs(xx(end,10)-xx(1,10)));
err = max(100*err1,err2);




param = ModelProp(ModelPropList, Data_R);



f_int_total=[];
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


MechWrk_All = Power(:,:)*dt;
MechWrk_Postv = MechWrk_All;
MechWrk_Postv((MechWrk_Postv(:,:)<0)) = 0;
MechWrk_zeroNeg = sum(sum(MechWrk_Postv));
MechWrk_AlgebraicSum = sum(sum(MechWrk_All));

MechWrk_All1 = sum(MechWrk_All);
MechWrk_All1((MechWrk_All1(:)<0)) = 0;
MechWrk_AlgebraicSum4EachDoF = sum(MechWrk_All1);

wl = max(x(:,7));
BW = (param.Mb+2*param.mw)*param.g;
MechWrk_zeroNeg_Normlz = MechWrk_zeroNeg * sqrt((param.Rof*param.b*wl)/(BW^3)) * f;
MechWrk_AlgebraicSum_Normlz = MechWrk_AlgebraicSum * sqrt((param.Rof*param.b*wl)/(BW^3)) * f;
MechWrk_AlgebraicSum4EachDoF_Normlz = MechWrk_AlgebraicSum4EachDoF * sqrt((param.Rof*param.b*wl)/(BW^3)) * f;
f_star = f*sqrt((param.Rof*param.b*wl^3)/(BW));

disp([Control_param f MechWrk_zeroNeg_Normlz MechWrk_AlgebraicSum_Normlz err]);
disp([f_star MechWrk_zeroNeg_Normlz MechWrk_AlgebraicSum_Normlz MechWrk_AlgebraicSum4EachDoF_Normlz]);


% PowerData = [PowerData;[x_0 Tmax max((sum(MechWrk_Postv(:,:)')))/dt MechWrk]];




