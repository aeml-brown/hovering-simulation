function Animate_perspective(t,x,Data_R,Data_L,BodyAngle,f_total,param,Video)


Rx = @(phi) [1,0,0;0,cos(phi),sin(phi);0,-sin(phi),cos(phi)];
Ry = @(th) [cos(th),0,-sin(th);0,1,0;sin(th),0,cos(th)];
Rz = @(psi) [cos(psi),sin(psi),0;-sin(psi),cos(psi),0;0,0,1];
    





h = figure;
% set(gcf,'position',[100 100 1500 500]);hold on
set(gcf,'position',[100 100 1100 500],'color','w');hold on
% view(95,25);


VideoName = Video.Name;
VideoOn = Video.Swtch;

for j = 1:1
    


if VideoOn == 1

% PdfFileName = 'ForwardSpeed_PitchAndRoll_woAir';
% PdfFileName = 'forwrd';
aviobj = VideoWriter([VideoName '.avi'],'Motion JPEG AVI');
open(aviobj);

end

for i = 1:length(t)


xc = x(i,1);
yc = x(i,2);
zc = x(i,3);
phi = x(i,4);
th = x(i,5);
psi = x(i,6);
tt = Data_R(i,1);
flpr = Data_R(i,3);
pror = Data_R(i,2)*1;
swpr = Data_R(i,4)*1;
length_r = Data_R(i,5) * 0.3;
flpl = Data_L(i,3);
prol = Data_L(i,2)*1;
swpl = Data_L(i,4)*1;
length_l = Data_L(i,5) * 0.3;

% Size_scale = 0.125/length_l;
Size_scale = 2.5;

Bb = 0.05*Size_scale;
b = 0.015*Size_scale;
length_r = length_r*Size_scale;
length_l = length_l*Size_scale;

p_CoM_Global = [xc;yc;zc];

p_R1_Local = [0;b/2;0];
Rwr = Rz(-swpr)*Ry(-flpr)*Rx(-pror);
R0 = Rz(-psi) * Ry(-th) * Rx(-phi);
% p_R1_Global = p_CoM_Global + R0 * Rwr * p_R1_Local;
p1_r = p_CoM_Global + R0 * Rwr * p_R1_Local;

p_R2_Local = [length_r;b/2;0];
% p_R2_Global = p_CoM_Global + R0 * Rwr * p_R2_Local;
p2_r = p_CoM_Global + R0 * Rwr * p_R2_Local;

p_R3_Local = [0;-b/2;0];
% p_R3_Global = p_CoM_Global + R0 * Rwr * p_R3_Local;
p3_r = p_CoM_Global + R0 * Rwr * p_R3_Local;

p_R4_Local = [length_r;-b/2;0];
% p_R4_Global = p_CoM_Global + R0 * Rwr * p_R4_Local;
p4_r = p_CoM_Global + R0 * Rwr * p_R4_Local;

p_L1_Local = [0;b/2;0];
Rwl = Rz(-swpl)*Ry(-flpl)*Rx(-prol);
R0 = Rz(-psi) * Ry(-th) * Rx(-phi);
% p_L1_Global = p_CoM_Global + R0 * Rwl * p_L1_Local;
p1_l = p_CoM_Global + R0 * Rwl * p_L1_Local;

p_L2_Local = [-length_l;b/2;0];
% p_L2_Global = p_CoM_Global + R0 * Rwl * p_L2_Local;
p2_l = p_CoM_Global + R0 * Rwl * p_L2_Local;

p_L3_Local = [0;-b/2;0];
% p_L3_Global = p_CoM_Global + R0 * Rwl * p_L3_Local;
p3_l = p_CoM_Global + R0 * Rwl * p_L3_Local;

p_L4_Local = [-length_l;-b/2;0];
% p_L4_Global = p_CoM_Global + R0 * Rwl * p_L4_Local;
p4_l = p_CoM_Global + R0 * Rwl * p_L4_Local;



% 
p0_b = [xc;yc;zc];
p1_b = [xc;yc;zc] + (R0)*[0;Bb/2;0];
p2_b = [xc;yc;zc] + (R0)*[0;-Bb/2;0];
% 
p3_b = [xc;yc;zc] + (R0)*[0.0125;0;0]*4;
p4_b = [xc;yc;zc] + (R0)*[-0.0125;0;0]*4;
p5_b = [xc;yc;zc] + (R0)*[0;0;0.0125]*4;
% 

subplot(2,10,[1:3 11:13]); hold on
view(95,25);
% view(180,10);


t1=0:0.001:0.002;
temp = plot3(t1,sin(t1),cos(t1));
axis equal
axis off
xlim([-.15 0.15]);
% ylim([min(x(:,2))-.1 max(x(:,2))+0.1]);
zlim([min(x(:,2))-.1 max(x(:,2))+0.1]);

% xlim([(x(i,1))-.15 (x(i,1))+0.15]);
% ylim([(x(i,2))-.5 (x(i,2))+0.1]);
% ylim([min(x(i,1))-.3 max(x(i,1))+0.1]);
ylim([min(x(i,1))-.1 max(x(i,1))+0.1]);
% zlim([(x(i,3))-.1 (x(i,3))+0.1]);
% title('Perspective view');
% set(gca,'xTick',[],'yTick',[],'zTick',[])
% axis off;
plot3(xc,yc,zc,'.k','Markersize',5);
% legend(['Time=' num2str(tt)]);
uicontrol('Style', 'text',...
       'String', ['Time=' num2str(floor(t(i)*1000)/1000)],... %replace something with the text you want
       'Units','normalized',...
       'Fontsize',14,...
       'Position', [0.05 0.85 0.1 0.1]); 

   
v = sqrt(x(i,7)^2+x(i,8)^2+x(i,9)^2);
uicontrol('Style', 'text',...
       'String', ['V=' num2str(floor(v*1000)/1000)],... %replace something with the text you want
       'Units','normalized',...
       'Fontsize',14,...
       'Position', [0.05 0.8 0.1 0.1]);  
   
f = param.f;
uicontrol('Style', 'text',...
       'String', ['f=' num2str(floor(f*10)/10) '  Hz'],... %replace something with the text you want
       'Units','normalized',...
       'Fontsize',14,...
       'Position', [0.05 0.75 0.1 0.1]);    
   
   
    
if i>1    
    delete([H00;H0;F0;F1;B0;B_ax1;B_ax3;l4;l8]);
end

X = [p1_l(1);p2_l(1);p4_l(1);p3_l(1)];
Y = [p1_l(2);p2_l(2);p4_l(2);p3_l(2)];
Z = [p1_l(3);p2_l(3);p4_l(3);p3_l(3)];
F0 = fill3(X,Y,Z,[0.5 0.5 1]);
alpha(0.4)

X = [p1_r(1);p2_r(1);p4_r(1);p3_r(1)];
Y = [p1_r(2);p2_r(2);p4_r(2);p3_r(2)];
Z = [p1_r(3);p2_r(3);p4_r(3);p3_r(3)];
F1 = fill3(X,Y,Z,[1 0.5 0.5]);
% alpha(0.4)
% drawnow

H00 = plot3(p1_b(1),p1_b(2),p1_b(3),'.g','MarkerSize',30);
B0 = line('XData',[p1_b(1) p2_b(1)],'YData',[p1_b(2) p2_b(2)],'ZData',[p1_b(3) p2_b(3)],'Color','b','LineWidth',5);
% B1 = line('XData',[p3_b(1) p4_b(1)],'YData',[p3_b(2) p4_b(2)],'ZData',[p3_b(3) p4_b(3)],'Color','r','LineWidth',3);
H0 = plot3(p1_b(1),p1_b(2),p1_b(3),'.g','MarkerSize',30);
B_ax1 = line('XData',[p0_b(1) p3_b(1)],'YData',[p0_b(2) p3_b(2)],'ZData',[p0_b(3) p3_b(3)],'Color','g','LineWidth',2);
B_ax3 = line('XData',[p0_b(1) p5_b(1)],'YData',[p0_b(2) p5_b(2)],'ZData',[p0_b(3) p5_b(3)],'Color','r','LineWidth',2);
l4 = line('XData',[p3_r(1) p1_r(1)],'YData',[p3_r(2) p1_r(2)],'ZData',[p3_r(3) p1_r(3)],'Color','b','LineWidth',1);

l8 = line('XData',[p3_l(1) p1_l(1)],'YData',[p3_l(2) p1_l(2)],'ZData',[p3_l(3) p1_l(3)],'Color','b','LineWidth',1);




subplot(2,10,4:8); hold on
if i>1
    delete([pos_circ;F_line]);
end
plot(x(:,2)*1000,x(:,3)*1000,'-b','linewidth',1); hold on
pos_circ = plot(yc*1000,zc*1000,'or','linewidth',2); 
xlabel('x [mm]')
ylabel('y [mm]')


subplot(2,10,14:18); hold on
W = (param.Mb+2*param.mw)*param.g;
plot(t(:),f_total(:,1)/(W),'--b','linewidth',1); hold on; grid on
plot(t(:),f_total(:,2)/W,'-r','linewidth',1);
% F_line = line('XData',[t(i) t(i)],'YData',[1.05*min(min(f_total(:,1:2))) 1.05*max(max(f_total(:,1:2)))],'Color','r');
F_line = line('XData',[t(i) t(i)],'YData',[0.99*min(ylim) 0.99*max(ylim)],'Color','r');
xlabel('Time [s]')
ylabel('Force [BW]')
F_legend = legend ('Horizontal','Vertical','Location','southeast');
legend('boxoff');
% set(F_legend.box,'visible','off')
% Fy_circ = plot(t(i),f_total(i,1),'or','linewidth',2); hold on; grid on
% Fz_circ = plot(t(i),f_total(i,2),'or','linewidth',2);






subplot(2,10,[9:10 19:20]); hold on
axis off;
axis equal
xlim([0.4 0.6])
ylim([-0.1 0.25])

if i>1    
    delete([rlc1;glc1;rlc2;glc2]);
    delete([Ang1;Ang2]);
    
    
end



xc1 = 0.5;
yc1 = 0.15;
Rc1 = 0.05;
viscircles([xc1,yc1],Rc1);

pc1 = [xc1;yc1;0];
p1 = [xc1;yc1+Rc1;0];
p2 = [xc1+Rc1;yc1;0];

p1_crr = pc1+Rz(BodyAngle(i,2))*(p1-pc1);
p2_crr = pc1+Rz(BodyAngle(i,2))*(p2-pc1);

text(xc1+Rc1*1.5,yc1+Rc1*0.25,'Roll Angle');
Ang1 = text(p2_crr(1),p2_crr(2),[num2str(round(abs(BodyAngle(i,2))*180/pi)) '\circ'],'Rotation',-BodyAngle(i,2)*180/pi);


if i==1
    line('XData',[xc1 p1_crr(1)],'YData',[yc1 p1_crr(2)],'ZData',[0 p1_crr(3)],'Color',[1.0 0.5 0.5],'LineWidth',2);
    line('XData',[xc1 p2_crr(1)],'YData',[yc1 p2_crr(2)],'ZData',[0 p2_crr(3)],'Color',[0.5 1.0 0.5],'LineWidth',2);
end


rlc1 = line('XData',[xc1 p1_crr(1)],'YData',[yc1 p1_crr(2)],'ZData',[0 p1_crr(3)],'Color','r','LineWidth',2);
glc1 = line('XData',[xc1 p2_crr(1)],'YData',[yc1 p2_crr(2)],'ZData',[0 p2_crr(3)],'Color','g','LineWidth',2);


xc2 = 0.5;
yc2 = 0.0;
Rc2 = 0.05;
viscircles([xc2,yc2],Rc2);

pc2 = [xc2;yc2;0];
p1 = [xc2;yc2+Rc2;0];
p2 = [xc2+Rc2;yc2;0];

p1_crr = pc2+Rz(-BodyAngle(i,1))*(p1-pc2);
p2_crr = pc2+Rz(-BodyAngle(i,1))*(p2-pc2);

text(xc2+Rc2*1.5,yc2+Rc2*0.25,'Pitch Angle');
Ang2 = text(p2_crr(1),p2_crr(2),[num2str(round(abs(BodyAngle(i,1))*180/pi)) '\circ'],'Rotation',BodyAngle(i,1)*180/pi);

if i==1
    line('XData',[xc2 p2_crr(1)],'YData',[yc2 p2_crr(2)],'ZData',[0 p2_crr(3)],'Color',[0.5 0.5 1.0],'LineWidth',2);
    line('XData',[xc2 p1_crr(1)],'YData',[yc2 p1_crr(2)],'ZData',[0 p1_crr(3)],'Color',[1.0 0.5 0.5],'LineWidth',2);
end
rlc2 = line('XData',[xc2 p1_crr(1)],'YData',[yc2 p1_crr(2)],'ZData',[0 p1_crr(3)],'Color','r','LineWidth',2);
glc2 = line('XData',[xc2 p2_crr(1)],'YData',[yc2 p2_crr(2)],'ZData',[0 p2_crr(3)],'Color','b','LineWidth',2);



% subplot(2,1,2);
% hold on;
% title('Front view');
% 
% xlim([min(x(:,1))-.15 max(x(:,1))+0.15]);
% ylim([min(x(:,2))-.1 max(x(:,2))+0.1]);
% zlim([min(x(:,3))-.1 max(x(:,3))+0.1]);
% 
% % xlim([(x(i,1))-.15 (x(i,1))+0.15]);
% % ylim([(x(i,2))-.05 (x(i,2))+0.05]);
% % zlim([(x(i,3))-.15 (x(i,3))+0.15]);
% set(gca,'xTick',[],'yTick',[],'zTick',[])
% axis equal
% axis off;
% 
% view (179,2);
% if i>1    
% %     delete([F2;B0_2;B1_2;l1_2;l2_2;l3_2;l4_2;l5_2;l6_2;l7_2;l8_2]);
%     delete([H0_2;B0_2;B2_ax1;B2_ax3]);
%     
% end
% 
% 
% 
% p3_b = [xc;yc;zc] + (R0)*[0.0125;0;0]*1;
% p4_b = [xc;yc;zc] + (R0)*[-0.0125;0;0]*1;
% p5_b = [xc;yc;zc] + (R0)*[0;0;0.0125]*1;
% 
% 
% 
% B0_2 = line('XData',[p1_b(1) p2_b(1)],'YData',[p1_b(2) p2_b(2)],'ZData',[p1_b(3) p2_b(3)],'Color','b','LineWidth',5);
% % B1_2 = line('XData',[p3_b(1) p4_b(1)],'YData',[p3_b(2) p4_b(2)],'ZData',[p3_b(3) p4_b(3)],'Color','r','LineWidth',3);
% H0_2 = plot3(p1_b(1),p1_b(2),p1_b(3),'.g','MarkerSize',30);
% B2_ax1 = line('XData',[p0_b(1) p3_b(1)],'YData',[p0_b(2) p3_b(2)],'ZData',[p0_b(3) p3_b(3)],'Color','g','LineWidth',2);
% B2_ax3 = line('XData',[p0_b(1) p5_b(1)],'YData',[p0_b(2) p5_b(2)],'ZData',[p0_b(3) p5_b(3)],'Color','r','LineWidth',2);
% 

drawnow
% pause(0.1);
% pause;

if VideoOn == 1
    F = getframe(h);
    writeVideo(aviobj,F);
end


end

end

if VideoOn == 1
    close(aviobj);
end

end