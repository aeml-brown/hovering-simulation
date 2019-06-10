
OutputData_filtered = [];

for i = 1:length(OutputData(:,1))
    if OutputData(i,9)<1e-5 && OutputData(i,8)<=20
        OutputData_filtered = [OutputData_filtered;OutputData(i,:)];
    end
end

%%
for j = -20:10:20
    
    OutputData_filtered = [];

    for i = 1:length(OutputData(:,1))
        if OutputData(i,9)<1e-5 && OutputData(i,8)==j
            OutputData_filtered = [OutputData_filtered;OutputData(i,:)];
        end
    end
    
    figure(1);
    subplot(1,2,1)
    plot(OutputData_filtered(:,6),OutputData_filtered(:,5),'*','color',[(j+20)*abs(j)/800 (20-j)*abs(j)/800 (j+20)*(20-j)/400]); hold on
    xlim([0 90])
    ylim([0 100])
    subplot(1,2,2)
    plot(OutputData_filtered(:,7),OutputData_filtered(:,5),'*','color',[(j+20)*abs(j)/800 (20-j)*abs(j)/800 (j+20)*(20-j)/400]); hold on
    xlim([-90 0])
    ylim([0 100])
    
    figure(2)
    plot(OutputData_filtered(:,5),OutputData_filtered(:,1)*180/pi,'*','color',[(j+20)*abs(j)/800 (20-j)*abs(j)/800 (j+20)*(20-j)/400]);  hold on
    

end

%%


% figure
% plot3(OutputData_filtered(:,7),OutputData_filtered(:,6),OutputData_filtered(:,5),'or');

F = scatteredInterpolant(OutputData_filtered(:,7),OutputData_filtered(:,6),OutputData_filtered(:,5));

% for xm = min(OutputData_filtered(:,7)):1:max(OutputData_filtered(:,7))
%     for ym = min(OutputData_filtered(:,6)):1:max(OutputData_filtered(:,6))
%         plot3(xm,ym,F(xm,ym),'.r'); hold on
%     end 
% end

figure;
xm = min(OutputData_filtered(:,7)):1:max(OutputData_filtered(:,7));
ym = min(OutputData_filtered(:,6)):1:max(OutputData_filtered(:,6));
[X,Y] = meshgrid (xm,ym);
        surf(X,Y,F(X,Y),'EdgeColor','none'); hold on
        contour(X,Y,F(X,Y),10); hold on

