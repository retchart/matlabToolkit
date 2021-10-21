%% 展示list文件的逐特定时长计数率
clear;close all;
load('st490.mat');
li = s.list{1,1};li(:,1)=li(:,1)/1e9; % unit:s
clearvars -except li;
period = 60; % s
t0 = 0; % 起始测量时刻 unit:s
disp(['Measuring real time: ',num2str((li(end,1)-li(1,1)),'%d'),' s']);

%% 展示能谱
% 首1min，首10min，后1min，总，
disp('Preparing fixed spectrums...');
figure;
spec = [];
subplot(2,2,1);
thisli = li(find(li(:,1)<60),:);
h = histogram(thisli(:,3),0:8192);xlabel('Ch');ylabel('Count in first 1 min');
spec(:,1)=h.BinCounts'/60;
subplot(2,2,2);
thisli = li(find(li(:,1)<600),:);
h = histogram(thisli(:,3),0:8192);xlabel('Ch');ylabel('Count in first 10 min');
spec(:,2)=h.BinCounts'/600;
subplot(2,2,3);
thisli = li(find(li(:,1)>max(li(:,1))-60),:);
h = histogram(thisli(:,3),0:8192);xlabel('Ch');ylabel('Count in last 1 min');
spec(:,3)=h.BinCounts'/60;
subplot(2,2,4);
thisli = li;
h = histogram(thisli(:,3),0:8192);xlabel('Ch');ylabel('Count in all time');
spec(:,4)=h.BinCounts'/max(li(:,1));
figure;
semilogy([1:size(spec,1)]',spec);xlabel('Ch');ylabel('Count rate(cps)');
legend({['First 1 min:',num2str(sum(spec(:,1))),' cps'], ...
    ['First 10 min:',num2str(sum(spec(:,2))),' cps'], ...
    ['Last 1 min:',num2str(sum(spec(:,3))),' cps'], ...
    ['Whole time:',num2str(sum(spec(:,4))),' cps']});

%% 展示指定能谱
disp('Preparing specified spectrums...');
figure;
for i = 1:2:10
    [spe(:,i),~] = list2spe(li,[60*i-60,60*i],[],[1:7000]);
    semilogy(spe(:,i));hold on;
end
sumCount = sum(spe,1)'/60;
xlabel('Ch');ylabel('Count');legend(num2str(sumCount));

%% 取道址范围展示计数率变化
[~,li] = list2spe(li,[],[],[1:7000]);
figure;
h = histogram(li(:,1),0:period:li(end,1));
xlabel('second');ylabel('count');title('原始数据逐时间片的计数变化，变量Rate为横轴min的计数率变化');
rate = [(h.BinEdges(2:end)'+t0)/60,h.BinCounts'/period]; 

