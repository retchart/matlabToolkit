function [roc,auc] = rocraw(index1,index2,nSeg)
% Give the Receiver operating characteristic(ROC) curve
% 
% Inputs:
% index1/index2: one column or one raw data
% nSeg: How many points shape the ROC curve
%
% Output:
% roc: 1st column - False positive rate(FPR) Horizontal axis
%      2nd column - True positive rate(TPR) Vertical axis
%      3rd column - False negative rate(FNR) FNR+TPR=1
%      4th column - Ture negative rate(TNR)  TNR+FPR=1
% auc: Area under ROC curve

if length(index1)<2||length(index2)<2
    error('Error: Only one index');
end
range = [min([index1,index2]),max([index1,index2])];
if mean(index1)>mean(index2) % 确保index1处于index2左边
    index0=index1;
    index1=index2;
    index2=index0;
end
roc=zeros(nSeg,4);
for i = 1:nSeg
    thresh = range(1)+i*(range(2)-range(1))/nSeg;
    roc(i,1) = sum(index1>thresh)/length(index1);
    roc(i,2) = sum(index2>thresh)/length(index2);
    roc(i,3) = sum(index2<=thresh)/length(index2);
    roc(i,4) = sum(index1<=thresh)/length(index1);
end
roc = unique(roc,'row','stable'); % delete duplicated data
roc = sortrows(roc,1:4);

% Calculate ROC false rate Trapezoidal area 
auc = 0;
thisROC = [roc(:,1),roc(:,2)];
for iBin = 2:length(thisROC)
    thisRate = 0.5*(thisROC(iBin,1)-thisROC(iBin-1,1))*(thisROC(iBin,2)+thisROC(iBin-1,2));
    auc = auc + thisRate;
end

end
