%% 分析不同峰的半衰期
% 辅助判断核素使用，定量分析含量最好还是用长期测量的谱handle_activity
% 使用前需要形成单列pks向量储存于pks.mat

clear;close all;
load('pks.mat');
pk = pks(:,1);
filename = 'data.mat';
load(filename);

caliParam.tPerFile = 300;
caliParam.E(1,1) = 1.46082;
caliParam.E(2,1) = 2.614511;
caliParam.EStep = 0.001; % MeV
caliParam.maxE = 5; % 能谱量程
ch_range = 20; % 峰区道数

%% 有样品的第一个能谱序号
f=figure;
plot(sum(sgnl,1),'.-');xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
nStart = input('Enter the first spec No. to be fit: ');
close(f);

%% 两点能量刻度
f=figure;
thisbkgd = sum(sgnl(:,1:nStart-2),2);
plot(thisbkgd );xlabel('Ch');ylabel('Count/ch');
title('Spectrum without sample');
ch_K = input('Please enter the channel of K-40 1460.82 keV:');
caliParam.Ewin(1,:) = [ch_K-0.5*ch_range,ch_K+0.5*ch_range];
ch_Tl = input('Please enter the channel of Tl-280 2614.511 keV:');
caliParam.Ewin(2,:) = [ch_Tl-0.5*ch_range,ch_Tl+0.5*ch_range];
close(f);
% 已获得峰位 ch_K 和 ch_Tl

f=figure;
subplot(121);
% 正负6道拟合峰区
[~,~,~,~,ch_K,~] = fitPeak(ch_K-6:ch_K+6,thisbkgd(ch_K-6:ch_K+6),1);
subplot(122);
[~,~,~,~,ch_Tl,~] = fitPeak(ch_Tl-6:ch_Tl+6,thisbkgd(ch_Tl-6:ch_Tl+6),1);
if ~isempty(input('Enter to continue, input anything will abort the process:'))
    disp('User abort');
    return;
end
eAxis = (1:size(orgnSpec,1))';
eAxis = (1460.82-2614.82)*(eAxis-ch_Tl)/(ch_K-ch_Tl)+2614.82;
pks(:,2) = spline((1:size(orgnSpec,1))',eAxis,pks(:,1));

% 逐能谱标准化
for i = 1:size(sgnl,2) 
    [~,newSpec] = ...
        nml1spec_v4(sgnl(:,i),caliParam,0);
    sgnl2(:,i) = newSpec(:,2);
    disp(['Normalized spec No.',num2str(i),'/',num2str(size(sgnl,2))]);
end

% 计算标准化能谱的峰位
for i = 1:size(pks,1)
    [~,pks(i,3)] = min(abs(pks(i,2)-1000*newSpec(:,1)));
end

%% 删起始的本底谱
sp = sgnl2(:,nStart:end); % 计数率
tt = t(nStart:end);
seq = zeros(size(pks,1),size(sp,2));

%% 取峰区净计数
for i = 1:size(sp,2)
    thisSpec = sp(:,i);
    for j = 1:size(pks,1)
        disp(['Processing spec#:',num2str(i),'/', ...
            num2str(size(sp,2)),' peak:',num2str(j),'/', ...
            num2str(size(pks,1))]);
        [~,thispeak] = max(thisSpec(pks(j,3)-5:pks(j,3)+5)); % 正负5道内寻峰
        thispeak = thispeak + pks(j,3) - 6;
        seq(j,i) = getnet(thisSpec,pks(j,3),2);
    end
end

%% 拟合衰变曲线
mkdir('decayCurve');
result = zeros(size(seq,1),5);
for i = 1:size(pk,1) % 拟合
    thisSeq = seq(i,:);
    syms x;
    f=fittype('a+b*exp(-u*x)','independent','x','coefficients',{'a','b','u'});
    options = fitoptions('Method','NonlinearLeastSquares');
    options.StartPoint = [thisSeq(end),thisSeq(1),1e-4];
    options.Lower = [0,0,0];
    [cfun,gof] = fit(tt',thisSeq',f,options);
    f=figure;
    %subplot(211);
    plot(tt',thisSeq','o');hold on;
    plot(tt',cfun(double(tt)),'-');
    title({['Peak#',num2str(i),' ch=',num2str(pks(i,1)),' Energy=',num2str(pks(i,2),'%.2f'),' keV']; ...
        ['T0.5=',num2str(log(2)/cfun.u,'%.2f'),' s',' R^2= ',num2str(gof.rsquare,'%.2f')];
        ['a=',num2str(cfun.a,'%.2f'),' b=',num2str(cfun.b,'%.2f')]});
    xlabel('Time(s)');ylabel('Count rate(cps)');
%     subplot(212);
%     plot(tt',pk(i,:)','.-');xlabel('Time(s)');ylabel('Peak channel');
%     ylim([round(mean(pk(i,:)))-6,round(mean(pk(i,:)))+6]);
    saveas(f,['decayCurve/ch',num2str(pks(i,1)),'.png']);
    result(i,1) = pks(i,1); % 道址
    if size(pks,2)==2
        result(i,2) = pks(i,2); % 能量MeV
    else
        result(i,2) = pks(i,1); % 道址
    end
    result(i,3) = cfun.a; % 本底计数率
    result(i,4) = cfun.b; % t=0 计数率
    result(i,5) = gof.rsquare; % 拟合好坏 Rsquare
    result(i,6) = log(2)/cfun.u; % 半衰期s
end
disp('According to experiences, rSquare >0.7 is reasonable fit');
save(['decay-tmp-',filename],'result','pks','pk','seq','tt','sp','eAxis');

