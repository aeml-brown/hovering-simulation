
clear all

m = 45;

load ((['.\Data\General\PowerData_m' num2str(m) '-03-17-2016-v1']));

PowerData_Var = eval(['PowerData_m' num2str(m)]);


proAng =unique(PowerData_Var(:,9));

h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
pro = -65;
% for i = proAng
    phi = unique(PowerData_Var(:,7));
    
for j = 1:length(phi)

    ind = find(PowerData_Var(:,9)==pro);
    ind2 = find(PowerData_Var(ind,7)==phi(j));
    if isempty(ind2)
        continue;
    end
    subplot(1,2,1);

    plot(PowerData_Var(ind(ind2),8),PowerData_Var(ind(ind2),12).*PowerData_Var(ind(ind2),4),'-b','linewidth',2); hold on
    text(PowerData_Var(ind(ind2(end)),8),PowerData_Var(ind(ind2(end)),12).*PowerData_Var(ind(ind2(end)),4),num2str(phi(j)*180/pi))
    xlabel('Flapping angle [^\circ]');
    ylabel('Mechanical Work [J/s]');

    subplot(1,2,2);
    plot(PowerData_Var(ind(ind2),4),PowerData_Var(ind(ind2),12).*PowerData_Var(ind(ind2),4),'-b','linewidth',2); hold on
    text(PowerData_Var(ind(ind2(end)),4),PowerData_Var(ind(ind2(end)),12).*PowerData_Var(ind(ind2(end)),4),num2str(phi(j)*180/pi))
    xlabel('Flapping frequency [Hz]');
    ylabel('Mechanical Work [J/s]');

end
% end

%%
clear all
h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
for m = [34 45 55]
    
load ((['.\Data\General\PowerData_m' num2str(m) '-03-17-2016-v1']));
PowerData_Var = eval(['PowerData_m' num2str(m)]);
proAng =unique(PowerData_Var(:,9));

phi = unique(PowerData_Var(:,7));

for i = 7:-1:1
phi0 = phi(i);

for j = 1:length(proAng)

    ind = find(PowerData_Var(:,7)==phi0);
    ind2 = find(PowerData_Var(ind,9)==proAng(j));
    if isempty(ind2)
        continue;
    end

%     plot(PowerData_m34(ind(ind2),4),PowerData_m34(ind(ind2),12).*PowerData_m34(ind(ind2),4),'-*b'); hold on
%     text(PowerData_m34(ind(ind2(end)),4),PowerData_m34(ind(ind2(end)),12).*PowerData_m34(ind(ind2(end)),4),num2str(proAng(j)))
%     if i==7
%         colorindex = 'b';
%     elseif i==5
%         colorindex = 'g';
%     elseif i==3
%         colorindex = 'r';
%     end
    if m==34
        colorindex = 'ob';
        sizeindex = 2;
    elseif m==45
        colorindex = 'sg';
        sizeindex = 1;
    elseif m==55
        colorindex = '.r';
        sizeindex = 1;
    end
    SF = ((m*0.1)*1e-3*9.81)^(3/2);
    SF_min = ((34*0.1)*1e-3*9.81)^(3/2);
%     SF = 1;
    plot(-PowerData_Var(ind(ind2),9),PowerData_Var(ind(ind2),12).*PowerData_Var(ind(ind2),4)./SF,colorindex,'linewidth',sizeindex); hold on
    
    xlim([0 80]);
    ylim([0 1/SF_min]);
    xlabel('Pronation angle amplitude [\circ]');
    ylabel('Specific power [W/BW^(3/2)]');
end
end
end
legend('m=3.4 gram','m=4.5 gram','m=5.5 gram')



%%


clear all
h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
for m = [34 45 55]
    
load ((['.\Data\General\PowerData_m' num2str(m) '-03-17-2016-v1']));
PowerData_Var = eval(['PowerData_m' num2str(m)]);
proAng =unique(PowerData_Var(:,9));

phi = unique(PowerData_Var(:,7));

for i = 7:-1:1
phi0 = phi(i);


    ind = find(PowerData_Var(:,7)==phi0);
    if isempty(ind)
        continue;
    end

%     plot(PowerData_m34(ind(ind2),4),PowerData_m34(ind(ind2),12).*PowerData_m34(ind(ind2),4),'-*b'); hold on
%     text(PowerData_m34(ind(ind2(end)),4),PowerData_m34(ind(ind2(end)),12).*PowerData_m34(ind(ind2(end)),4),num2str(proAng(j)))
%     if i==7
%         colorindex = 'b';
%     elseif i==5
%         colorindex = 'g';
%     elseif i==3
%         colorindex = 'r';
%     end
    if m==34
        colorindex = 'ob';
        sizeindex = 2;
    elseif m==45
        colorindex = 'sg';
        sizeindex = 1;
    elseif m==55
        colorindex = '.r';
        sizeindex = 1;
    end
        
    plot(-PowerData_Var(ind,9)+PowerData_Var(ind,5),PowerData_Var(ind,12).*PowerData_Var(ind,4),colorindex,'linewidth',sizeindex); hold on
    
    xlim([0 80]);
    ylim([0 1]);
    xlabel('Pronation angle amplitude [\circ]');
    ylabel('Mechanical Work [J/s]');
end
end
legend('m=3.4 gram','m=4.5 gram','m=5.5 gram')

%%

clear all
load PowerData_Glossophaga_mw10-03-18-2016-v1
% figure(1); hold on
% plot(-PowerData(:,9),PowerData(:,12).*PowerData(:,4),'.r')



PowerData_Var = eval(['PowerData']);


proAng =unique(PowerData_Var(:,9));

figure(1);hold on
% h=figure('Name','Internal forces','position',[-1200 100 1100 650],'color','white'); hold on; grid on
pro = -60;
% for i = proAng
    phi = unique(PowerData_Var(:,7));
    
for j = 1:length(phi)

    ind = find(PowerData_Var(:,9)==pro);
    ind2 = find(PowerData_Var(ind,7)==phi(j));
    if isempty(ind2)
        continue;
    end
    subplot(1,2,1); grid on 

    plot(PowerData_Var(ind(ind2),8),PowerData_Var(ind(ind2),12).*PowerData_Var(ind(ind2),4),'--g','linewidth',1); hold on
%     text(PowerData_Var(ind(ind2(end)),8),PowerData_Var(ind(ind2(end)),12).*PowerData_Var(ind(ind2(end)),4),num2str(phi(j)*180/pi))
    xlabel('Flapping angle [^\circ]');
    ylabel('Mechanical Work [J/s]');
%     xlim([0 90])
    ylim([0 1])

    subplot(1,2,2); grid on
    plot(PowerData_Var(ind(ind2),4),PowerData_Var(ind(ind2),12).*PowerData_Var(ind(ind2),4),'--g','linewidth',1); hold on
%     text(PowerData_Var(ind(ind2(end)),4),PowerData_Var(ind(ind2(end)),12).*PowerData_Var(ind(ind2(end)),4),num2str(phi(j)*180/pi))
    xlabel('Flapping frequency [Hz]');
    ylabel('Mechanical Work [J/s]');
%     xlim([0 45])
    ylim([0 1])

end
