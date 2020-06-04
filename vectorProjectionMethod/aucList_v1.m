function [aucList,handle] = aucList_v1(bkgd,smpl,whichPlace,sampleName,combinedCh,timeCombined,plotOrNot)
% 作图，横轴为合并道数，纵轴为AUC，线的数量为smpl的元胞数
%
% INPUTS:
% bkgd: 无毒品能谱，数值矩阵
% smpl：不同元素为数值矩阵，行数一致且与bkgd相同，元胞数组
% whichPlace: 画哪个位置的识别效果AUC曲线簇，1*2数值矩阵
% sampleName: 图例的标题，单列元胞数组
% combinedCh：图中横轴为多少道合为一道，列向量
% timeCombined: 每个能谱是多长时间的测量
% plotOrNot: 是否画图，1是，2否
%
% OUTPUTS:
% aucList: 每一行为同样合并道数下使用不同位置的fisher向量的AUC，每一列为使用
%          同一位置的Fisher向量，不同合并道数的AUC
% handle: auc曲线簇图的handle
%
lineWidth = 2;fontSize = 12;markerSize = 20;
aucList = zeros(length(combinedCh),length(sampleName));
handle = -1;
thisSample = smpl{whichPlace(1),whichPlace(2)};
for i = 1:size(smpl,1)*size(smpl,2)
    for j = 1:length(combinedCh)
        thisBKGD = resizemat_cut(bkgd,[floor(size(bkgd,1)/combinedCh(j)),floor(size(bkgd,2)/timeCombined)]);
        thisFisherSample = resizemat_cut(smpl{i},[floor(size(smpl{i},1)/combinedCh(j)),floor(size(smpl{i},2)/timeCombined)]);
        thisSMPL = resizemat_cut(thisSample,[floor(size(thisSample,1)/combinedCh(j)),floor(size(thisSample,2)/timeCombined)]);
        vec = myfisher(thisBKGD,thisFisherSample);
        [~,aucList(j,i)] = rocgauss(vec'*thisBKGD,vec'*thisSMPL,500);
    end
    disp([num2str(i),'/',num2str(size(smpl,1)*size(smpl,2))]);
end

if plotOrNot
    for i = 1:size(aucList,2)
        handle = plot(combinedCh,aucList(:,i),'.-','LineWidth',lineWidth,'MarkerSize',markerSize);hold on;
    end
    xlabel('Count of combined channels(#)');
    ylabel('AUC');
    ylim([0,1]);
    grid on;
    set(gca,'FontSize',fontSize);
    legend(sampleName,'Location','southeast');
    hold off;
end

end % of the function