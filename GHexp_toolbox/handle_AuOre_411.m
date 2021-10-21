%% 自HPGe能谱411keV峰分析Au含量,双峰拟合以处理In-116m的416keV影响
% 先使用handle_nmlHPGe得到标准化能谱
clear;close all;
filename = 'data';
load([filename,'-nml.mat']);
ch_range = 40;

%% 拟合峰面积
peak411 = round(0.411/caliParam.EStep);
peak416 = round(0.416/caliParam.EStep);
thisRange = (4080:4200)';
thisSpec = spec_meas(thisRange,1);
thisROI = [thisRange,thisSpec];
f = fittype('a+b*x+(a1/(s1*sqrt(2*pi)))*exp(-(x-pk1)^2/(2*s1^2))+(a2/(s2*sqrt(2*pi)))*exp(-(x-pk2)^2/(2*s2^2))', ...
    'independent','x','coefficients',{'a','b','a1','s1','pk1','a2','s2','pk2'});
options = fitoptions('Method','NonlinearLeastSquares');
options.StartPoint = ...
    [thisSpec(1),(thisSpec(end)-thisSpec(1))/(thisRange(end)-thisRange(1)), ...
    1,1,peak411,1,1,peak416];
options.Lower = [thisSpec(1),-Inf,0,0.1,peak411-2,0,0.1,peak416+2];
options.Upper = [Inf,0,Inf,5,peak411+2,Inf,5,peak416+2];
cfun = fit(thisRange,thisSpec,f,options);

f=figure;
plot(thisRange,thisSpec,'.','MarkerSize',15);hold on;grid on;
plot(min(thisRange):0.01:max(thisRange),cfun(min(thisRange):0.01:max(thisRange)),'-');
title({'a+b*x+(a1/(s1*sqrt(2*pi)))*exp(-(x-pk1)^2/(2*s1^2))+(a2/(s2*sqrt(2*pi)))*exp(-(x-pk2)^2/(2*s2^2))'; ...
    ['a=',num2str(cfun.a,'%.1f')]; ...
    ['b=',num2str(cfun.b,'%.1f')]; ...
    ['a1=',num2str(cfun.a1,'%.1f')]; ...
    ['s1=',num2str(cfun.s1,'%.1f')]; ...
    ['pk1=',num2str(cfun.pk1,'%.1f')]; ...
    ['a2=',num2str(cfun.a2,'%.1f')]; ...
    ['s2=',num2str(cfun.s2,'%.1f')]; ...
    ['pk2=',num2str(cfun.pk2,'%.1f')]});
xlabel('Ch');ylabel(['Count in ',num2str(tsum),' s']);

% close(f);