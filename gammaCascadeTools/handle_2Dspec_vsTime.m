%% 获得能谱随延时时间的变化
% 建议先使用coincurve脚本寻找合适的延时时间
clear;close all;
dataName = 'nacl';% Name of the list mode file
load([dataName,'.mat']);
chx = 3;
chy = 4;
coin_time = 500; % 符合分辨时间 unit: ns
timeDelay = -15000:1000:000; % unit: ns
maxChx = 8192;
maxChy = maxChx;
small_dim = [256,256];
xscale = maxChx/small_dim(1);
yscale = maxChy/small_dim(2);
plotOrNot = 1;
tRange = [0,120]*60*1e9;% 括号内分钟
eventList = [s.list{1,chx};s.list{1,chy}];
eventList(find(eventList(:,1)>tRange(2)),:)=[];
eventList(find(eventList(:,1)<tRange(1)),:)=[];

% 画2维能谱
spec2D_small = cell(length(timeDelay),1);
v = VideoWriter([dataName,'.avi']);
v.FrameRate = 4; % 一秒几帧
open(v);
for j = 1:length(timeDelay)
    seq = eventList;
    seq(find(seq(:,2)==chy),1) = seq(find(seq(:,2)==chy),1) - timeDelay(j);
    seq = sortrows(seq);
    spec2D=zeros(maxChx,maxChy);
    for i = 1:size(seq,1)-1
        if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2) % 符合成功
            % 注意ch1的道址为行号，因此2D能谱的纵轴为ch1
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
    spec2D_small{j} = resizemat(spec2D,small_dim);
    
    figure;
    h=imagesc(size(spec2D)/size(spec2D_small{j}): ...
        size(spec2D)/size(spec2D_small{j}): ...
        size(spec2D),size(spec2D)/size(spec2D_small{j}): ...
        size(spec2D)/size(spec2D_small{j}): ...
        size(spec2D), ...
        spec2D_small{j});
    hc=colorbar;
    %set(h,'edgecolor','none'); % pcolor
    hc.Title.String = 'Count';
    caxis([0,500]);
    %caxis([0,max(max(spec2D_small{j}(2:end,2:end)))]);
    xlabel(['Ch',num2str(chy)]);
    ylabel(['Ch',num2str(chx)]);
    title(['Time delay = ',num2str(timeDelay(j)),' ns No.j=',num2str(j)]);
    writeVideo(v,getframe(gcf));
end
close(v);
save([dataName,'-2Dspec-vsTime'],'spec2D_small', ...
'timeDelay','coin_time','dataName','chx','chy');

