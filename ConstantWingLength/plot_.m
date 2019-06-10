% figure;
% power2 = power;
% h=figure('position',[0 100 1100 650],'color','white'); hold on; 
power2 = [];
for i = 1:length(power)
    if power(i,5)>0.001
        continue;
    end
power2=[power2;power(i,:)];
end
for i = 85:-5:65
    ind = find(abs(power2(:,1)-i)<0.1);
plot(power2(ind,6),power2(ind,7),'.'); hold on
end

xlabel('f^{*}')
ylabel('P^*')

%%


% figure;
% power2 = power;
% h=figure('position',[0 100 1100 650],'color','white'); hold on; 

power = [];
power = OutputData_ModifiedRound5;
power2 = [];
for i = 1:length(power)
    if power(i,10)>0.001
        continue;
    end
power2=[power2;power(i,:)];
end

for i = 70:-5:70
    ind = find(abs(power2(:,7)*180/pi-i)<0.1);
    plot(power2(ind,11),power2(ind,13)); hold on
end

xlabel('f^{*}')
ylabel('P^*')
