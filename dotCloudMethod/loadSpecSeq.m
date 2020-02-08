function specSeq = loadSpecSeq(fileOrFolderName)
% 输入本底或样品nml文件名或文件夹名，导入bkgd,smpl矩阵，每一列为一标准化能谱
%

if contains(fileOrFolderName,'eV-nml.mat') % 标准化文件
    load([fileOrFolderName,'.mat']);
    specSeq = sgnl;
else % 文件夹
    
end

end
