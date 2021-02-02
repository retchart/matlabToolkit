%% 标准化.mat中的sgnl能谱并保存至"*-nml.mat"中
% 修改uncaliMatName 即可直接运行
% 若对展示的ROI不满意，可以输入0停止本程序并修改caliParam
clear;close all;
delOrNot = 1; % 是否删除工作目录下已存在的以nml结尾的标准化文件
plotOrNot = 1; % 是否画拟合等图
unNmlMatName = 'orgn.mat';
caliParam.maxE = 12; % MeV
caliParam.EStep = 0.01; % MeV
caliParam.tPerFile = 8*60; % 大概每个能谱测多久，用以删除极小的拟合值，单位s
caliParam.E(1,1) = 2.223;caliParam.Ewin(1,:) = [1437,1700];
%caliParam.E(2,1) = 4.945;caliParam.Ewin(2,:) = [1632,1705];
%caliParam.E(3,1) = 7.638;caliParam.Ewin(3,:) = [2691,2823];
caliParam.E(2,1) = 7.638;caliParam.Ewin(2,:) = [5173,5547];
%caliParam.E(3,1) = 0.478;caliParam.Ewin(3,:) = [145,201];

%% 删除旧的标准化能谱
% if delOrNot
%     delete('*-nml.mat');
% end

%% 载入示例能谱帮助判断能峰区间
fileList = dir(unNmlMatName);
load(fileList(1).name);
thisSpec = sum(sgnl,2)/size(sgnl,2);
thisSpec1 = sgnl(:,1);
semilogy(thisSpec,'b.-');hold on; xlabel('Channel');ylabel('Count rate');
semilogy(thisSpec1,'g.-');hold on; xlabel('Channel');ylabel('Count rate');
title({'Sample spectrum showing ROIs which are used for calibration';fileList(1).name});
for i = 1:length(caliParam.E)
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    semilogy(winwin,thisSpec(winwin),'r.-');
    semilogy(winwin,thisSpec1(winwin),'r.-');
    text(winwin(1), ...
        2*max(thisSpec(winwin))-min(thisSpec(winwin)), ...
        num2str(caliParam.E(i)),'Color','r');
end
hold off;

%% 根据示例ROI决定是否标准化
tmp = input('Accept(enter) or not(any number): ');
if isempty(tmp) % 同意ROI，可继续处理
    for i = 1:size(fileList,1)
        thisName = fileList(i).name;
        load(thisName,'sgnl');
        [sgnl,eAxisOld,eAxisNew] = nmlAndSave1Mat(sgnl,caliParam,plotOrNot);
        if plotOrNot
            title(fileList(i).name);
        end
        disp(['Processed:',fileList(i).name]);
        save([thisName(1:length(thisName)-4), ...
            '-step',num2str(caliParam.EStep),'MeV-nml.mat',],'sgnl','eAxisOld','eAxisNew');
    end
    disp('Success: task done');
else % 不同意ROI，结束本程序
    disp('Warning: task terminate because of user veto ROI');
    return;
end
