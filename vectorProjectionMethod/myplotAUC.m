% 做AUC图
% 实用变量：aucList,sampleName,COMBINED_CH,TEST_DETECTION_TIME
clear;close all;
load('aucDataMessPack_all_time.mat');
iTime = 1;

AUCproductList = ones(length(COMBINED_CH),length(sampleName));
for rowrow = 1:3
    for colcol = 1:2
        thisList = aucList{iTime,rowrow,colcol};
        AUCproductList = AUCproductList.*thisList;
        thisTime = TEST_DETECTION_TIME(iTime);
        figure;
        for i = 1:6 % 6个Fisher向量
            if i == rowrow+colcol*3-3
                plot(COMBINED_CH,thisList(:,i),'.-','LineWidth',2,'MarkerSize',20);hold on;
            else
                plot(COMBINED_CH,thisList(:,i),'.-');hold on;
            end
            xlim([0,200]);
            ylim([0.5,1]);
            grid on;
            xlabel('Count of combined channels');
            ylabel('AUC');
            legend(sampleName);
        end
    end
end

figure;
plot(COMBINED_CH,AUCproductList,'.-','LineWidth',2,'MarkerSize',20);hold on;
xlim([0,200]);
grid on;
xlabel('Count of combined channels');
ylabel('Product of 6 AUCs');
title(['Detection time: ',num2str(TEST_DETECTION_TIME(iTime)),' s']);
legend(sampleName,'Location','southeast');
