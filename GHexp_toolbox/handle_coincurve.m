%% 从orgnList文件获得2维能谱和符合曲线
clear;close all;
roiNo = 4;
coin_time = 500; % unit: ns
dataName = 'nacl';% Name of the list mode file
load([dataName,'.mat']);

maxChx =8192; % 纵轴道数
maxChy = maxChx; % 横轴道数
winChx = [100,maxChx];
winChy = [100,maxChy];
% load('lib_grid.mat');
% winChx = [grid_x(2*roiNo-1),grid_x(2*roiNo)];
% winChy = [grid_y(9-2*roiNo),grid_y(10-2*roiNo)];
timeDelay = (-1e4:100:0)'; % unit: ns
chx = 3;
chy = 4;
tRange = [0,120]*60*1e9;% 括号内分钟
eventList = [s.list{1,chx};s.list{1,chy}];
eventList(find(eventList(:,1)>tRange(2)),:)=[];
eventList(find(eventList(:,1)<tRange(1)),:)=[];
 
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
    coinCurve(j,2) = sum(sum(spec2D(winChx(1):winChx(2),winChy(1):winChy(2))));
end
figure;
plot(coinCurve(:,1),coinCurve(:,2),'.-');
xlabel('Time delay(ns)');
ylabel('Coincidence count');
title({['winChx=[',num2str(winChx(1)),',',num2str(winChx(2)),']'];
    ['winChy=[',num2str(winChy(1)),',',num2str(winChy(2)),']']});
grid on;
save([dataName,'-coinCurve-roi',num2str(roiNo),'-',num2str(coin_time),'ns']);

