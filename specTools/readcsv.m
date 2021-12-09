function s = readcsv(filename,specStartRow)
% 提取APG7400输出的单个.csv中的能谱信息
% 若使用了specStartRow，本代码不验证其是否为合理的行
%
% INPUTS：
% filename:文件名
% specStartRow: （可选）能谱起始行号-1（一般是$DATA的行号）
%
% OUTPUTS：
% s.spec 能谱原始数据，无刻度单列能谱，纵坐标计数count/ch
% s.specStartRow: 能谱起始行，[Data]行号，import要+1
% s.startTime: 测量起始时刻(matlab datevec格式)
% s.realtime: 测量时长(实时间，s)
% s.livetime：测量活时间(s)
%
str_specStart = '[Data]';
str_walltime = 'Start Time'; % 采集起始时刻
str_realtime = 'Real time'; % 多列实时间
str_livetime = 'Live time'; % 多列活时间
infoFlag = 4; % 读取信息指示器，每读到一个减1，=0则退出
s.startTime = [];
s.livetime = [];
s.realtime = [];
s.spec = [];
fid = fopen(filename,'r');
i = 0;

while 1 && infoFlag
    dataRow = fgetl(fid);i = i+1;
    if strncmp(dataRow,str_walltime,length(str_walltime))
        % 采集起始时刻
        nownow = datevec(now);
        s.startTime = datevec(dataRow(length(str_walltime)+1:end));
        %s.startTime(1,1) = nownow(1); % 将两位数年份改为4位数
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_realtime,length(str_realtime))
        % 活时间和实时间
        s.realtime = str2num(dataRow(length(str_realtime)+1:end));
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_livetime,length(str_livetime))
        s.livetime = str2num(dataRow(length(str_livetime)+1:end));
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_specStart,length(str_specStart))
        specStartRow = i;
        infoFlag = infoFlag - 1;
    end
    if (nargin == 2 && infoFlag ==1) || ~infoFlag
        % 已指定能谱起始行或读完数据，退出循环
        break;
    end
end
s.specStartRow = specStartRow; 
s.realtime = repmat(s.realtime,1,size(s.livetime,2));
fclose(fid);
fileData = importdata(filename,',',specStartRow+1); % 导入能谱
s.spec = fileData.data(:,2:end);% 无刻度单列能谱，纵坐标计数count/ch，舍去第一列道址
end

