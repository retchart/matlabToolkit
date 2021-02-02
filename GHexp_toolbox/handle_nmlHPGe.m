%% 稳谱及标准化

clear;
close all;
filename = 'data';
load([filename,'.mat']);
caliParam.tPerFile = mean(t_realtime);
caliParam.E(1,1) = 1.46082;
caliParam.E(2,1) = 2.614511;
caliParam.EStep = 0.0005; % MeV
caliParam.maxE = 5; % 能谱量程

%% 获取有样品的第一个能谱
f=figure;
semilogy(sum(sgnl,1));xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
% nStart = input('Enter the first spec No. to be fit: ');
[~,nStart] = max(sum(sgnl,1)); % 可能不正确，该能谱可能包含少量无样品时段
if isempty(nStart)
    nStart = 1;
end
%nStop = input('Enter the final spec No. to be fit: ');
nStop = size(sgnl,2); % 
if isempty(nStop)
    nStart = size(orgnSpec,2);
end
close(f);

%% 两点能量刻度
disp('Calibrating spectrum...');
f=figure;
thisbkgd = sum(sgnl(:,1:nStart-2),2);
plot(thisbkgd );xlabel('Ch');ylabel('Count/ch');
title('Spectrum without sample');
%ch_K = input('Please enter the channel of K-40 1460.82 keV:');
[~,ch_K] = max(thisbkgd);
caliParam.Ewin(1,:) = [ch_K-round(0.004*ch_K)-5,ch_K+round(0.004*ch_K)];
%ch_Tl = input('Please enter the channel of Tl-280 2614.511 keV:');
tmp = thisbkgd;tmp(1:ch_K+5)=0;
[~,ch_Tl] = max(tmp);
caliParam.Ewin(2,:) = [ch_Tl-round(0.004*ch_Tl)-5,ch_Tl+round(0.004*ch_Tl)];
close(f);

%% 逐能谱标准化
% [sgnl2,~,eAxis] = nmlAndSave1Mat(sgnl,caliParam,1);
mkdir('nml');
for i = 1:size(sgnl,2)
    disp(['Normalizing spec No.',num2str(i),'/',num2str(size(sgnl,2))]);
    [orgSpe,nmldSpec] = nml1spec_v4(sgnl(:,i),caliParam,1);
    sgnl2(:,i) = nmldSpec(:,2);
    %disp([num2str(sum(sgnl(:,i))),'==',num2str(sum(sgnl2(:,i)))]);
    f = figure;
    subplot(211);
    plot(sgnl(:,i),'.-');xlim([ch_K-round(0.004*ch_K) ch_K+round(0.004*ch_K)]);xlabel('ch');ylabel('cps/ch');
    subplot(212);
    plot(sgnl2(:,i),'.-');
    xlim([1.46/caliParam.EStep-round(0.004*1.46/caliParam.EStep) 1.46/caliParam.EStep+round(0.004*1.46/caliParam.EStep)]);
    xlabel('E');ylabel(['cps/',num2str(caliParam.EStep),'MeV']);
    saveas(f,['nml/No',num2str(i),'.png']);
    close(f);
end
eAxis_old = orgSpe(:,1);
eAxis = nmldSpec(:,1);

%% 计算长期谱
spec = sum(sgnl2(:,nStart:nStop),2)/(nStop-nStart+1); % 单列计数谱
tsum = sum(t_realtime(1,nStart:nStop)); % 总测量时长
spec_meas = spec*tsum; % 测量时间内计数能谱r

save([filename,'-nml'],'orgnSpec','sgnl','t','t_realtime','sgnl2', ...
    'eAxis','tsum','spec_meas','caliParam','nStart','nStop');
