%% 从seq文件获得2维能谱
clear;close all;
dataName = 'co';% Name of the list mode file
orgSeq=importdata([dataName,'.txt']);
coin_time = 500; % unit: ns
maxCh1 = 8192;
maxCh2 = maxCh1;
winCh1 = [200,8192];
winCh2 = [350,3575];
timeDelay = (-2.5e3:50:2e3)'; % unit: ns

spec2D_small = {};
coinCurve = [timeDelay,zeros(size(timeDelay,1),1)];
for j = 1:length(timeDelay)
    seq = orgSeq;
    seq(find(seq(:,2)==2),1) = seq(find(seq(:,2)==2),1) - timeDelay(j);
    seq = sortrows(seq);
    % 画2维能谱
    spec2D = zeros(maxCh1,maxCh2);
    for i = 1:size(seq,1)-1
        if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2)
            spec2D(seq(i,3),seq(i+1,3)) = spec2D(seq(i,3),seq(i+1,3))+1;
            continue;
        elseif seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)>seq(i+1,2)
            spec2D(seq(i+1,3),seq(i,3)) = spec2D(seq(i+1,3),seq(i,3))+1;
            continue;
        end
        if seq(i,2)==1
            spec2D(seq(i,3),1) = spec2D(seq(i,3),1)+1;
        elseif seq(i,2)==2
            spec2D(1,seq(i,3)) = spec2D(1,seq(i,3))+1;
        else
            error('Invalid channel');
        end
        if mod(i,1e5)==0
            disp(['Time delay:',num2str(j),'/',num2str(length(timeDelay)), ...
                ' Event No.',num2str(i),'/',num2str(length(seq))]);
        end
    end
    coinCurve(j,2) = sum(sum(spec2D(winCh1(1):winCh1(2),winCh2(1):winCh2(2))));
    %coinCurve(j,2) = sum(sum(spec2D(2:end,2:end)));
    %spec2D_small{j} = resizemat(spec2D,[1024,1024]); 
end
figure;
plot(coinCurve(:,1),coinCurve(:,2),'.-');
xlabel('Time delay(ns)');
ylabel('Coincidence count');

save([dataName,'-coinCurve']);

