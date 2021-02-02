%% 标准化.mat中的spec能谱并保存至"*-nml.mat"中
% 修改uncaliMatName 即可直接运行
% 若对展示的ROI不满意，可以输入0停止本程序并修改caliParam
clear;close all;
caliParam.EStep = 0.0001; % MeV
caliParam.maxE = 12;
delOrNot = 1; % 是否删除工作目录下已存在的以nml结尾的标准化文件
plotOrNot = 1; % 是否画拟合等图
unNmlMatName = 'spec.mat';
caliParam.tPerFile = 60;

caliParam.E(1,1) = 1.46082;caliParam.Ewin(1,:) = [3355,3399];
caliParam.E(2,1) = 2.614511;caliParam.Ewin(2,:) = [6024,6077];

%% 删除旧的标准化能谱
if delOrNot
    delete('*-nml.mat');
end

%% 载入示例能谱帮助判断能峰区间
fileList = dir(unNmlMatName);
load(fileList(1).name);
thisSpec = sgnl(:,1);
semilogy(thisSpec,'b.-');hold on; xlabel('Channel');ylabel('Count');
title({'Sample spectrum showing ROIs which are used for calibration';fileList(1).name});
for i = 1:length(caliParam.E)
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    semilogy(winwin,thisSpec(winwin),'r.-');
    text(winwin(1), ...
        2*max(thisSpec(winwin))-min(thisSpec(winwin)), ...
        num2str(caliParam.E(i)),'Color','r');
end
hold off;

%% 根据示例ROI决定是否标准化
tmp = input('Accept(enter) or not(any number): ');
if isempty(tmp) % 同意ROI，可继续处理
    for i = 1:size(fileList,1)
        sgnl = nmlAndSave1Mat(fileList(i).name,caliParam,plotOrNot);
        disp(['Processed:',fileList(i).name]);
    end
    disp('Success: task done');
else % 不同意ROI，结束本程序
    disp('Warning: task terminate because of user veto ROI');
    return;
end
