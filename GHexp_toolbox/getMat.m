function [spec,sgnl] = getMat(folderName)
dir1=dir(folderName);
sgnl = [];

%% 寻找能谱开头
specStartStr = '$DATA:';
fid = fopen([folderName,'\',dir1(3).name],'r');
for i =1:2100
    dataRow = fgetl(fid);
    if strncmp(dataRow,specStartStr,6)
        specStartRow = i;
        break;
    end
end
fclose(fid);

%% 导入能谱
for i = 3:size(dir1,1)
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
title(folderName);
disp(['Count rate(count/1 file measure time):',num2str(sum(spec))]);

save(folderName,'sgnl','spec');

end