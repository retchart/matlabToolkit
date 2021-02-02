function [roc,auc] = rocgauss(index1,index2,nSeg)
% Give the Receiver operating characteristic(ROC) curve
% of two samples which come from Gauss districution
% Inputs: 
% index1: one sample set from gauss distribution (One column)
% index2: one sample set from gauss distribution (One column)
% nSeg: how many points shape the ROC curve ,eg.500
%
% Outputs:
% roc: 1st column - False positive rate(FPR) Horizontal axis
%      2nd column - True positive rate(TPR) Vertical axis
%      3rd column - False negative rate(FNR) FNR+TPR=1
%      4th column - Ture negative rate(TNR)  TNR+FPR=1
% auc: Area under ROC curve

%% Data validation
u1 = mean(index1);sigma1 = std(index1,0);
u2 = mean(index2);sigma2 = std(index2,0);

if length(index1)<2||length(index2)<2
    error('Error: Only one index');
end
if u1>u2 % switch to make u2>u1
    warning('Mean(index1)>mean(index2)');
    u3=u1;u1=u2;u2=u3;
    sigma3=sigma1;sigma1=sigma2;sigma2=sigma3;
end

if sum(index1)==0&&sum(index2)==0
    auc = 0.5;
    roc=[0,0;1,1];
    return;
end

%% Found up and low bondary of the threshold
thUP  = max([norminv(1-0.001,u1,sigma1);norminv(1-0.001,u2,sigma2)]);
thLOW = min([norminv(0.001,u1,sigma1);norminv(0.001,u2,sigma2)]);

%% calculate ROC curve
th = (thLOW:(thUP-thLOW)/(nSeg+1):thUP)';
roc = zeros(size(th,1),2);
for i=1:size(th,1)
    roc(i,1) = 1 - normcdf(th(i),u1,sigma1);
    roc(i,2) = 1 - normcdf(th(i),u2,sigma2);
    roc(i,3) = 1 - roc(i,2);
    roc(i,4) = 1 - roc(i,1);
end
roc = sortrows(roc,1:4);

% Calculate ROC false rate Trapezoidal area 
auc = 0;
thisROC = [roc(:,1),roc(:,2)];
for iBin = 2:length(thisROC)
    thisRate = 0.5*(thisROC(iBin,1)-thisROC(iBin-1,1))*(thisROC(iBin,2)+thisROC(iBin-1,2));
    auc = auc + thisRate;
end


end