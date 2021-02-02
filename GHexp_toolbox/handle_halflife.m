%% 分析不同峰的半衰期
% 辅助判断核素使用，定量分析含量最好还是用长期测量的谱handle_activity
% 使用前需要形成单列pks向量储存于pks.mat

clear;close all;
load('pks.mat');
filename = 'data-nml.mat';
load(filename);
pks(:,2)=eAxis(pks(:,1),1);

%% 有样品的第一个能谱序号
f=figure;
plot(sum(sgnl,1),'.-');xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
nStart = input('Enter the first spec No. to be fit: ');
close(f);

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
        [~,thispeak] = max(thisSpec(pks(j,1)-5:pks(j,1)+5)); % 正负5道内寻峰
        thispeak = thispeak + pks(j,1) - 6;
        seq(j,i) = getnet(thisSpec,pks(j,1),1);
    end
end

%% 拟合衰变曲线
% seq,pks(第一列道址第二列能量),tt,
mkdir('decayCurve');
result = zeros(size(seq,1),5);
for i = 1:size(pks,1) % 拟合
    thisSeq = seq(i,:);
    syms x;
    f=fittype('a+b*exp(-u*x)','independent','x','coefficients',{'a','b','u'});
    options = fitoptions('Method','NonlinearLeastSquares');
    options.StartPoint = [thisSeq(end),thisSeq(1),1e-4];
    options.Lower = [0,0,0];
    [cfun,gof] = fit(tt',thisSeq',f,options);
    f=figure;
    plot(tt',thisSeq','o');hold on;
    plot(tt',cfun(double(tt)),'-');
    title({['Peak#',num2str(i),' ch=',num2str(pks(i,1)),' Energy=',num2str(pks(i,2),'%.2f'),' keV']; ...
        ['T0.5=',num2str(log(2)/cfun.u,'%.2f'),' s',' R^2= ',num2str(gof.rsquare,'%.2f')];
        ['a=',num2str(cfun.a,'%.2f'),' b=',num2str(cfun.b,'%.2f')]});
    xlabel('Time(s)');ylabel('Count rate(cps)');
    saveas(f,['decayCurve/ch',num2str(pks(i,1)),'.png']);
    result(i,1) = pks(i,1); % 道址
    result(i,2) = pks(i,2); % 能量MeV
    result(i,3) = cfun.a; % 本底计数率
    result(i,4) = cfun.b-cfun.a; % t=0 计数率
    if gof.rsquare>0
    result(i,5) = gof.rsquare; % 拟合好坏 Rsquare
    else
        result(i,5) = 0;
    end
    result(i,6) = log(2)/cfun.u; % 半衰期s
end
disp('According to experiences, rSquare >0.7 is reasonable fit');
save(['decay2-',filename],'result','pks','seq','tt','sp','eAxis','spec_meas');

%% 缓发总能谱的峰净计数
%disp('Enter to continue... ');pause();
close all;
area = zeros(size(pks,1),2); % 拟合结果，getnet结果
for i = 1:size(pks,1) % 拟合
    disp(['Processing peak ',num2str(i),'/',num2str(size(pks,1))]);
    rr = pks(i,1)-15:pks(i,1)+15;
    %figure;
    [area(i,1),~,~,~,~,~] = fitPeak(rr,spec_meas(rr),0);
    area(i,2) = getnet(spec_meas,pks(i,1),1);
end
save(['decay2-',filename],'result','pks','seq','tt','sp','eAxis','spec_meas','area');
disp('将result,area,tsum三个内容复制入excel');
