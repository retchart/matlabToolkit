%% 从orgnList文件获得2维能谱和符合曲线
close all;
roiNo = 99; % 仅保存名称使用
coin_time = 1000; % unit: ns
dataName = 'nacl';% Name of the list mode file
load([dataName,'.mat']);
chx = 3;
chy = 4;
maxChx = 8192; % 纵轴道数
maxChy = 8192; % 横轴道数
winChx = [200:maxChx];
winChy = [200:maxChy];
tmin = 1e6; % 时刻下阈，在周期出束时可能使用
% winChx = [1920:1967];
% winChy = [200:8000];
% load('lib_grid.mat');
% winChx = [grid_x(2*roiNo-1),grid_x(2*roiNo)];
% winChy = [grid_y(9-2*roiNo),grid_y(10-2*roiNo)];
% chy比chx的延迟时间，>0表示chx信号先到
timeDelay = (-1e4:200:0.2e4)'; % unit: ns
timeDelay = -8000;

tRange = [0,9]*24*3600*1e9;% 测量时长ns
if iscell(s.list)
    eventList = [s.list{1,chx};s.list{1,chy}];
else
    eventList = s.list;
end
eventList(find(eventList(:,1)>tRange(2)),:)=[]; % 删除离谱的时刻
eventList(find(eventList(:,1)<tRange(1)),:)=[];
eventList = sortrows(eventList);
eventList = eventList(find(eventList(:,1)>tmin),:);
% 画能谱
figure; 
subplot(211);
[ccc,eee]=hist(eventList(find(eventList(:,2)==chx),3),1:maxChx);
semilogy(eee,ccc);hold on;
semilogy(eee(winChx),ccc(winChx));
xlabel('Ch');ylabel('Count');
title(['Sum of ROI=',num2str(sum(ccc(winChx)))]);
subplot(212);
[ccc,eee]=hist(eventList(find(eventList(:,2)==chy),3),1:maxChy);
semilogy(eee,ccc);hold on;
semilogy(eee(winChy),ccc(winChy));
xlabel('Ch');ylabel('Count');
title(['Sum of ROI=',num2str(sum(ccc(winChy)))]);

coinCurve = [timeDelay,zeros(size(timeDelay,1),1)];
coinCount = 0; % 储存当前符合计数
spec2D_maxCoinCount = zeros(maxChx,maxChy); % 储存最大符合计数时的二维能谱
for j = 1:length(timeDelay)
    seq = eventList;
    seq(find(seq(:,2)==chx | seq(:,2)==chy),:);
    seq(find(seq(:,2)==chy),1) = seq(find(seq(:,2)==chy),1) - timeDelay(j);
    seq = sortrows(seq);
    % 画2维能谱
    spec2D = zeros(maxChx,maxChy);
    for i = 1:size(seq,1)-1
        if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2) % 前后两个事件间隔够短且分属不同道
            spec2D(seq(i,3),seq(i+1,3)) = spec2D(seq(i,3),seq(i+1,3))+1;
            continue;
        elseif seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)>seq(i+1,2)
            spec2D(seq(i+1,3),seq(i,3)) = spec2D(seq(i+1,3),seq(i,3))+1;
            continue;
        end
        if seq(i,2)==chx % 未符合上
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
    if coinCurve(j,2)>coinCount
        coinCount = coinCurve(j,2);
        spec2D_maxCoinCount = spec2D;
    end
end
figure;
plot(coinCurve(:,1),coinCurve(:,2),'.-');
xlabel('Time delay(ns)');
ylabel('Coincidence count');
title({'T(delay) = T(chy) - T(chx)';
    ['winChx=[',num2str(winChx(1)),'……',num2str(winChx(end)),']'];
    ['winChy=[',num2str(winChy(1)),'……',num2str(winChy(end)),']'];
    ['coincidence time = ',num2str(coin_time),' ns']});
grid on;
save([dataName,'-coinCurve-roi',num2str(roiNo),'-',num2str(coin_time),'ns']);

