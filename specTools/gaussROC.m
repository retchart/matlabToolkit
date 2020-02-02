function ROC = gaussROC(index1,index2,nTh)
% index1和index2为两个一维高斯分布的抽样，函数给出移动的阈值对应的ROC曲线
% ROC 横轴False positive rate（FPR） 纵轴 True positive rate（TPR）
% index1: 单列高斯分布1的样本点
% index2: 单列高斯分布2的样本点
% nTh: ROC曲线点的数量
% ROC： 第一列FPR，第二列TPR

%% 数据合理性判断
u1 = mean(index1);sigma1 = std(index1,0);
u2 = mean(index2);sigma2 = std(index2,0);

if size(index1,1)<2||size(index2,1)<2
    disp('Error: Only one index');
    pause;
    return;
end
if u1>u2 %交换使u2>u1
    disp('Warining: mean(index1)>mean(index2)');
    pause;
    u3=u1;u1=u2;u2=u3;
    sigma3=sigma1;sigma1=sigma2;sigma2=sigma3;
end

%% 找阈值上下限
thDOWN = min([norminv(0.001,u1,sigma1);norminv(0.001,u2,sigma2)]);
thUP   = max([norminv(1-0.001,u1,sigma1);norminv(1-0.001,u2,sigma2)]);

%% 做ROC曲线
th = (thDOWN:(thUP-thDOWN)/(nTh+1):thUP)';
ROC = zeros(size(th,1),2);
for i=1:size(th,1)
    ROC(i,1) = normcdf(th(i),u1,sigma1);
    ROC(i,2) = normcdf(th(i),u2,sigma2);
end

%%

end