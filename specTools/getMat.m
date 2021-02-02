function [spec,sgnl] = getMat(folderName,header)
% Read spectra from .spe files and save to one matrix "sgnl"
% 
% Inputs:
% folderName: 
% header: Regular expression of interested file name. Example: CH0
% 
% Outputs:
% sgnl: each column is one spectrum, number of columns corresponds to the
% number of files in the folder whose name starts with header

dir1=dir([folderName,'\',header]);
sgnl = [];

%% 寻找能谱开头
s = readspe([folderName,'\',dir1(3).name],specStartRow);
specStartRow = s.specStartRow;

%% 导入能谱
% 目前只根据行号导入能谱，以后有需要可以用readspe读全能谱信息
for i = 1:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        sgnl = [sgnl,d.data];
    end
    disp(num2str(i));
end

spec=sum(sgnl,2)/size(sgnl,2);

figure;
semilogy(spec);
hold on;xlabel('Channel');ylabel('Count rate(cnt/1 file measure time)');
grid on;
title(folderName);
disp(['Count rate(count/1 file measure time):',num2str(sum(spec))]);

header1=cell2mat(regexp(header,'[A-Z|a-z|0-9]','match'));%正则匹配 提出字母+数字
save([header1,'-',folderName],'sgnl','spec');

end