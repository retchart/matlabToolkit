clear;close all;
energyStep = 0.01; % MeV
plotOrNot = 1;

fileList = dir('*-nml.mat');
if size(fileList,1)~=0
    delete(fileList.name); % 删除旧标准化能谱
end

fileList = dir('*.mat');
for i = 1:size(fileList,1)
    sgnl = nmlAndSave1Mat(fileList(i).name,plotOrNot,energyStep);
    disp(['Saved:',fileList(i).name]);
end
disp('Success: task done');
