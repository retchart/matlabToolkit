%% 从orgnList文件获得2维能谱和符合曲线
clear;close all;
roiNo = 1; % 仅保存名称使用
coin_time = 1000; % unit: ns
dataName = 'nothing';% Name of the list mode file
load([dataName,'.mat']);

maxChx =8192; % 纵轴道数
maxChy = maxChx; % 横轴道数
winChx = [100:maxChx];
winChy = [100:maxChy];
% winChx = [5100:6900];
winChx = [1920:1967];
winChy = [200:8000];
% load('lib_grid.mat');
% winChx = [grid_x(2*roiNo-1),grid_x(2*roiNo)];
% winChy = [grid_y(9-2*roiNo),grid_y(10-2*roiNo)];
timeDelay = (-1e4:100:0)'; % unit: ns
chx = 1;
chy = 2;
tRange = [0,10]*60*1e9;% 括号内分钟
eventList = [s.list{1,chx};s.list{1,chy}];
eventList(find(eventList(:,1)>tRange(2)),:)=[]; % 删除过于离谱的时刻
eventList(find(eventList(:,1)<tRange(1)),:)=[];
% 画能谱
figure; 
subplot(211);
a=eventList(find(eventList(:,2)==chx),3);
[ccc,eee]=hist(a,1:maxChx);
semilogy(eee,ccc);hold on;
semilogy(eee(winChx),ccc(winChx));
xlabel('Ch');ylabel('Count');
title(['Sum of ROI=',num2str(sum(ccc(winChx)))]);
subplot(212);
a=eventList(find(eventList(:,2)==chy),3);
[ccc,eee]=hist(a,1:maxChy);
semilogy(eee,ccc);hold on;
semilogy(eee(winChy),ccc(winChy));
xlabel('Ch');ylabel('Count');
title(['Sum of ROI=',num2str(sum(ccc(winChy)))]);

coinCurve = [timeDelay,zeros(size(timeDelay,1),1)];
for j = 1:length(timeDelay)
    seq = eventList;
    seq(find(seq(:,2)==chx | seq(:,2)==chy),:);
    seq(find(seq(:,2)==chy),1) = seq(find(seq(:,2)==chy),1) - timeDelay(j);
    seq = sortrows(seq);
    % 画2维能谱
    spec2D = zeros(maxChx,maxChy);
    for i = 1:size(seq,1)-1
        if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2)
            spec2D(seq(i,3),seq(i+1,3)) = spec2D(seq(i,3),seq(i+1,3))+1;
            continue;
        elseif seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)>seq(i+1,2)
            spec2D(seq(i+1,3),seq(i,3)) = spec2D(seq(i+1,3),seq(i,3))+1;
            continue;
        end
        if seq(i,2)==chx
            spec2D(seq(i,3),1) = spec2D(seq(i,3),1)+1;
        elseif seq(i,2)==chy
            spec2D(1,seq(i,3)) = spec2D(1,seq(i,3))+1;
        else
            % error('Invalid channel');
        end
        if mod(i,1e5)==0
            disp(['Time delay:',num2str(j),'/',num2str(length(timeDelay)), ...
                ' Event No.',num2str(i),'/',num2str(length(seq))]);
        end
    end
    coinCurve(j,2) = sum(sum(spec2D(winChx,winChy)));
end
figure;
plot(coinCurve(:,1),coinCurve(:,2),'.-');
xlabel('Time delay(ns)');
ylabel('Coincidence count');
title({['winChx=[',num2str(winChx(1)),'……',num2str(winChx(end)),']'];
    ['winChy=[',num2str(winChy(1)),'……',num2str(winChy(end)),']']});
grid on;
save([dataName,'-coinCurve-roi',num2str(roiNo),'-',num2str(coin_time),'ns']);

