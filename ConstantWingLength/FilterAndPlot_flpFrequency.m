% ind45 = find(abs(OutputData_extended(:,1)-0.0045)<0.0001);
% ind55 = find(abs(OutputData_extended(:,1)-0.0055)<0.0001);
% 
% OutputData_m45 = OutputData_extended(ind45,2:12);
% OutputData_m55 = OutputData_extended(ind55,2:12);

OutputData_m34_filtered = [];
OutputData_m45_filtered = [];
OutputData_m55_filtered = [];

for i = 1:max([length(OutputData_m34);length(OutputData_m45);length(OutputData_m55)])
    if i<length(OutputData_m34)
        if OutputData_m34(i,10)<5e-4
            OutputData_m34_filtered = [OutputData_m34_filtered;OutputData_m34(i,:)];
        end
        
    end
    if i<length(OutputData_m45)
        if OutputData_m45(i,10)<5e-4
            OutputData_m45_filtered = [OutputData_m45_filtered;OutputData_m45(i,:)];
        end
        
    end
    if i<length(OutputData_m55)
        if OutputData_m55(i,10)<5e-4
            OutputData_m55_filtered = [OutputData_m55_filtered;OutputData_m55(i,:)];
        end
    end
    
end


%%
clear all
load (['.\Data\General\PowerData_m34-03-17-2016-v1'])

figure(1); hold on; grid on
for j = [34 45 55]
Var_name = eval(['OutputData_m' num2str(j) '_filtered']);
flpAng = 90:-5:15;

Flp_f_Mw = [];
for i = flpAng
    ind = find(Var_name(:,8)==i);
    ind2 = find(Var_name(ind,4)==min(Var_name(ind,4)));
%     plot(OutputData_filtered(ind(ind2),9),OutputData_filtered(ind(ind2),5),'*b'); hold on
    Flp_f_Mw = [Flp_f_Mw;[Var_name(ind(ind2),8),Var_name(ind(ind2),4)]];
end

if j==34
    lineType = ':b';
    linesize = 2;
elseif j==45
    lineType = '--g';
    linesize = 2;
else
    lineType = '-.r';
    linesize = 2;
end

plot(Flp_f_Mw(:,1),Flp_f_Mw(:,2)./(sqrt(j*0.1*1e-3*9.81)),lineType,'linewidth',linesize); hold on

end

xlim([30 90]);
ylim([100 425]);
xlabel('Flapping angle [\circ]')
ylabel('Normalized frequency [Hz/BW]')
save2pdf('Flp_f_Mb.pdf',figure(1),1200)