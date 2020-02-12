function ROC = rocgauss(index1,index2,nTh)
% Give the Receiver operating characteristic(ROC) curve
% of two samples which come from Gauss districution
% Inputs: 
% index1: one sample set from gauss distribution (One column)
% index2: one sample set from gauss distribution (One column)
% nTh: how many points shape the ROC curve 
%
% Outputs:
% ROC: First column - False positive rate(FPR) Horizontal axis
%      Second column - True positive rate(TPR) Vertical axis

%% Data validation
u1 = mean(index1);sigma1 = std(index1,0);
u2 = mean(index2);sigma2 = std(index2,0);

if length(index1)<2||length(index2)<2
    error('Error: Only one index');
end
if u1>u2 % switch to make u2>u1
    disp('Warining: mean(index1)>mean(index2)');
    u3=u1;u1=u2;u2=u3;
    sigma3=sigma1;sigma1=sigma2;sigma2=sigma3;
end

%% Found up and low bondary of the threshold
thUP  = max([norminv(1-0.001,u1,sigma1);norminv(1-0.001,u2,sigma2)]);
thLOW = min([norminv(0.001,u1,sigma1);norminv(0.001,u2,sigma2)]);

%% calculate ROC curve
th = (thLOW:(thUP-thLOW)/(nTh+1):thUP)';
ROC = zeros(size(th,1),2);
for i=1:size(th,1)
    ROC(i,1) = normcdf(th(i),u1,sigma1);
    ROC(i,2) = normcdf(th(i),u2,sigma2);
end

end