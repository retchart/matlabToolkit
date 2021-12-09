%% 拟合求峰面积
clear;close all;
matNames = {'4849','4866','4811','5211','5042','5028'};
pks = [1700]; % Au411
% matNames = {'BrA','BrB','BrC','BrD','BrE','BrF'};
% pks = [2277,3177]; %,Br554,Br776keV
for i = 1:length(matNames)
    load(matNames{i});
    thisSpec = sum(orgnSpec,2);
    mkdir([matNames{i},'-fitpeaks']);
    tlive(i,1)=sum(t_live);
    treal(i,1)=t(end)+t(2)-t(1);
    for j = 1:length(pks)
        roi=[round(pks(j)-0.01*pks(j)):round(pks(j)+0.01*pks(j))];
        [h,area(i,2*j-1),area(i,2*j),~,~,~] = fitPeak(roi,thisSpec(roi),0);
%         area(i,2*j-1) = area(i,2*j-1)/tlive(i,1)*treal(i,1);
%         area(i,2*j) = area(i,2*j)/tlive(i,1)*treal(i,1);
        saveas(h,[matNames{i},'-fitpeaks\',num2str(pks(j))],'jpg');
    end
    total(i,1) = sum(sum(orgnSpec))/sum(t_live);
end
