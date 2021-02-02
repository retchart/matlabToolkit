%% 获取同文件夹下的多个spe能谱信息

%clear;close all;
dir1 = dir('fake*.spe');
tZero= 0; % 首个能谱开始测量时刻(s)
t_start = cell(1,length(dir1)); % 时间字符串
t = zeros(1,length(dir1));
t_realtime = zeros(1,length(dir1));
pErr = [];
tic;
for i = 1:length(dir1)
    disp(['Processing:',num2str(i),'/',num2str(length(dir1))]);toc;
    s = readspe(dir1(i).name);
    t_start{1,i} = s.startTime; % 时间字符串
    t_realtime(1,i) = s.realtime;
    orgnSpec(:,i) = s.spec;
    if i>1 % 储存下重复的能谱
        if isequal(t_start{1,i},t_start{1,i-1})
            pErr = [pErr,i];
        end
    end
end
orgnSpec(:,pErr)=[];
t(:,pErr)=[];
t_realtime(:,pErr)=[];

for i = 1:length(t) 
    t(1,i) = etime(t_start{1,i},t_start{1,1})+tZero;% 计算测量时刻
    spec(:,i)=orgnSpec(:,i)/t_realtime(1,i);
end

figure;
plot(t,sum(spec,1),'.-');
xlabel('Time(s)');
ylabel('Total count rate(cps/ch)');

save('data','orgnSpec','t','t_realtime','spec');
