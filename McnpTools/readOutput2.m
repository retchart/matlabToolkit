function [spec,summary] = readOutput2(fileName)
% 相比readOutput，新增支持单文件内多个能谱的读取
spec = [];
summary = [];
flag = 0 ; % 是否读到能谱
fidin = fopen(fileName);
if fidin == -1
    warning(['Error: Reading ',fileName]);
    return;
end
dataRow = fgetl(fidin);
while dataRow ~= -1
    spec0=[];
    while 1 % 寻找能谱头
        if strncmp(dataRow,' cell ',6)
            dataRow = fgetl(fidin);
            if strncmp(dataRow,'      energy',12)
                flag = 1;
                break;
            end
        elseif dataRow == -1
            if flag
                spec(:,[1:4:end])=[]; % 删除空列
            else
                warning('No spectrum in the file');
            end
            fclose(fidin);
            return;
        end
        dataRow = fgetl(fidin);
    end
    while 1 % 读取能谱内容
        dataRow = fgetl(fidin);
        % disp(dataRow);
        if strncmp(dataRow,'      total',11) % 最后总和行
            summary0 = str2double(regexp(dataRow,'\s+','split'));
            summary = [summary;summary0(1,3:end)];
            break;
        end
        spec0 = [spec0;str2double(regexp(dataRow,'\s+','split'))];
    end
    spec = [spec,spec0];
end
end
