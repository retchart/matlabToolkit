function [bkgd,smpl] = loadSpecSeq(bkgdFileName,smplFileName)
% 输入本底或样品nml文件名或文件夹名，导入bkgd,smpl矩阵，每一列为一标准化能谱
% 

load([bkgdFileName,'.mat']);
bkgd = sgnl;
load([smplFileName,'.mat']);
smpl = sgnl;
end
