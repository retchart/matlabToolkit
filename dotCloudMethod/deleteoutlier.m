function newSpecSeq = deleteoutlier(specSeq,stableTime,ROI,outlierThresh,plotOrNot)
% Detele spectra whose counts in ROI are outliers
% 
% Inputs:
% specSeq: normalized spectra sequence£¬each column is a nmlized spectrum
% stableTime£ºFrom which spectrum the flux was stable
% ROI£ºRegion of interest, a structure whose fields contain the up and low
% boundaries of ROI
% outlierThresh£ºTimes of variance out which the dots are regard as outlier
% plotOrNot: 1-plot 0-not

ROInames = fieldnames(ROI);
nROI = length(ROInames);
seq = zeros(nROI+1,size(specSeq,2));
for i = 1:nROI
    thisRange = getfield(ROI,ROInames{i});
    seq(i,:) = sum(specSeq(thisRange(1):thisRange(2),:),1);
end
seq(i+1,:) = sum(specSeq,1); % sum of total spectrum

delSeg = zeros(size(seq,1),1); 
% Left open right close interval diveded by seqSeg are outlier of the seq
deletedSpecNo = [];
for i = 1:size(seq,1)
    thisSeq = seq(i,:);
    % NOTICE: Should use iteration. Remember to edit the title of figures
    deletedSpecNo = [deletedSpecNo,find(thisSeq<mean(thisSeq(stableTime:end))-outlierThresh*std(thisSeq(stableTime:end),0))];
    deletedSpecNo = [deletedSpecNo,find(thisSeq>mean(thisSeq(stableTime:end))+outlierThresh*std(thisSeq(stableTime:end),0))];
    deletedSpecNo(find(deletedSpecNo<stableTime)) = [];
    delSeg(i,1) = size(deletedSpecNo,2);
end

% list the spectrums which are deleted
if stableTime~=1
    deletedSpecNo = [deletedSpecNo,1:stableTime-1];
end
delSeg = [delSeg;size(deletedSpecNo,2)];
newSpecSeq=specSeq;
newSpecSeq(:,unique(deletedSpecNo)) = [];

% plot
ROInames = [ROInames;'total'];
if plotOrNot
    for i = 1:nROI+1 
        figure;
        plot(1:size(specSeq,2),seq(i,:),'.-');hold on;
        % Highlight all the deleted points
        unique_delCh = unique(deletedSpecNo);
        for j = 1:length(unique_delCh) 
            plot([unique_delCh(j),unique_delCh(j)],[0,seq(i,unique_delCh(j))],'m-');
        end
        % Highlight points deleted in this seq
        if i==1
            this_delCh = deletedSpecNo(1:delSeg(i));
        else
            this_delCh = deletedSpecNo(delSeg(i-1)+1:delSeg(i));
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
        
        %% Plot the distrubution of count rate
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
        ylabel(['Probability (/',num2str(h1.BinWidth),'cps)']);
        legend('all','select');
    end
end

end

