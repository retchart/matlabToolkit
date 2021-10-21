%% 逐峰拟合HPGe能谱分析核素活度
% 未完成

clear;close all;
load('pks.mat');
filename = 'data-nml.mat';
load(filename);
result = zeros(size(pks,1),3);
result(:,1) = pks(:,1);

%% 有样品的第一个能谱
f=figure;
semilogy(sum(sgnl,1));xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
nStart = input('Enter the first spec No. to be fit: ');
if isempty(nStart)
    nStart = 1;
end

nStop = input('Enter the final spec No. to be fit: ');
if isempty(nStop)
    nStart = size(orgnSpec,2);
end

close(f);

%% 计算长期谱
spec = sum(orgnSpec(:,nStart:nStop),2); % 单列计数谱
tsum = sum(t_realtime(1,nStart:nStop));

%% 逐峰分析，假设峰区为正负10道
chRange = (-10:10)';
for i = 1:size(pks,1)
    figure;
    [result(i,3),~,~,~,~] = fitPeak(chRangepks(i,1),spec(chRange+pks(i,1)),1);
    % result(:,1:3) 道址，能量(暂未纳入)，峰面积
    pause(0.2);
end