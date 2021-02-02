%% 读取高纯锗循环测量的缓发能谱
% 使用后需手动形成pks.mat，然后调用
% handle_nmlHPGe 进行稳谱 
% handle_halflife分析每个峰的半衰期 或
% handle_acticity分析活度 或

clear;close all;
dir1 = dir('AUTO*.spe');
tZero= 0; % 首个能谱开始测量时刻(s)
t_start = cell(1,length(dir1)); % 时间字符串
t = zeros(1,length(dir1));
t_realtime = zeros(1,length(dir1));


for i = 1:length(dir1)
    disp(['Processing:',num2str(i),'/',num2str(length(dir1))]);
    s = readspe(dir1(i).name);
    t_start{1,i} = s.startTime; % 时间字符串
    t_realtime(1,i) = s.realtime;
    orgnSpec(:,i) = s.spec;
end
for i = 1:length(dir1) 
    t(1,i) = etime(t_start{1,i},t_start{1,1})+tZero;% 计算测量时刻
    sgnl(:,i)=orgnSpec(:,i)/t_realtime(1,i);
end

figure;
plot(t,sum(sgnl,1),'.-');
xlabel('Time(s)');
ylabel('Total count rate(cps/ch)');

save('data','orgnSpec','t','t_realtime','sgnl','t_start');