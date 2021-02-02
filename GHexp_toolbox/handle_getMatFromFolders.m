clear; close all;
folderNameExp = 'OCT15*';
a=dir(folderNameExp);
for i=1:size(a,1)
    if a(i).isdir==1
        [~,~] = getMat(a(i).name,'CH0*');
        [~,~] = getMat(a(i).name,'CH1*');
        [~,~] = getMat(a(i).name,'CH2*');
    end
end

% 下一步使用handle_caliNeutron校正中子计数
