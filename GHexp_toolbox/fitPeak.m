function [area,amp,sigma,intercept,slope,xpeak,cfun] = fitPeak(x,y,plotOrNot)
% x 能谱横坐标，道址
% y 能谱纵坐标，每道计数
% area 峰面积，0代表未拟合上
% 拟合公式
% y=a+slope*x+area*1/sqrt(2*pi)/sigma*exp(-(x-peak)^2/2/sigma^2);
syms t;
f=fittype('(amp/(sigma*sqrt(2*pi)))*exp(-(t-xpeak)^2/(2*sigma^2))+intercept+slope*t', ...
    'independent','t','coefficients',{'amp','sigma','xpeak','intercept','slope'});
options = fitoptions('Method','NonlinearLeastSquares');
originalPeak = x(find(y==max(y))); originalPeak = originalPeak(1,1);
options.Lower = [10,2,originalPeak-5,0,-Inf];
options.Upper = [Inf,Inf,originalPeak+5,Inf,0];
options.StartPoint = [10,1,originalPeak,1,(y(end)-y(1))/(x(end)-x(1))];
cfun = fit(x,y,f,options);
if plotOrNot
    figure;
    plot(x,y,'.');hold on;grid on;
    plot(min(x):0.0001:max(x),cfun(min(x):0.0001:max(x)),'-');
    xlabel('Energy(MeV)');ylabel('Count rate(cps/ch)');
end
amp = cfun.amp;
sigma = cfun.sigma;
xpeak = cfun.xpeak;
intercept = cfun.intercept;
slope = cfun.slope;
area = amp/(sqrt(2)*sigma);
end