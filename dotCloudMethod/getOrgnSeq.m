function [spec,orgnSpecs] = getOrgnSeq(folderName,timeOf1File)
% 读取并保存为mat一个文件夹所有的spe能谱
% folderName: 文件夹名称
% timeOf1File: 每一个文件的测量时长（单位：s）
% orgnSpecs: 每一列为一个文件的原始能谱
% spec: 单列矩阵，平均能谱，纵轴为cps/ch
dir1=dir(folderName);

%% 寻找能谱开头
specStartStr = '$DATA:';
fid = fopen([folderName,'\',dir1(3).name],'r');
for i =1:100 % 前100行能找到能谱头
    dataRow = fgetl(fid);
    if strncmp(dataRow,specStartStr,6)
        specStartRow = i;
        break;
    end
end
fclose(fid);

%% 导入原始能谱至orgnSpecs
orgnSpecs = [];
for i = 3:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        orgnSpecs = [orgnSpecs,d.data];
    end
    disp(num2str(i));
end
spec=sum(orgnSpecs,2)/(size(orgnSpecs,2)*timeOf1File);


% save(folderName,'orgnSpecs','spec');
% 
% figure;
% semilogy(spec);
% hold on;xlabel('Channel');ylabel('Count rate(cps/ch)');
% title(folderName);
% disp(['Count rate(count/1 file measure time):',num2str(sum(spec))]);
end