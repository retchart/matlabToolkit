function [histData,binCenters] = plotdoublehist2(data1,data2,legendContent)
h1=histogram(data1);hold on;
h2=histogram(data2);
h1.Normalization = 'probability';
h2.Normalization = 'probability';
h1.NumBins = 100;
h2.BinEdges = h1.BinEdges;
xlabel('Count rate(cps)')
ylabel(['Probability (/',num2str(h1.BinWidth),'cps)']);
if nargin == 2
    legend('data1','data2');
elseif nargin == 3
    legend(legendContent);
end
title({['\mu_1=',num2str(mean(data1)),' \sigma_1=',num2str(std(data1))]; ...
    ['\mu_2=',num2str(mean(data2)),' \sigma_2=',num2str(std(data2))]});
binEdges = h1.BinEdges;
binCenters = zeros(length(binEdges)-1,1);
histData = zeros(length(binCenters),2);
for i = 1:length(binEdges) - 1
    histData(i,1) = sum(data1<binEdges(i+1))-sum(data1<binEdges(i));
    histData(i,2) = sum(data2<binEdges(i+1))-sum(data2<binEdges(i));
    binCenters(i) = 0.5*(binEdges(i+1)+binEdges(i));
end
end