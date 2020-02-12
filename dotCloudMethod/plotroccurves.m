function handle = plotroccurves(roc,detectionTime)
% plot ROC curves
%
% Inputs:
% roc: Structure of roc for different measure time
% detectionTime: Which detection time are plotted
%
% Output:
% handle: plot handle

handle = -1;
lineWidth = 2;fontSize = 12;
iLine = 1;
lineType = {':','-.','--','-','x-'};
figure;
for iTime = detectionTime
    if iLine<=length(lineType)
        handle = plot(roc{iTime,1}(:,2),roc{iTime,1}(:,1),lineType{iLine},'LineWidth',lineWidth);hold on;
    else
        handle = plot(roc{iTime,1}(:,2),roc{iTime,1}(:,1),'-','LineWidth',lineWidth);hold on;
    end
    legendText{iLine} = [num2str(iTime),' s'];
    iLine = iLine + 1;
end
plot([0,1],[0,1],'k-');
set(gca,'FontSize',fontSize);
title('Receiver operating characteristic(ROC) curve','fontsize',fontSize);
xlabel('False positive rate (FPR)','fontsize',fontSize);
ylabel('True positive rate (TPR)','fontsize',fontSize);
axis equal;xlim([0 1]);ylim([0 1]);grid on;
legend(legendText,'Location','southeast','fontsize',fontSize);
hold off;
end

