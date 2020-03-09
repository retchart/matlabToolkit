function [y,w]=myfisher_csdn(x1,x2,sample)
% Fisher函数
% x1,x2,sample分别为两类训练样本及待测数据集，其中行为样本数，列为特征数
% https://blog.csdn.net/mmy1996/article/details/72821275
r1=size(x1,1);r2=size(x2,1);
r3=size(sample,1);
a1=mean(x1)';a2=mean(x2)';
s1=cov(x1)*(r1-1);s2=cov(x2)*(r2-1);
sw=s1+s2;%求出协方差矩阵
w=inv(sw)*(a1-a2)*(r1+r2-2);
y1=mean(w'*a1);
y2=mean(w'*a2);
y0=(r1*y1+r2*y2)/(r1+r2);
for i=1:r3
    y(i)=w'*sample(i,:)';
    if y(i)>y0
        y(i)=0;
    else
        y(i)=1;
    end
end