function [h,area,bkgd,sigma,xpeak,cfun] = fitPeak(x,y,plotOrNot)
% x 能谱横坐标，道址
% y 能谱纵坐标，每道计数
% area 峰面积，0代表未拟合上
% 拟合公式
% y=a+slope*x+area*1/sqrt(2*pi)/sigma*exp(-(x-peak)^2/2/sigma^2);
% 20201112 删除输出量amp
% 20210406 删除输出量intercept,slope，添加bkgd。原：[area,sigma,intercept,slope,xpeak,cfun] = fitPeak(x,y,plotOrNot)
% 20210811 更改bkgd的计算方式为十分之一高宽下的线性本底
%
% 常用代码：
%         roi=[:];[~,~,~,~,~,~] = fitPeak(roi,a(roi),1);

if size(x,1)~=1 && size(x,2)~=1
    error('Error: x for fitPeak should be only one column');
elseif size(x,1) == 1
    x=x';
end

if size(y,1)~=1 && size(y,2)~=1
    error('Error: y for fitPeak should be only one column');
elseif size(y,1) == 1
    y=y';
end

syms t;
f = fittype('(area/(sigma*sqrt(2*pi)))*exp(-(t-xpeak)^2/(2*sigma^2))+intercept+slope*t', ...
    'independent','t','coefficients',{'area','sigma','xpeak','intercept','slope'});
options = fitoptions('Method','NonlinearLeastSquares');
originalPeak = x(find(y==max(y))); originalPeak = originalPeak(1,1);
options.Lower = [1e-5,originalPeak*0.001/2.355,originalPeak-2,y(1),min([10*(y(end)-y(1))/(x(end)-x(1)),-Inf])];
%options.Lower = [1e-5,0.01,originalPeak-5,0,-Inf];
%options.Upper = [Inf,Inf,originalPeak+5,Inf,0];
options.Upper = [Inf,originalPeak*0.05/2.355,originalPeak+5,Inf,0];
options.StartPoint = [sum(y)-length(x)*(y(1)+y(end))/2,originalPeak*0.005/2.355,originalPeak,y(1)-x(1)*(y(end)-y(1))/(x(end)-x(1)),(y(end)-y(1))/(x(end)-x(1))];
cfun = fit(x,y,f,options);

area = cfun.area;
sigma = cfun.sigma;
xpeak = cfun.xpeak;
intercept = cfun.intercept;
slope = cfun.slope;
%bkgd = sum(y)-area; % 根据指定的roi区域计数和减去峰净面积为本底，受到roi选取的影响大
fwtm = 2*sqrt(2*log(10))*cfun.sigma; % 十分之一高宽
% 十分之一高宽内计数占总计数的normcdf(sqrt(2*log(10)))*2-1=96.8%
bkgdrange = round(cfun.xpeak-0.5*fwtm):round(cfun.xpeak+0.5*fwtm);
bkgdcounts = bkgdrange*cfun.slope+cfun.intercept;
bkgd = sum(bkgdcounts);%十分之一高宽内的线性本底

h = figure;
plot(x,y,'.','MarkerSize',15);hold on;grid on;
plot(min(x):0.01:max(x),cfun(min(x):0.01:max(x)),'-');
plot([xpeak,xpeak],[min(y),max(y)],'r--');
plot([min(x),max(x)],[intercept+slope*min(x),intercept+slope*max(x)],'r--');
plot([round(cfun.xpeak-0.5*fwtm),round(cfun.xpeak-0.5*fwtm)],[min(y),max(y)],'g--');
plot([round(cfun.xpeak+0.5*fwtm),round(cfun.xpeak+0.5*fwtm)],[min(y),max(y)],'g--');
xlabel('Channel');ylabel('Count(#/ch)');
%     title({'Expression: $y=\frac{A}{\sqrt{2\pi}\sigma}e^{-\frac{(x-\bar{x})^2}{2\sigma^2}}+a+b*x$'; ...
%         ['peakPos=',num2str(xpeak,'%.1f')]; ...
%         ['gross area=',num2str(sum(y))];
%         ['net area=',num2str(area,'%.5f')]; ...
%         ['bkgd area=',num2str(bkgd,'%.5f')]; ...
%         ['FWHM=',num2str(2.355*sigma,'%.1f')]; ...
%         ['Relative resolution=',num2str(2.355*sigma/xpeak,2)]}, ...
%         'Interpreter','latex');
text(x(1),0.5*(max(y)+min(y)),{'Expression: $y=\frac{A}{\sqrt{2\pi}\sigma}e^{-\frac{(x-\bar{x})^2}{2\sigma^2}}+a+b*x$'; ...
    ['peakPos=',num2str(xpeak,'%.1f')]; ...
    ['gross area=',num2str(sum(y))];
    ['net area=',num2str(area,'%.5f')]; ...
    ['bkgd area=',num2str(bkgd,'%.5f')]; ...
    ['FWHM=',num2str(2.355*sigma,'%.1f')]; ...
    ['Relative resolution=',num2str(2.355*sigma/xpeak,2)]}, ...
    'Interpreter','latex');
if plotOrNot
    set(h,'visible','on');
else
    set(h,'visible','off');
end
end
