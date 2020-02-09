function newSpecSeq = deleteoutlier(specSeq,stableTime,ROI,outlierThresh,plotOrNot)
% 删除能谱序列的离群点
% specSeq:标准化的能谱序列，每一列为一标准化能谱
% stableTime：从第几个能谱开始加速器稳定
% ROI：结构体，ROI每个字段存储ROI区间
% outlierThresh：几倍样本标准差外算离群点
% plotOrNot:是否画图
% delCh: 每一列为删除的能谱序号，有重复，使用前需unique(delCh)
% delSeg: 每个数为因不同的ROI删除的左开右闭区间端点

ROInames = fieldnames(ROI);
nROI = length(ROInames);
seq = zeros(nROI+1,size(specSeq,2));
for i = 1:nROI
    thisRange = getfield(ROI,ROInames{i});
    seq(i,:) = sum(specSeq(thisRange(1):thisRange(2),:),1);% 加速器稳定后的点
end
seq(i+1,:) = sum(specSeq,1); % 全能谱计数和

delSeg = zeros(size(seq,1),1); % seqSeg做分割点的左开右闭区间为该序列离群点
delCh = [];
for i = 1:size(seq,1)
    thisSeq = seq(i,:);% 遗留问题：删除离群点应迭代多次，还需修改示意图标题
    delCh = [delCh,find(thisSeq<mean(thisSeq(stableTime:end))-outlierThresh*std(thisSeq(stableTime:end),0))];
    delCh = [delCh,find(thisSeq>mean(thisSeq(stableTime:end))+outlierThresh*std(thisSeq(stableTime:end),0))];
    delCh(find(delCh<stableTime)) = [];
    delSeg(i,1) = size(delCh,2);
end

% 展示样品谱删除的点
if stableTime~=1
    delCh = [delCh,1:stableTime-1];
end
delSeg = [delSeg;size(delCh,2)];
newSpecSeq=specSeq;
newSpecSeq(:,unique(delCh)) = [];

% 使用specSeq,delCh,delSeg,ROI画图
ROInames = [ROInames;'total'];
if plotOrNot
    for i = 1:nROI+1 
        figure;
        plot(1:size(specSeq,2),seq(i,:),'.-');hold on;
        % 标所有被删除的点
        unique_delCh = unique(delCh);
        for j = 1:length(unique_delCh) 
            plot([unique_delCh(j),unique_delCh(j)],[0,seq(i,unique_delCh(j))],'m-');
        end
        % 标因本ROI被删除的点
        if i==1
            this_delCh = delCh(1:delSeg(i));
        else
            this_delCh = delCh(delSeg(i-1)+1:delSeg(i));
        end
        for j = 1:size(this_delCh,2)
            plot([this_delCh(j),this_delCh(j)],[0,seq(i,this_delCh(j))],'r-');
        end
        title({[ROInames{i},' sum out of ',num2str(outlierThresh),'\sigma']; ...
            ['Deleted ',num2str(length(unique_delCh)), ...
            ' (pink+red) in total. Here: ',num2str(length(this_delCh)),' (red)']; ...
            ['Average=',num2str(mean(seq(i,stableTime:end))), ...
            ' Std=',num2str(std(seq(i,stableTime:end),0))]});
        ymin = min(seq(i,:));ymax = max(seq(i,:));
        ylim([max([0,1.5*ymin-0.5*ymax]),1.5*ymax-0.5*ymin]);
        
        %% 画计数率分布图
        thisOldSeq = seq(i,:);
        thisNewSeq = thisOldSeq;
        thisNewSeq(unique_delCh) = [];
        figure;
        h1=histogram(thisOldSeq);hold on;
        h2=histogram(thisNewSeq);
        h1.Normalization = 'probability';
        h2.Normalization = 'probability';
        h1.NumBins = 50;
        h2.BinEdges = h1.BinEdges;
        title(['Count rate distribution of specSeq of ',ROInames{i}]);
        xlabel('Count rate(cps)')
        % ylabel('Frequency (/',num2str(h1.BinWidth),'cps)');
        ylabel(['Probability (/',num2str(h1.BinWidth),'cps)']);
        legend('all','select');
    end
end
% 
% %% 画计数率分布图
% figure;
% [y,x]=hist(sum(specSeq,1),0:1e2:5e4);
% plot(x,y,'r.-');hold on;
% [y,x]=hist(sum(newSpecSeq,1),0:1e2:5e4);
% plot(x,y,'b.-');
% title('Count rate distribution of specSeq full spectra');
% xlabel('Count rate(cps)')
% ylabel('Frequency (/100cps)');
% legend('all','select');
% specSeq(:,delCh) = [];clearvars specSeq0;


end

