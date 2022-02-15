%% 展示Galloway论文中精度有改善的区间
clear;
close all;
R = [0,0.1,1,10,15];
r = 1:0.1:100;
e = zeros(length(r),length(R));
for i = 1:length(R)
    for j = 1:length(r)
        e(j,i)=(r(j)*R(i)+2)/(r(j)*(R(i)+2));
    end
end
figure;
semilogx(r,e);
xlabel('r');
ylabel('e');
title('曲线上方的参数空间可改善精度');
legend({'R=0','R=0.1','R=1','R=10','R=15'});