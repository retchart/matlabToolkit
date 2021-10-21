function [spec,summary] = readOutput(fileName)
spec = [];
summary = [];
fidin = fopen(fileName);
if fidin == -1
    warning(['Error: Reading ',fileName]);
    return;
end
while 1 % 寻找能谱头
    dataRow = fgetl(fidin);
    if strncmp(dataRow,' cell ',6)
        dataRow = fgetl(fidin);
        if strncmp(dataRow,'      energy',12)
            break;
        end
    elseif dataRow == -1
        fclose(fidin);
        disp('ERROR: Did not see the sign of interested data');
        return;
    end
end
while 1 % 读取能谱内容
    dataRow = fgetl(fidin);
    % disp(dataRow);
    if strncmp(dataRow,'      total',11) % 最后总和行
        summary = str2double(regexp(dataRow,'\s+','split'));
        summary = summary(1,3:end);
        break;
    end
    spec = [spec;str2double(regexp(dataRow,'\s+','split'))];
end

fclose(fidin);
spec(:,1)=[]; % 删除空列
end
