%% 从seq文件获得2维能谱
% 建议先使用coincurve脚本寻找合适的延时时间
% 
clear;close all;
dataName = 'nacl';% Name of the list mode file
load([dataName,'.mat']);
load('lib_grid.mat'); % grid_x grid_y 划分计数区域
chx = 3;
chy = 4;
coin_time = 1000; % unit: ns
timeDelay = -4400; % unit: ns
maxChx = 8192;
maxChy = maxChx;
small_dim=[128,128];
plotOrNot = 1;
tRange = [0 120]*60*1e9;% 括号内分钟
eventList = [s.list{1,chx};s.list{1,chy}];
eventList(find(eventList(:,1)>tRange(2)),:)=[];
eventList(find(eventList(:,1)<tRange(1)),:)=[];

seq = eventList;
seq(find(seq(:,2)==chy),1) = seq(find(seq(:,2)==chy),1) - timeDelay;
seq = sortrows(seq);
seqx = seq(find(seq(:,2)==chx),:);
seqy = seq(find(seq(:,2)==chy),:);

% 画单通道能谱
if plotOrNot
    figure;
    h1 = histogram(seqx(:,3),0:maxChx);
    xlabel('Channel');
    ylabel('Count');
    title(['Ch',num2str(chx),' spectrum']);
    figure;
    h2 = histogram(seqy(:,3),0:maxChy);
    xlabel('Channel');
    ylabel('Count');
    title(['Ch',num2str(chy),' spectrum']);
end

%% 画单通道事件间时间分布
t1 = zeros(size(seqx,1)-1,1);
for i = 1:size(seqx,1)-1
    t1(i,1) = seqx(i+1,1)-seqx(i,1);
end
t1=t1/1e6; % unit:ms
if plotOrNot
    figure;
    ht1 = histogram(t1,0:0.01:7);
    xlabel('Time interval(ms)');
    ylabel('Frequency');
    title('Time interval distribution of Ch1 events');
end

t2 = zeros(size(seqy,1)-1,1);
for i = 1:size(seqy,1)-1
    t2(i,1) = seqy(i+1,1)-seqy(i,1);
end
t2=t2/1e6; % unit:ms
if plotOrNot
    figure;
    ht2 = histogram(t2,0:0.01:7);
    xlabel('Time interval(ms)');
    ylabel('Frequency');
    title('Time interval distribution of Ch2 events');
end

%% 画2维能谱
spec2D = zeros(maxChx,maxChy);
for i = 1:size(seq,1)-1
    if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2)
        % 注意chx的道址为行号，因此2D能谱的纵轴为chy
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
        error('Invalid channel');
    end
    %disp(num2str(i));
end
spec2D_small = resizemat(spec2D,small_dim);
if plotOrNot
    figure;
    h=imagesc(size(spec2D)/size(spec2D_small): ...
        size(spec2D)/size(spec2D_small): ...
        size(spec2D),size(spec2D)/size(spec2D_small): ...
        size(spec2D)/size(spec2D_small): ...
        size(spec2D), ...
        spec2D_small);
    hc=colorbar;
    caxis([0,max(max(spec2D_small(2:end,2:end)))]);
    caxis([0 200]);
    hc.Title.String = 'Count';
    xlabel('Ch2');
    ylabel('Ch1');
end


%% 计算lib_grid中的区域计数
c_map = zeros(length(grid_x),length(grid_y));% 
for i = 1:length(grid_x)-1
    for j = 1:length(grid_y)-1
        c_map(i,j) = ...
            sum(sum(spec2D(grid_x(i):grid_x(i+1),grid_y(j):grid_y(j+1))));
    end
end

% 最后一行和最后一列存储能谱在该区间总计数
tmp = sum(spec2D,2);
for i = 1:length(grid_x)-1
    c_map(i,end) = sum(tmp(grid_x(i):grid_x(i+1)));
end

tmp = sum(spec2D,1);
for j = 1:length(grid_y)-1
    c_map(end,j) = sum(tmp(grid_y(j):grid_y(j+1)));
end

%save([dataName,'-2Dspec-0-1.5.mat']);

