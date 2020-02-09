function orgnSpecSeq = getOrgnSeq(folderName,displayOrNot)
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

%% 储存原始能谱至orgnSpecs
orgnSpecSeq = [];
if displayOrNot
    f = waitbar(0,['Loading from folder ',folderName]);
end
for i = 3:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        orgnSpecSeq = [orgnSpecSeq,d.data];
    end
    if displayOrNot
        waitbar(i/size(dir1,1),f,['Loading ',num2str(i), ...
            '/',num2str(size(dir1,1)),' from folder ',folderName]);
    end
end
end