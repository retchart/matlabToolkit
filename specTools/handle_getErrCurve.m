clear;close all;
bkgdName = 'w4';
sgnlName = 'w3';
bkgdFile = [bkgdName,'-step0.01MeV-nml.mat'];
sgnlFile = [sgnlName,'-step0.01MeV-nml.mat'];
falseNeg=(1:60)';% 计算的时间范围
plotOrNot = 0;
falsePosList = [0.1;0.05;0.02;0.01];
for j = 1:size(falsePosList,1)
    falsePos = falsePosList(j); % 漏报率图对应的误报率
    for i = 1:size(falseNeg,1)
        measureTime = falseNeg(i,1);
        [falsePosCurve,falseNegCurve,falseNeg(i,j+1)]=errCurve(bkgdFile,sgnlFile,measureTime,falsePos,plotOrNot);
        disp(i);
    end
end

close all;
figure;
plot(falseNeg(:,1),falseNeg(:,2:end),'.-');hold on;grid on;
xlabel('Measure time(s)');ylabel('False negative rate');
title('FN rate vs time at different FP rate');
legend(num2str(falsePosList));

save(['errCurve-',bkgdName,'-',sgnlName]);