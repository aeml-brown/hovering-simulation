% h=figure('Name','Power','position',[-1200 100 1100 650],'color','white'); hold on
figure(4); hold on
% PowerData = PowerData_m34;
PowerData2 = PowerData(abs(PowerData(:,9)+65)<1,:);
% Aw = param.b * 0.0447; % General Hummingbird
% Aw = param.b * 0.0525; % Anna
% Aw = param.b * 0.0745; % Mellivora
% Aw = param.b * 0.0429; % Mulsant
c_bar = param.b;
s_bar = max(xx(:,7));
Aw = c_bar * s_bar;
Rof = param.Rof;
mg = (param.Mb+2*param.mw) * 9.81;
a = sqrt((Rof*Aw)/(mg)^3);
b = sqrt(Rof*c_bar*s_bar^3/(mg));
AR = s_bar / c_bar;
for psi = 60:-10:60
    phi0 = psi*pi/180;
    ind = find(abs(PowerData2(:,7)-phi0)<1e-4);
%     subplot(1,2,1); 
%     plot(PowerData2(ind,8),PowerData2(ind,12).*PowerData2(ind,4),'-','linewidth',2); hold on
    
%     subplot(1,2,2); 
%     plot3(PowerData2(ind,4)*b,(c_bar/s_bar)*ones(size(PowerData2(ind,4))),PowerData2(ind,12).*PowerData2(ind,4)*a,'-.b','linewidth',2); hold on
    plot(PowerData2(ind,4)*b,PowerData2(ind,12).*PowerData2(ind,4)*a,'-b','linewidth',2); hold on
    text((PowerData2(ind(end),4))*b,(PowerData2(ind(end),12).*PowerData2(ind(end),4))*a,num2str(AR))
% plot(PowerData(ind,4),PowerData(ind,11),'-*'); hold on
end

% view(0,0)
% xlim([20 80])
% ylim([0.1 0.35])
% save2pdf('MechWrk_Flp_Frq_Normalized_All.pdf',figure(4),1200);

%%
clear all;

h=figure('Name','Power','position',[-1200 100 1100 650],'color','white'); hold on; grid on
FileName_1 = 'PowerData_Hummingbird_Anna_Pro65_03-24-2016-v1';
FileName_2 = 'PowerData_hummingbird_Mellivora_Pro65_4-22-2016-v1';
% FileName_3 = 'PowerData_hummingbird_Mellivora_AR3_5-17-2016-v1';
% FileName_4 = 'PowerData_hummingbird_Mellivora_AR5_5-17-2016-v1';
FileName_3 = 'PowerData_m34-03-17-2016-v1';
FileName_4 = 'PowerData_hummingbird_Mellivora_AR3_5-17-2016-v1';
FileName_5 = 'PowerData_hummingbird_Mellivora_AR5_5-17-2016-v1';

psi90 = [];
psi80 = [];
psi70 = [];
psi60 = [];

for i = 1:5
    
    if i==1
        load (FileName_1);
        PowerData_1 = PowerData(abs(PowerData(:,9)+65)<1,:);
        
        c_bar = param.b;
        s_bar = max(xx(:,7));
        Aw = c_bar * s_bar;
        Rof = param.Rof;
        mg = (param.Mb+2*param.mw) * 9.81;
        a = sqrt((Rof*Aw)/(mg)^3);
        b = sqrt(Rof*c_bar*s_bar^3/(mg));
        AR = s_bar/ c_bar;
        
        for psi = 90:-10:60
            phi0 = psi*pi/180;
            ind = find(abs(PowerData_1(:,7)-phi0)<1e-4);
            if psi==90
                psi90 = [psi90;[PowerData_1(ind,4)*b,AR*ones(size(PowerData_1(ind,4))),PowerData_1(ind,12).*PowerData_1(ind,4)*a]];
            elseif psi==80
                psi80 = [psi80;[PowerData_1(ind,4)*b,AR*ones(size(PowerData_1(ind,4))),PowerData_1(ind,12).*PowerData_1(ind,4)*a]];
            elseif psi==70
                psi70 = [psi70;[PowerData_1(ind,4)*b,AR*ones(size(PowerData_1(ind,4))),PowerData_1(ind,12).*PowerData_1(ind,4)*a]];
            elseif psi==60
                psi60 = [psi60;[PowerData_1(ind,4)*b,AR*ones(size(PowerData_1(ind,4))),PowerData_1(ind,12).*PowerData_1(ind,4)*a]];
            end
        end
    
    
    elseif i==2
        load (FileName_2);
        PowerData_2 = PowerData(abs(PowerData(:,9)+65)<1,:);
        
        c_bar = param.b;
        s_bar = max(xx(:,7));
        Aw = c_bar * s_bar;
        Rof = param.Rof;
        mg = (param.Mb+2*param.mw) * 9.81;
        a = sqrt((Rof*Aw)/(mg)^3);
        b = sqrt(Rof*c_bar*s_bar^3/(mg));
        AR = s_bar/ c_bar;
        
        for psi = 90:-10:60
            phi0 = psi*pi/180;
            ind = find(abs(PowerData_2(:,7)-phi0)<1e-4);
            if psi==90
                psi90 = [psi90;[PowerData_2(ind,4)*b,AR*ones(size(PowerData_2(ind,4))),PowerData_2(ind,12).*PowerData_2(ind,4)*a]];
            elseif psi==80
                psi80 = [psi80;[PowerData_2(ind,4)*b,AR*ones(size(PowerData_2(ind,4))),PowerData_2(ind,12).*PowerData_2(ind,4)*a]];
            elseif psi==70
                psi70 = [psi70;[PowerData_2(ind,4)*b,AR*ones(size(PowerData_2(ind,4))),PowerData_2(ind,12).*PowerData_2(ind,4)*a]];
            elseif psi==60
                psi60 = [psi60;[PowerData_2(ind,4)*b,AR*ones(size(PowerData_2(ind,4))),PowerData_2(ind,12).*PowerData_2(ind,4)*a]];
            end
        end
        
    elseif i==3
        load (FileName_3);
        PowerData_3 = PowerData(abs(PowerData(:,9)+65)<1,:);
        
        c_bar = param.b;
        s_bar = max(xx(:,7));
        Aw = c_bar * s_bar;
        Rof = param.Rof;
        mg = (param.Mb+2*param.mw) * 9.81;
        a = sqrt((Rof*Aw)/(mg)^3);
        b = sqrt(Rof*c_bar*s_bar^3/(mg));
        AR = s_bar/ c_bar;
        
        for psi = 90:-10:60
            phi0 = psi*pi/180;
            ind = find(abs(PowerData_3(:,7)-phi0)<1e-4);
            if psi==90
                psi90 = [psi90;[PowerData_3(ind,4)*b,AR*ones(size(PowerData_3(ind,4))),PowerData_3(ind,12).*PowerData_3(ind,4)*a]];
            elseif psi==80
                psi80 = [psi80;[PowerData_3(ind,4)*b,AR*ones(size(PowerData_3(ind,4))),PowerData_3(ind,12).*PowerData_3(ind,4)*a]];
            elseif psi==70
                psi70 = [psi70;[PowerData_3(ind,4)*b,AR*ones(size(PowerData_3(ind,4))),PowerData_3(ind,12).*PowerData_3(ind,4)*a]];
            elseif psi==60
                psi60 = [psi60;[PowerData_3(ind,4)*b,AR*ones(size(PowerData_3(ind,4))),PowerData_3(ind,12).*PowerData_3(ind,4)*a]];
            end
        end
        
    elseif i==4
        load (FileName_4);
        PowerData_4 = PowerData(abs(PowerData(:,9)+65)<1,:);
        
        c_bar = param.b;
        s_bar = max(xx(:,7));
        Aw = c_bar * s_bar;
        Rof = param.Rof;
        mg = (param.Mb+2*param.mw) * 9.81;
        a = sqrt((Rof*Aw)/(mg)^3);
        b = sqrt(Rof*c_bar*s_bar^3/(mg));
        AR = s_bar/ c_bar;
        
        for psi = 90:-10:60
            phi0 = psi*pi/180;
            ind = find(abs(PowerData_4(:,7)-phi0)<1e-4);
            if psi==90
                psi90 = [psi90;[PowerData_4(ind,4)*b,AR*ones(size(PowerData_4(ind,4))),PowerData_4(ind,12).*PowerData_4(ind,4)*a]];
            elseif psi==80
                psi80 = [psi80;[PowerData_4(ind,4)*b,AR*ones(size(PowerData_4(ind,4))),PowerData_4(ind,12).*PowerData_4(ind,4)*a]];
            elseif psi==70
                psi70 = [psi70;[PowerData_4(ind,4)*b,AR*ones(size(PowerData_4(ind,4))),PowerData_4(ind,12).*PowerData_4(ind,4)*a]];
            elseif psi==60
                psi60 = [psi60;[PowerData_4(ind,4)*b,AR*ones(size(PowerData_4(ind,4))),PowerData_4(ind,12).*PowerData_4(ind,4)*a]];
            end
        end
        
    elseif i==5
        load (FileName_5);
        PowerData_5 = PowerData(abs(PowerData(:,9)+65)<1,:);
        
        c_bar = param.b;
        s_bar = max(xx(:,7));
        Aw = c_bar * s_bar;
        Rof = param.Rof;
        mg = (param.Mb+2*param.mw) * 9.81;
        a = sqrt((Rof*Aw)/(mg)^3);
        b = sqrt(Rof*c_bar*s_bar^3/(mg));
        AR = s_bar/ c_bar;
        
        for psi = 90:-10:60
            phi0 = psi*pi/180;
            ind = find(abs(PowerData_5(:,7)-phi0)<1e-4);
            if psi==90
                psi90 = [psi90;[PowerData_5(ind,4)*b,AR*ones(size(PowerData_5(ind,4))),PowerData_5(ind,12).*PowerData_5(ind,4)*a]];
            elseif psi==80
                psi80 = [psi80;[PowerData_5(ind,4)*b,AR*ones(size(PowerData_5(ind,4))),PowerData_5(ind,12).*PowerData_5(ind,4)*a]];
            elseif psi==70
                psi70 = [psi70;[PowerData_5(ind,4)*b,AR*ones(size(PowerData_5(ind,4))),PowerData_5(ind,12).*PowerData_5(ind,4)*a]];
            elseif psi==60
                psi60 = [psi60;[PowerData_5(ind,4)*b,AR*ones(size(PowerData_5(ind,4))),PowerData_5(ind,12).*PowerData_5(ind,4)*a]];
            end
        end
        
    end
    
        
    
end

for psi = 60:-10:60
Var = eval(['psi' num2str(psi)]);
x = Var(:,1);
y = Var(:,2);
z = Var(:,3);

tri = delaunay(x,y);
% plot(x,y,'.')


% How many triangles are there?

[r,c] = size(tri);
% disp(r)

% Plot it with TRISURF

C = (y);

h = trisurf(tri, x, y, z, C); hold on
% axis vis3d
view(0,0)
% surface(psi70(:,1),psi70(:,2),psi70(:,3)); hold on

% Clean it up

% axis off
% l = light('Position',[-50 -15 29])
% set(gca,'CameraPosition',[208 -50 7687])
% lighting phong
shading interp
colorbar EastOutside
end
xlim([0.1 0.6])
ylim([3 5])
zlim([0.4 0.7])