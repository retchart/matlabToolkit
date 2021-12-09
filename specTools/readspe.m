function s = readspe(fileName,specStartRow)
% 提取单个.spe中的能谱信息,提取多文件可用handle_getspe
% 若使用了specStartRow，本代码不验证其是否为合理的行
% 若specStartRow=21，用时0.701617->0.671748s好像改善也不大
%
% INPUTS：
% fileName:文件名
% specStartRow: （可选）能谱起始行号-1（一般是$DATA的行号）
%
% OUTPUTS：
% s.spec 能谱原始数据，无刻度单列能谱，纵坐标计数count/ch
% s.specStartRow: 能谱起始行，$DATA:$行号，import要+1
% s.startTime: 测量起始时刻(matlab datevec格式)
% s.realtime: 测量时长(实时间，s)
% s.livetime：测量活时间(s)
%
str_specStart = '$DATA:';
str_walltime = '$DATE_MEA:'; % 采集起始时刻
str_measuretime = '$MEAS_TIM:'; % 活时间和实时间
infoFlag = 3; % 读取信息指示器，每读到一个减1，=0则退出
s.startTime = [];
s.livetime = [];
s.realtime = [];
s.spec = [];
suffixs = {'.spe','.Spe','.SPE'};
if contains(fileName,suffixs)
    fid = fopen(fileName,'r');
else
    fid = fopen([fileName,'.spe'],'r');
end

i = 0;
while 1 && infoFlag
    dataRow = fgetl(fid);i = i+1;
    if strncmp(dataRow,str_walltime,10)
        % 采集起始时刻
        s.startTime = datevec(fgetl(fid));i=i+1;
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_measuretime,10)
        % 活时间和实时间
        tt = str2num(fgetl(fid));i=i+1;
        s.livetime = min(tt);
        s.realtime = max(tt);
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_specStart,6)
        specStartRow = i;
        infoFlag = infoFlag - 1;
    end
    if (nargin == 2 && infoFlag ==1) || ~infoFlag
        % 已指定能谱起始行或读完数据，退出循环
        break; 
    end
end
s.specStartRow = specStartRow;
fclose(fid);
fileData = importdata(fileName,'',specStartRow+1); % 导入能谱
s.spec = fileData.data;% 无刻度单列能谱，纵坐标计数count/ch
end

